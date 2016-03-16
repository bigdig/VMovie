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

@interface MoviePlayerViewController ()<UIWebViewDelegate>


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
    
    self.playerView = [ZFPlayerView setupZFPlayer];
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
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.backgroundColor = [UIColor whiteColor];
    NSString *urlString = [NSString stringWithFormat:@"http://app.vmoiver.com/%@?qingapp=app_new&debug=1",self.movie.postid];
    NSURL *vURL = [NSURL URLWithString:urlString];
    NSURLRequest *requset = [NSURLRequest requestWithURL:vURL];
    [webView loadRequest:requset];
    webView.delegate = self;
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.playerView.mas_bottom);
    }];
}

- (void) getMovieURL {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"postid"] = self.movie.postid;
    [manager GET:@"http://app.vmoiver.com/apiv3/post/view" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString  *urlString = [responseObject[@"data"][@"content"][@"video"] firstObject][@"qiniu_url"];
        self.playerView.videoURL = [NSURL URLWithString:urlString];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.navigationController.navigationBarHidden = YES;

    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.navigationController.navigationBarHidden = NO;

}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [SVProgressHUD show];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
}

@end
