//
//  UIBarButtonItem+Custom.h
//  百思
//
//  Created by wyz on 16/2/8.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Custom)

+ (instancetype) itemWithImage:(NSString *) image HighImage:(NSString *) highImage target:(id) target action:(SEL) action;

@end
