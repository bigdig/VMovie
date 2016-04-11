//
//  MoviePlayerViewController.m
//  VMovie
//
//  Created by wyz on 16/3/15.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "MoviePlayerViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "Movie.h"
#import "YZMoviePlayerView.h"
#import <WebKit/WebKit.h>
#import "UIBarButtonItem+Custom.h"
#import "UINavigationBar+Custom.h"
#import "WeakScriptMessageDelegate.h"
#import "VMToolBar.h"
#import "CommentTableViewController.h"

#define SCREEN_ASPECTRATIO [UIScreen mainScreen].bounds.size.width/[UIScreen mainScreen].bounds.size.height
#define PLAYERVIEW_HEIGHT ([UIScreen mainScreen].bounds.size.width * SCREEN_ASPECTRATIO)

@interface MoviePlayerViewController ()<WKScriptMessageHandler,WKUIDelegate,UIScrollViewDelegate,UITableViewDelegate>
/**webView */
@property (nonatomic, strong) WKWebView *webView;
/**进度条 */
@property (nonatomic, strong) UIProgressView *progressView;
/**播放器 */
@property (nonatomic, strong)  YZMoviePlayerView *playerView;

/**工具栏 */
@property (nonatomic, strong) VMToolBar *toolBar;

/**commentTabelView */
@property (nonatomic, strong) UITableView *tableView;

/**显示评论 */
@property (nonatomic, assign) BOOL showComment;


@end

@implementation MoviePlayerViewController
   


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
   
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.preferences = [[WKPreferences alloc] init];
    config.preferences.minimumFontSize = 10;
    config.preferences.javaScriptEnabled = YES;
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
//    config.userContentController = [[WKUserContentController alloc] init];
//    [config.userContentController addScriptMessageHandler:self name:@"VMovie"];
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    config.userContentController = userContentController;
    [userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"VMovie"];
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-44);
    }];
    
    NSString *urlString = [NSString stringWithFormat:@"http://app.vmoiver.com/%@?qingapp=app_new&debug=1",self.movie.postid];
    NSURL *vURL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:vURL];
    [self.webView loadRequest:request];
    [self.view beginLoading];
    
    self.webView.UIDelegate = self;
    self.webView.scrollView.delegate = self;
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(PLAYERVIEW_HEIGHT, 0, 0, 0);
    self.webView.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(PLAYERVIEW_HEIGHT, 0, 0, 0);
    
    self.playerView = [[YZMoviePlayerView alloc] init];
    self.playerView.title = self.movie.title;
    [self.webView addSubview:self.playerView];
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.webView);
        make.height.equalTo(self.playerView.mas_width).multipliedBy(SCREEN_ASPECTRATIO);
    }];
    self.playerView.videoUrl = @"";
    [self getMovieURL];
    [self.playerView play];
    
    
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.progressView];
    self.progressView.backgroundColor = [UIColor redColor];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.webView);
        make.top.equalTo(self.webView).offset(PLAYERVIEW_HEIGHT);
        make.height.equalTo(@2);
    }];
    
    [self.webView addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    UIBarButtonItem *backItem = [UIBarButtonItem itemWithImage:@"img_player_back" HighImage:@"img_player_back" target:self action:@selector(backItemClick)];
    self.navigationItem.leftBarButtonItem = backItem;
    UIBarButtonItem *shareItem = [UIBarButtonItem itemWithImage:@"img_player_share" HighImage:@"img_player_share" target:self action:@selector(shareItemClick)];
    self.navigationItem.rightBarButtonItem = shareItem;
    UIButton *titleButton = [UIButton new];
    [titleButton setTitle:@"立即播放" forState:UIControlStateNormal];
    [titleButton setImage:[UIImage imageNamed:@"img_details_play"] forState:UIControlStateNormal];
    titleButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    titleButton.width = 200;
    titleButton.height = 44;
    @weakify(self);
    [[titleButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
            if (self.playerView.isPlaying) {
                [self.playerView pause];
            } else {
                [self.playerView play];
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.view).offset(PLAYERVIEW_HEIGHT);
                }];
            }
            [self scrollViewDidScroll:self.webView.scrollView];
    }];
    self.navigationItem.titleView = titleButton;
    
    //去掉黑线
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];

    [self setupComment];
}

- (void) setupComment {
    
    CommentTableViewController *commentVc = [[CommentTableViewController alloc] init];
    commentVc.movie = self.movie;
    __weak typeof (self) weakself = self;
    commentVc.commentCountBlock = ^(NSInteger count) {
                NSString *commentCount = count > 0 ? [NSString stringWithFormat:@"%ld",count] : @"";
                [weakself.toolBar.commentButton setTitle:commentCount  forState:UIControlStateNormal];
    };
    commentVc.ClickHeaderBlock = ^{
        [weakself.view endEditing:YES];
    };
    commentVc.beginScrollBlock = ^{
       [weakself.view endEditing:YES];
    };
    self.tableView = (UITableView *)commentVc.view;
    self.tableView.hidden = YES;
//    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-44);
        make.top.equalTo(self.view).offset(PLAYERVIEW_HEIGHT);
    }];
    [self addChildViewController:commentVc];
    
    self.toolBar = [VMToolBar new];
    [self.view addSubview:self.toolBar];
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@44);
    }];

    self.toolBar.commentBlock = ^{
        weakself.showComment = !weakself.showComment;
        weakself.tableView.hidden = weakself.showComment?NO:YES;
        if (weakself.showComment) {
            
            if (weakself.playerView.isPlaying) {
                [weakself.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(weakself.view).offset(PLAYERVIEW_HEIGHT);
                }];
            } else {
                CGFloat offsetY = MIN(PLAYERVIEW_HEIGHT - 64, weakself.webView.scrollView.contentOffset.y + PLAYERVIEW_HEIGHT);
                [weakself.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(weakself.view).offset(PLAYERVIEW_HEIGHT-offsetY);
                }];
            }
            
        }
    };
}

