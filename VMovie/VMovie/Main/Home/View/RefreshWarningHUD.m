//
//  RefreshWarningHUD.m
//  VMovie
//
//  Created by wyz on 16/3/29.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "RefreshWarningHUD.h"

@implementation RefreshWarningHUD

static bool isShowing = NO;

+ (void)showWithText:(NSString *)text {
    
    if (isShowing) {
        return;
    }
    
    UILabel *refreshLabel = [[UILabel alloc] init];
    
    refreshLabel.width = App_Frame_Width;
    refreshLabel.height = ScaleFrom_iPhone5_Desgin(30);
    refreshLabel.x = 0;
    refreshLabel.y = StatusBarHeight + TopBarHeight - refreshLabel.height;
    refreshLabel.font = [UIFont systemFontOfSize:ScaleFrom_iPhone5_Desgin(14.0f)];
    refreshLabel.backgroundColor = [UIColor blackColor];
    refreshLabel.textColor = [UIColor whiteColor];
    refreshLabel.textAlignment = NSTextAlignmentCenter;
    
    refreshLabel.text = text;
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UINavigationController *nav = (UINavigationController *)keyWindow.rootViewController;
    if (nav) {
        [nav.view insertSubview:refreshLabel belowSubview:nav.navigationBar];
    }
    
    
    [UIView animateWithDuration:0.5 animations:^{
        isShowing = YES;
        refreshLabel.hidden = NO;
        refreshLabel.transform = CGAffineTransformMakeTranslation(0, refreshLabel.height);
    } completion:^(BOOL finished) {
        [UIView animateKeyframesWithDuration:1.0 delay:1.0 options:UIViewKeyframeAnimationOptionCalculationModePaced animations:^{
            refreshLabel.transform = CGAffineTransformIdentity;
        } completion:
         ^(BOOL finished) {
             isShowing = NO;
             refreshLabel.hidden = YES;
             [refreshLabel removeFromSuperview];
         }];
    }];
    
}


@end
