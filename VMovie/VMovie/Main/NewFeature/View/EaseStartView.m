//
//  EaseStartView.m
//  VMovie
//
//  Created by wyz on 16/3/13.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "EaseStartView.h"

@interface EaseStartView()

/** 背景图片 */
@property (nonatomic, weak) UIImageView *bgImageView;

@end

@implementation EaseStartView

+ (instancetype)startView {
    
    return [[self alloc] initWithBgImage:[UIImage imageNamed:@"img_start_6"]];
}

- (instancetype) initWithBgImage:(UIImage *) bgImage {
    
    self = [super initWithFrame:Main_Screen_Bounds];
    if (self) {
        
        //1.背景颜色
        self.backgroundColor = [UIColor blackColor];
        
        //2.背景图片
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:Main_Screen_Bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.alpha = 0.0;
        imageView.image = bgImage;
        [self addSubview:imageView];
        self.bgImageView = imageView;
    }
    
    return self;
}

- (void) startAnimation {
    
    [Application_KeyWindow addSubview:self];
    [Application_KeyWindow bringSubviewToFront:self];
    self.bgImageView.alpha = 1.0;
    
    //动画
    @weakify(self);
    [UIView animateWithDuration:2.0 animations:^{
        @strongify(self);
        self.bgImageView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.6 delay:0.3 options:UIViewAnimationOptionCurveEaseIn animations:^{
            @strongify(self);
            self.x = - App_Frame_Width;
        } completion:^(BOOL finished) {
            @strongify(self);
            [self removeFromSuperview];
        }];
    }];
    
}

@end
