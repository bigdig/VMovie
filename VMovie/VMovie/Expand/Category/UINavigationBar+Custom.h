//
//  UINavigationBar+Custom.h
//  MoviePlayer
//
//  Created by wyz on 16/3/30.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (Custom)

- (void)yz_setBackgroundImage:(UIImage *) image alpha:(CGFloat)alpha;

- (void)yz_setTranslationY:(CGFloat)translationY;

- (void)yz_setElementsAlpha:(CGFloat)alpha;

- (void)yz_reset;

@end
