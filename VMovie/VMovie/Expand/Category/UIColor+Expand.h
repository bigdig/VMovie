//
//  UIColor+Expand.h
//  VMovie
//
//  Created by wyz on 16/3/29.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Expand)

+ (UIColor *)randomColor;

+ (UIColor *)colorWithRGBHex:(UInt32)hex;

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

@end
