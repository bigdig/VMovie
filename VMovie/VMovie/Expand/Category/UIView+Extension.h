//
//  UIView+Extension.h
//  VMovie
//
//  Created by wyz on 16/3/25.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EaseBlankView,EaseLoadingView;
@interface UIView (Extension)
/**EaseBlankView */
@property (nonatomic, strong) EaseBlankView *blankView;

- (void) configWithText:(NSString *)text hasData:(BOOL)hasData hasError:(BOOL)hasError reloadDataBlock:(void(^)(id)) block;

@property (strong, nonatomic) EaseLoadingView *loadingView;
- (void)beginLoading;
- (void)endLoading;
@end
