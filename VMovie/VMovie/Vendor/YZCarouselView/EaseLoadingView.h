//
//  EaseLoadingView.h
//  VMovie
//
//  Created by wyz on 16/3/25.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EaseLoadingView : UIView
@property (assign, nonatomic, readonly) BOOL isLoading;
- (void)startAnimating;
- (void)stopAnimating;
@end
