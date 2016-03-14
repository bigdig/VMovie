//
//  NavigationController.m
//  VMovie
//
//  Created by wyz on 16/3/13.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "VMNavigationController.h"
#import "VMNavigationBar.h"

@interface VMNavigationController ()

@end

@implementation VMNavigationController

+ (void)initialize {
    
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20.0f],NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.interactivePopGestureRecognizer.delegate = nil;
    
    [self setValue:[[VMNavigationBar alloc] init] forKeyPath:@"navigationBar"];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
