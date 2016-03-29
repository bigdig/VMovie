//
//  YZTopWindow.m
//  百思
//
//  Created by wyz on 16/2/24.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "YZTopWindow.h"

@implementation YZTopWindow

static UIWindow *window_;

+ (void)initialize {
    
    window_ = [[UIWindow alloc] init];
    window_.frame = CGRectMake(0.3 * App_Frame_Width, 0, 0.7 * App_Frame_Width, StatusBarHeight);
    window_.windowLevel = UIWindowLevelStatusBar;
    [window_  addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(windowClick:)]];
    window_.hidden = YES;
    window_.backgroundColor = [UIColor clearColor];
}

+ (void) show {
    
    window_.hidden = NO;
}

+ (void) windowClick:(UIGestureRecognizer *) tap {
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    [self searchScrollViewInView:keyWindow];
}

+ (void) searchScrollViewInView:(UIView *) superView {
    
    for (UIScrollView *subView in superView.subviews) {
    //判断scrollview 是否可见
    //1.CGRect newFrame = [subView.superview convertRect:subView.frame toView:nil];
    //2.CGRect newFrame = [[UIApplication sharedApplication].keyWindow convertRect:subView.frame fromView:subView.superview];
    //3.
    CGRect newFrame = [subView convertRect:subView.bounds toView:nil];
    
    BOOL isShowing = !subView.hidden && subView.alpha > 0.01 && CGRectIntersectsRect(newFrame, [UIApplication sharedApplication].keyWindow.bounds);
    
    if ([subView isKindOfClass:[UIScrollView class]] && isShowing) {
        CGPoint offset = subView.contentOffset;
        offset.y = - subView.contentInset.top;
        [subView setContentOffset:offset animated:YES];
    }
    
    [self searchScrollViewInView:subView];
    }
}


@end
