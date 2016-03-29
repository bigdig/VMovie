//
//  UIView+Extension.m
//  VMovie
//
//  Created by wyz on 16/3/25.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "UIView+Extension.h"
#import <objc/runtime.h>
#import "EaseBlankView.h"
#import "EaseLoadingView.h"

@implementation UIView (Extension)

static char BlankViewKey,LoadingViewKey;

- (void)setBlankView:(EaseBlankView *)blankView {
    
    [self willChangeValueForKey:@"BlankPageViewKey"];
    objc_setAssociatedObject(self, &BlankViewKey,
                             blankView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"BlankPageViewKey"];
}

- (EaseBlankView *)blankView {
    return objc_getAssociatedObject(self, &BlankViewKey);
}

- (void)configWithData:(BOOL)hasData reloadDataBlock:(void (^)(id))block {
    
    if (hasData) {
        if (self.blankView) {
            self.blankView.hidden = YES;
            [self.blankView removeFromSuperview];
        }
    } else {
        if (!self.blankView) {
            self.blankView = [[EaseBlankView alloc] initWithFrame:self.bounds];
        }
        self.blankView.hidden = NO;
        [[self blankContainer] addSubview:self.blankView];
        
        [self.blankView configWithData:hasData reloadDataBlock:block];
    }
}

- (UIView *)blankContainer{
    UIView *blankContainer = self;
    for (UIView *aView in [self subviews]) {
        if ([aView isKindOfClass:[UITableView class]]) {
            blankContainer = aView;
        }
    }
    return blankContainer;
}

- (void)setLoadingView:(EaseLoadingView *)loadingView{
    [self willChangeValueForKey:@"LoadingViewKey"];
    objc_setAssociatedObject(self, &LoadingViewKey,
                             loadingView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"LoadingViewKey"];
}
- (EaseLoadingView *)loadingView{
    return objc_getAssociatedObject(self, &LoadingViewKey);
}

- (void)beginLoading{
    for (UIView *aView in [self.blankContainer subviews]) {
        if ([aView isKindOfClass:[EaseBlankView class]] && !aView.hidden) {
            return;
        }
    }
    
    if (!self.loadingView) { //初始化LoadingView
        self.loadingView = [[EaseLoadingView alloc] initWithFrame:self.bounds];
    }
    [self addSubview:self.loadingView];
//    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
//    }];
    [self.loadingView startAnimating];
}

- (void)endLoading{
    if (self.loadingView) {
        [self.loadingView stopAnimating];
    }
}
@end
