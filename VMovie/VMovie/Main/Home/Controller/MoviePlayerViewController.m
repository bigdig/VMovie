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
#import "ZFPlayerView.h"
#import <WebKit/WebKit.h>

@interface MoviePlayerViewController ()<WKScriptMessageHandler,WKUIDelegate>
/**webView */
@property (nonatomic, strong) WKWebView *webView;
/**进度条 */
@property (nonatomic, strong) UIProgressView *progressView;
/**播放器 */
@property (nonatomic, strong) ZFPlayerView *playerView;
@end

@implementation MoviePlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
//    http://app.vmoiver.com/48318?qingapp=app_new&debug=1
    UIView *blackView = [[UIView alloc] init];
    blackView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:blackView];
    [blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@20);
    }];
    
    self.playerView = [ZFPlayerView sharedPlayerView];
    [self.view addSubview:self.playerView];
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(20);
        // 注意此处，宽高比16：9优先级比1000低就行，在因为iPhone 4S宽高比不是16：9
        make.height.equalTo(self.playerView.mas_width).multipliedBy(9.0f/16.0f).with.priority(750);
    }];
    [self getMovieURL];
    
    // 返回按钮事件
    __weak typeof(self) weakSelf = self;
    self.playerView.goBackBlock = ^{
        NSLog(@"%s",__func__);
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
   
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.preferences = [[WKPreferences alloc] init];
    config.preferences.minimumFontSize = 10;
    config.preferences.javaScriptEnabled = YES;
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    config.userContentController = [[WKUserContentController alloc] init];
    [config.userContentController addScriptMessageHandler:self name:@"VMovie"];
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.playerView.mas_bottom);
    }];
    
    NSString *urlString = [NSString stringWithFormat:@"http://app.vmoiver.com/%@?qingapp=app_new&debug=1",self.movie.postid];
    NSURL *vURL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:vURL];
    [self.webView loadRequest:request];
    [self.view beginLoading];
    
    self.webView.UIDelegate = self;
    
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.progressView];
    self.progressView.backgroundColor = [UIColor redColor];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.webView);
        make.height.equalTo(@2);
    }];
    
    [self.webView addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void) getMovieURL {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"postid"] = self.movie.postid;
    [[YZNetworking sharedManager] GET:@"http://app.vmoiver.com/apiv3/post/view" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString  *urlString = [responseObject[@"data"][@"content"][@"video"] firstObject][@"qiniu_url"];
        self.playerView.videoURL = [NSURL URLWithString:urlString];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.playerView resetPlayer];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endLoading];
    self.navigationController.navigationBarHidden = NO;

}


// 哪些页面支持自动转屏
- (BOOL)shouldAutorotate{
    
    UINavigationController *nav = self.navigationController;
    // MoviePlayerViewController这个页面支持自动转屏
    if ([nav.topViewController isKindOfClass:[MoviePlayerViewController class]]) {
        return YES;  // 调用AppDelegate单例记录播放状态是否锁屏
    }
    return NO;
}

// ViewController支持哪些转屏方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    UINavigationController *nav = self.navigationController;
    if ([nav.topViewController isKindOfClass:[MoviePlayerViewController class]]) { // MoviePlayerViewController这个页面支持转屏方向
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }else { // 其他页面支持转屏方向
        return UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskPortrait;
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


@end
