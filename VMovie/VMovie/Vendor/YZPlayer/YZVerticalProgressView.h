//
//  YZVerticalProgressView.h
//  YZVerticalProgressView
//
//  Created by wyz on 16/3/31.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZVerticalProgressView : UIView

@property(nonatomic,assign) CGFloat progress;

- (void)setTopImage:(UIImage *)topImage bottomImage:(UIImage *)bottomImage;

@end
