//
//  UINavigationBar+Custom.m
//  MoviePlayer
//
//  Created by wyz on 16/3/30.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "UINavigationBar+Custom.h"
#import <objc/runtime.h>

@implementation UINavigationBar (Custom)

static char bgImageViewKey;

- (UIImageView *)bgImageView
{
    return objc_getAssociatedObject(self, &bgImageViewKey);
}

- (void)setBgImageView:(UIImageView *)bgImageView
{
    objc_setAssociatedObject(self, &bgImageViewKey, bgImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)yz_setBackgroundImage:(UIImage *) image alpha:(CGFloat)alpha
{
    if (!self.bgImageView) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, CGRectGetHeight(self.bounds) + 20)];
        self.bgImageView.userInteractionEnabled = NO;
        self.bgImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.bgImageView.backgroundColor = [UIColor clearColor];
        self.bgImageView.contentMode = UIViewContentModeScaleToFill;
        self.bgImageView.image = image;
        [self insertSubview:self.bgImageView atIndex:0];
    }
    self.bgImageView.alpha = alpha;
}

- (void)yz_setTranslationY:(CGFloat)translationY
{
    self.transform = CGAffineTransformMakeTranslation(0, translationY);
}

- (void)yz_setElementsAlpha:(CGFloat)alpha
{
    //    [[self valueForKey:@"_leftViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
    //        view.alpha = alpha;
    //    }];
    //
    //    [[self valueForKey:@"_rightViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
    //        view.alpha = alpha;
    //    }];
    
    UIView *titleView = [self valueForKey:@"_titleView"];
    titleView.alpha = alpha;
}

- (void)yz_reset
{
    [self setBackgroundImage:[UIImage imageNamed:@"img_place_bg"] forBarMetrics:UIBarMetricsDefault];
//    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.bgImageView removeFromSuperview];
    self.bgImageView = nil;
}

@end

