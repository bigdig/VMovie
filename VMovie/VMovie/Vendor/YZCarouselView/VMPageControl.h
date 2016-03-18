//
//  VMPageControl.h
//  循环轮播图
//
//  Created by wyz on 16/3/17.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VMPageControl : UIView

/** 总页数*/
@property(nonatomic, assign) NSInteger numberOfPages;
/** 间隔*/
@property(nonatomic, assign) CGFloat pageSpace;
/** 当前页背景色*/
@property(nonatomic, strong) UIColor *currentPageIndicatorTintColor;
/** 非当前页背景色*/
@property(nonatomic, strong) UIColor *pageIndicatorTintColor;
/** 当前页*/
@property(nonatomic, assign) NSInteger currentPage;
/**当前页图片 */
@property (nonatomic, strong) UIImage *currentPageIndicatorImage;
/**非当前页图片 */
@property (nonatomic, strong) UIImage *pageIndicatorImage;

@end
