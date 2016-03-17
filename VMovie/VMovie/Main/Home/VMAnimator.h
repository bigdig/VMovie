//
//  Animator.h
//  VMovie
//
//  Created by wyz on 16/3/16.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VMAnimator : NSObject<UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>

+ (instancetype) sharedAnimator; 

@end
