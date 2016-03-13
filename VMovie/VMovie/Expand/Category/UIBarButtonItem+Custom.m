//
//  UIBarButtonItem+Custom.m
//  百思
//
//  Created by wyz on 16/2/8.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "UIBarButtonItem+Custom.h"

@implementation UIBarButtonItem (Custom)

+ (instancetype) itemWithImage:(NSString *) image HighImage:(NSString *) highImage target:(id) target action:(SEL) action  {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    button.size = button.currentImage.size;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[self alloc] initWithCustomView:button];
}

@end
