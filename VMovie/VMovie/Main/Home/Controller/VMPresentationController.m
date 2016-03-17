//
//  PresentationController.m
//  VMovie
//
//  Created by wyz on 16/3/16.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "VMPresentationController.h"

@implementation VMPresentationController

- (void)presentationTransitionWillBegin{
    //    NSLog(@"presentationTransitionWillBegin");
    self.presentedView.frame = self.containerView.bounds;
    self.presentedView.backgroundColor = [UIColor cyanColor];
    [self.containerView addSubview:self.presentedView];
}

- (void)presentationTransitionDidEnd:(BOOL)completed{
    //    NSLog(@"presentationTransitionDidEnd");
}

- (void)dismissalTransitionWillBegin{
    //    NSLog(@"dismissalTransitionWillBegin");
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {
    //    NSLog(@"dismissalTransitionDidEnd");
    [self.presentedView removeFromSuperview];
}

@end
