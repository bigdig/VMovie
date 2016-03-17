//
//  Animator.m
//  VMovie
//
//  Created by wyz on 16/3/16.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "VMAnimator.h"
#import "VMPresentationController.h"

@interface VMAnimator()

/**是否 */
@property (nonatomic, assign) BOOL isPresented;

@end

@implementation VMAnimator

static CGFloat  const duration = 1.0;

+ (instancetype) sharedAnimator {
    
    static id sharedAnimator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAnimator = [[self alloc] init];
    });
    
    return sharedAnimator;
}

-(UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    
    return [[VMPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.isPresented = YES;
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.isPresented = NO;
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return duration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    if (self.isPresented) {
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        toView.x = toView.width;
        [UIView animateWithDuration:duration animations:^{
            toView.x = 0;
        } completion:^(BOOL finished) {
            
            [transitionContext completeTransition:YES];
        }];
    }
    
    else {
        UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        [UIView animateWithDuration:duration animations:^{
            
            fromView.x = - fromView.width;
        } completion:^(BOOL finished) {
            
            [transitionContext completeTransition:YES];
        }];
        
    }
}

@end
