//
//  RatingView.m
//  VMovie
//
//  Created by wyz on 16/3/14.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "RatingView.h"

@implementation RatingView

- (instancetype) initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        for (NSInteger i = 0; i < 5; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundImage:[UIImage imageNamed:@"foregroundStar"] forState:UIControlStateNormal];
            [self addSubview:button];
        }
    }
    return self;
}


- (void)setRating:(NSString *)rating {
    
    _rating = [rating copy];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat buttonWidth = 20;
    CGFloat buttonHeight = buttonWidth;
    for (NSInteger i = 0; i < self.subviews.count; i++) {
        UIView *subView = self.subviews[i];
        if (![subView isKindOfClass:[UIButton class]]) continue;
        
        UIButton *button  = (UIButton *) subView;
        button.x = i * buttonWidth;
        button.y = 0;
        button.width = buttonWidth;
        button.height = buttonHeight;
    }
}
@end