- (void) keyboardWillChangeFrame:(NSNotification *) noti {
    
    CGRect keyboardF = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [self.toolBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(keyboardF.origin.y - App_Frame_Height - 20);
    }];
    
    [UIView animateWithDuration:duration animations:^{
        [self.toolBar layoutIfNeeded];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.webView.scrollView) {
        CGFloat offsetY = scrollView.contentOffset.y;
        
        if (offsetY > -PLAYERVIEW_HEIGHT && !self.playerView.isPlaying) {
            [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.webView).offset(-offsetY - PLAYERVIEW_HEIGHT);
            }];
            CGFloat alpha = MIN(1, 1 - ((-PLAYERVIEW_HEIGHT + 64 - offsetY) / 64));
            [self.navigationController.navigationBar yz_setBackgroundImage:[UIImage imageNamed:@"img_place_bg"] alpha:alpha];
            [self.navigationController.navigationBar yz_setElementsAlpha:alpha];
            self.playerView.userInteractionEnabled = NO;
        } else {
            [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.webView);
            }];
            [self.navigationController.navigationBar yz_setBackgroundImage:[UIImage imageNamed:@"img_place_bg"] alpha:0.0];
            [self.navigationController.navigationBar yz_setElementsAlpha:0.0];
            self.playerView.userInteractionEnabled = YES;
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (void) backItemClick {
 
    [self.playerView resetPlayer];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) shareItemClick {
    NSLog(@"%s",__func__);
}

- (void) getMovieURL {
    
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"postid"] = self.movie.postid;
//    [[YZNetworking sharedManager] GET:@"http://app.vmoiver.com/apiv3/post/view"  parameters:params success:^(id  _Nullable responseObject) {
//        NSString  *urlString = [responseObject[@"data"][@"content"][@"video"] firstObject][@"qiniu_url"];
//        self.playerView.videoUrl = urlString;
//         
//    } failure:nil];
    
    self.playerView.videoUrl = @"http://baobab.wdjcdn.com/1456665467509qingshu.mp4";
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar yz_setBackgroundImage:[UIImage imageNamed:@"img_place_bg"] alpha:0.0];
    [self.navigationController.navigationBar yz_setElementsAlpha:0.0];
    [self scrollViewDidScroll:self.webView.scrollView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endLoading];
    [self.navigationController.navigationBar yz_reset];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        self.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [self.navigationController.navigationBar yz_setBackgroundImage:[UIImage imageNamed:@"img_place_bg"] alpha:0.0];
        [self.navigationController.navigationBar yz_setElementsAlpha:0.0];
//        [self scrollViewDidScroll:self.webView.scrollView];
        
    }else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        self.view.backgroundColor = [UIColor blackColor];
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        
    }
}

#pragma mark - UIWebViewDelegate 

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"loading"]) {
        
    } else if ([keyPath isEqualToString:@"title"]) {
        self.navigationItem.title = self.webView.title;
    } else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webView.estimatedProgress;
    }
    
    if (!self.webView.loading) {
        [self.view endLoading];
        [self.webView evaluateJavaScript:  @"var links = document.getElementsByClassName('new-view-link');"
         " for(var i=0;i<links.length;i++){"
         "var link = links[i];"
         " link.onclick = function(){"
         " var viewId = this.getAttribute('data-id');"
         "var viewType = this.getAttribute('data-type');"
         "window.webkit.messageHandlers.VMovie.postMessage({'viewId': viewId,'viewType':viewType});"
         "  }"
         "  }" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
         }];
        
        [UIView animateWithDuration:0.5 animations:^{
            self.progressView.alpha = 0;
        }];
    }
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"VMovie"]) {
        if ([message.body[@"viewType"] integerValue] != 0) {
            return;
        }
        Movie *movie = [[Movie alloc] init];
        movie.postid = message.body[@"viewId"];
        MoviePlayerViewController *moviePlayerVc = [[MoviePlayerViewController alloc] init];
        moviePlayerVc.movie = movie;
        [self.playerView pause];
        [self.navigationController pushViewController:moviePlayerVc animated:YES];
    }
}

#pragma mark - WKUIDelegate
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
     [self.playerView cancelAutoHidePlayerUI];
    [self.webView removeObserver:self forKeyPath:@"loading"];
     [self.webView removeObserver:self forKeyPath:@"title"];
     [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView setUIDelegate:nil];
    [self.webView.scrollView setDelegate:nil];
    [[self.webView configuration].userContentController removeScriptMessageHandlerForName:@"Vmovie"];
    
    NSLog(@"%s",__func__);
}

@end
