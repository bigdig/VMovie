//
//  ArticleWebViewController.m
//  VMovie
//
//  Created by wyz on 16/3/18.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "ArticleWebViewController.h"
#import "UIBarButtonItem+Custom.h"
#import "Movie.h"

@interface ArticleWebViewController ()<UIWebViewDelegate>

@end

@implementation ArticleWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"幕后文章";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"login_back_button" HighImage:@"login_back_button" target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"home_share_icon"HighImage:@"home_share_icon" target:self action:@selector(share)];
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:webView];
    webView.delegate = self;
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://app.vmoiver.com/%@?qingapp=app_new&debug=1",self.movie.postid]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
}

- (void) share {
    NSLog(@"%s",__func__);
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
//    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}


@end
