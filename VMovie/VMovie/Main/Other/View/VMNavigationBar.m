//
//  VMNavigationBar.m
//  VMovie
//
//  Created by wyz on 16/3/14.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "VMNavigationBar.h"

@implementation VMNavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        //设置导航栏背景图片
        [self setBackgroundImage:[UIImage imageNamed:@"img_place_bg"] forBarMetrics:UIBarMetricsDefault];
    }
    return self;
}

-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    //调整titleView位置
    for (UINavigationItem *item in self.items) {
        
        if (item.titleView != nil) {
            item.titleView.y = self.height - item.titleView.height;
        }
    }
    
    //调整左右按钮边距
//        for (UIButton *button in self.subviews) {
//            if (![button isKindOfClass:[UIButton class]]) continue;
//    
//            if (button.centerX < self.width * 0.5) { // 左边的按钮
//                button.x = 10;
//            } else if (button.centerX > self.width * 0.5) { // 右边的按钮
//                button.x = self.width - button.width - 10;
//            }
//        }
}

@end
