//
//  HomeViewController.m
//  VMovie
//
//  Created by wyz on 16/3/12.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "HomeViewController.h"
#import "UIBarButtonItem+Custom.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"最新";
    
    
    UIBarButtonItem *detailItem = [UIBarButtonItem itemWithImage:@"img_icon_menu" HighImage:@"img_icon_menu" target:self action:@selector(detailItemClick)];
    self.navigationItem.leftBarButtonItem = detailItem;
    
    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithImage:@"img_icon_search" HighImage:@"img_icon_search" target:self action:@selector(searchItemClick)];
    self.navigationItem.rightBarButtonItem = searchItem;
}

- (void) detailItemClick {
    NSLog(@"%s",__func__);
}

- (void) searchItemClick {
    NSLog(@"%s",__func__);
}





@end
