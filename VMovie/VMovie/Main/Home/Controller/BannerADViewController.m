//
//  BannerADViewController.m
//  VMovie
//
//  Created by wyz on 16/3/18.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "BannerADViewController.h"
#import "Banner.h"
#import "UIBarButtonItem+Custom.h"

@interface BannerADViewController ()<UIWebViewDelegate>

@end

@implementation BannerADViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"login_back_button" HighImage:@"login_back_button" target:self action:@selector(back)];
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:webView];
    webView.delegate = self;
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    NSURL *url = [NSURL URLWithString:self.banner.bannerURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];

}

- (void) back {
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
     [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [SVProgressHUD show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

@end
