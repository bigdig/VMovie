//
//  EaseLoadingView.m
//  VMovie
//
//  Created by wyz on 16/3/25.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "EaseLoadingView.h"

@interface EaseLoadingView()
/**图片 */
@property (nonatomic, strong) UIImageView *loopView;
/**标签 */
@property (nonatomic, strong) UILabel *loadingLabel;

@property (nonatomic, assign) CGFloat loopAngle, monkeyAlpha, angleStep, alphaStep;
@end
@implementation EaseLoadingView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        if (!_loopView) {
            _loopView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading"]];
            [self addSubview:_loopView];
        }
        
        if (!_loadingLabel) {
            _loadingLabel = [[UILabel alloc] init];
            _loadingLabel.backgroundColor = [UIColor clearColor];
            _loadingLabel.numberOfLines = 0;
            _loadingLabel.font = [UIFont systemFontOfSize:12.0f];
            _loadingLabel.textColor = [UIColor blackColor];
            _loadingLabel.textAlignment = NSTextAlignmentCenter;
            _loadingLabel.text = @"LOADING...";
            [self addSubview:_loadingLabel];
        }
        
        //    布局
        [_loadingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        [_loopView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(_loadingLabel.mas_top).offset(-5);
            make.size.mas_equalTo(_loopView.image.size);
        }];
        
        _loopAngle = 0.0;
        _monkeyAlpha = 1.0;
        _angleStep = 360/3;
        _alphaStep = 1.0/3.0;
    }
    return self;
}

- (void)startAnimating{
    self.hidden = NO;
    if (_isLoading) {
        return;
    }
    _isLoading = YES;
    [self loadingAnimation];
}

- (void)stopAnimating{
    self.hidden = YES;
    _isLoading = NO;
}

- (void) loadingAnimation {
    static CGFloat duration = 0.25f;
    _loopAngle += _angleStep;
    if (_monkeyAlpha >= 1.0 || _monkeyAlpha <= 0.0) {
        _alphaStep = -_alphaStep;
    }
    _monkeyAlpha += _alphaStep;
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        CGAffineTransform loopAngleTransform = CGAffineTransformMakeRotation(_loopAngle * (M_PI / 180.0f));
        _loopView.transform = loopAngleTransform;
        _loadingLabel.alpha = _monkeyAlpha;
    } completion:^(BOOL finished) {
        if (_isLoading && [self superview] != nil) {
            [self loadingAnimation];
        }else{
            [self removeFromSuperview];
            
            _loopAngle = 0.0;
            _monkeyAlpha = 1.0;
            _alphaStep = ABS(_alphaStep);
            CGAffineTransform loopAngleTransform = CGAffineTransformMakeRotation(_loopAngle * (M_PI / 180.0f));
            _loopView.transform = loopAngleTransform;
            _loadingLabel.alpha = _monkeyAlpha;
        }
    }];
}

@end
