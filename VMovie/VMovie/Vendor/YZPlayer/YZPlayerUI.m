//
//  YZPlayerUI.m
//  MoviePlayer
//
//  Created by wyz on 16/3/31.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "YZPlayerUI.h"
#import <Masonry/Masonry.h>
#import "YZVerticalProgressView.h"
#import "YZVideoSlider.h"

@interface YZPlayerUI()
/**是否正在动画 */
@property (nonatomic, assign) BOOL isAnimating;
@end

@implementation YZPlayerUI


- (instancetype)initWithFrame:(CGRect)frame {
  
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        [self addSubview:self.shadowView];
        [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self setupTopUI];
        [self setupBottomUI];
        [self setupBrightnessUI];
        [self setupVolumeUI];
        [self setupCenterUI];
    }
    return self;
}

#pragma mark - setupUI

- (void) setupTopUI {
    
    [self addSubview:self.topView];
    [self.topView addSubview:self.backButton];
    [self.topView addSubview:self.titleLabel];
    [self.topView addSubview:self.shareButton];
    [self.topView addSubview:self.cacheButton];
    [self.topView addSubview:self.likeButton];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(self.mas_height).multipliedBy(1.0/10.0);
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView);
        make.left.equalTo(self.topView).offset(15);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backButton.mas_right).offset(10);
        make.centerY.equalTo(self.topView);
//        make.width.equalTo(@(self.topView.width * 0.5));
    }];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView);
        make.right.equalTo(self.topView).offset(-15);
    }];
    
    [self.cacheButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView);
        make.right.equalTo(self.shareButton.mas_left).offset(-30);
    }];
    
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView);
        make.right.equalTo(self.cacheButton.mas_left).offset(-30);
    }];
}

- (void)setupBottomUI {
    
    [self addSubview:self.bottomView];
    [self.bottomView addSubview:self.currentDurationLabel];
    [self.bottomView addSubview:self.progressView];
    [self.bottomView addSubview:self.fullScreenButton];
    [self.bottomView addSubview:self.totalDurationLabel];
    [self.bottomView addSubview:self.videoSlider];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.equalTo(self).multipliedBy(1.5/10.0);
    }];
    
    [self.currentDurationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(15);
        make.centerY.equalTo(self.bottomView);
        make.width.equalTo(@30);
    }];
    
    [self.fullScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomView);
        make.right.equalTo(self.bottomView).offset(-15);
    }];
    
    [self.totalDurationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomView);
        make.right.equalTo(self.fullScreenButton.mas_left).offset(-10);
        make.width.equalTo(@30);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomView);
        make.left.equalTo(self.currentDurationLabel.mas_right).offset(10);
        make.right.equalTo(self.totalDurationLabel.mas_left).offset(-10);
        make.height.equalTo(@4);
    }];
    
    [self.videoSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.progressView);
    }];
}

- (void)setupBrightnessUI {
    
    [self addSubview:self.brightnessProgressView];
    [self.brightnessProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.width.equalTo(@30);
        make.centerX.equalTo(self.mas_left).offset(30);
        make.height.equalTo(self).multipliedBy(2.0/5.0);
    }];
    self.brightnessProgressView.hidden = YES;
}

- (void)setupVolumeUI {
    
    [self addSubview:self.volumeProgressView];
    [self.volumeProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.width.equalTo(@30);
        make.centerX.equalTo(self.mas_right).offset(-30);
        make.height.equalTo(self).multipliedBy(2.0/5.0);
    }];
    self.volumeProgressView.hidden = YES;
}

- (void)setupCenterUI {
    
    [self addSubview:self.centerView];
    [self addSubview:self.playButton];
    [self addSubview:self.repeatButton];
    [self addSubview:self.horizontalLabel];
    [self addSubview:self.activity];
    
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.topView.mas_bottom);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.equalTo(@30);
    }];
    
    [self.repeatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.playButton);
    }];
    
    [self.horizontalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-50);
        make.width.equalTo(@120);
        make.height.equalTo(@30);
    }];
    
    [self.activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

#pragma mark - 方法

- (void)resetPlayerUI {
    self.videoSlider.value = 0.0;
    self.progressView.progress = 0.0;
    self.currentDurationLabel.text = @"00:00";
    self.totalDurationLabel.text = @"00:00";
    self.repeatButton.hidden = YES;
    self.shadowView.alpha = 0.0;
    self.backgroundColor = [UIColor clearColor];
}

- (void) showPlayerUI {
    self.shadowView.alpha = 1.0;
    self.playButton.alpha = 1.0;
    if (self.isAnimating) return;
    [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
    }];
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
    }];
    self.isAnimating = YES;
    [UIView animateWithDuration:0.5 animations:^{
        [self layoutIfNeeded];
        self.topView.alpha = 1.0;
        self.bottomView.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.isAnimating = NO;
    }];
}

- (void) hidePlayerUI {
    self.shadowView.alpha = 0.0;
     self.playButton.alpha = 0.0;
    if (self.isAnimating) return;
    [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(-self.topView.height);
    }];
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(self.bottomView.height);
    }];
    self.isAnimating = YES;
    [UIView animateWithDuration:0.5 animations:^{
        [self layoutIfNeeded];
        self.topView.alpha = 0.0;
        self.bottomView.alpha = 0.0;
    }completion:^(BOOL finished) {
        self.isAnimating = NO;
    }];
}

#pragma mark - 懒加载控件
- (UIView *)topView {
    if (!_topView) {
        _topView = [UIView new];
        _topView.backgroundColor = [UIColor clearColor];
    }
    return _topView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton new];
        [_backButton setBackgroundImage:[UIImage imageNamed:@"img_player_back"] forState:UIControlStateNormal];
    }
    return _backButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
//        [_titleLabel setText:@"给电影的一封情书"];
//        _titleLabel.backgroundColor = RANDOM_UICOLOR;
        [_titleLabel setTextColor:[UIColor whiteColor]];
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _titleLabel;
}

- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [UIButton new];
        [_shareButton setBackgroundImage:[UIImage imageNamed:@"img_player_share"] forState:UIControlStateNormal];
    }
    return _shareButton;
}

- (UIButton *)cacheButton {
    if (!_cacheButton) {
        _cacheButton = [UIButton new];
        [_cacheButton setBackgroundImage:[UIImage imageNamed:@"img_player_cache"] forState:UIControlStateNormal];
    }
    return _cacheButton;
}

- (UIButton *)likeButton {
    if (!_likeButton) {
        _likeButton = [UIButton new];
        [_likeButton setBackgroundImage:[UIImage imageNamed:@"img_player_like"] forState:UIControlStateNormal];
    }
    return _likeButton;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = [UIColor clearColor];
    }
    return _bottomView;
}

- (UILabel *)currentDurationLabel {
    if (!_currentDurationLabel) {
        _currentDurationLabel = [UILabel new];
        _currentDurationLabel.text = @"00:00";
        _currentDurationLabel.textColor = [UIColor whiteColor];
        _currentDurationLabel.font = [UIFont systemFontOfSize:10.0f];
    }
    return _currentDurationLabel;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [UIProgressView new];
        _progressView.progressTintColor = [UIColor colorWithWhite:0.5 alpha:0.8];
        _progressView.trackTintColor = [UIColor colorWithWhite:0.8 alpha:0.4];
    }
    return _progressView;
}

- (UIButton *)fullScreenButton {
    if (!_fullScreenButton) {
        _fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenButton setBackgroundImage:[UIImage imageNamed:@"img_player_zoom_max"] forState:UIControlStateNormal];
        [_fullScreenButton setBackgroundImage:[UIImage imageNamed:@"img_player_zoom_mix"] forState:UIControlStateSelected];
    }
    return _fullScreenButton;
}

- (UILabel *)totalDurationLabel {
    if (!_totalDurationLabel) {
        _totalDurationLabel = [UILabel new];
        _totalDurationLabel.text = @"00:00";
        _totalDurationLabel.textColor = [UIColor whiteColor];
        _totalDurationLabel.font = [UIFont systemFontOfSize:10.0f];
    }
    return _totalDurationLabel;
}

- (YZVideoSlider *)videoSlider {
    if (!_videoSlider) {
        _videoSlider = [YZVideoSlider new];
        _videoSlider.maximumTrackTintColor = [UIColor clearColor];
        _videoSlider.minimumTrackTintColor = [UIColor whiteColor];
        [_videoSlider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    }
    return _videoSlider;
}

- (YZVerticalProgressView *)brightnessProgressView {
    if (!_brightnessProgressView) {
        _brightnessProgressView = [YZVerticalProgressView new];
        [_brightnessProgressView setTopImage:[UIImage imageNamed:@"img_player_light_max"] bottomImage:[UIImage imageNamed:@"img_player_light_mix"]];
    }
    return _brightnessProgressView;
}

- (YZVerticalProgressView *)volumeProgressView {
    if (!_volumeProgressView) {
        _volumeProgressView = [YZVerticalProgressView new];
        [_volumeProgressView setTopImage:[UIImage imageNamed:@"img_player_volume_max"] bottomImage:[UIImage imageNamed:@"img_player_volume_mix"]];
    }
    return _volumeProgressView;
}

- (UIView *)centerView {
    if (!_centerView) {
        _centerView = [UIView new];
        _centerView.backgroundColor = [UIColor clearColor];
    }
    return _centerView;
}

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"img_player_small_play"] forState:UIControlStateNormal];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"img_player_small_pause"] forState:UIControlStateSelected];
    }
    return _playButton;
}

- (UIButton *)repeatButton {
    if (!_repeatButton) {
        _repeatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_repeatButton setBackgroundImage:[UIImage imageNamed:@"img_player_small_play"] forState:UIControlStateNormal];
        _repeatButton.hidden = YES;
    }
    return _repeatButton;
}

- (UILabel *)horizontalLabel {
    if (!_horizontalLabel) {
        _horizontalLabel = [UILabel new];
        _horizontalLabel.textColor = [UIColor whiteColor];
        _horizontalLabel.font = [UIFont systemFontOfSize:12.0f];
        _horizontalLabel.textAlignment = NSTextAlignmentCenter;
        _horizontalLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
        _horizontalLabel.hidden = YES;
    }
    return _horizontalLabel;
}

- (UIActivityIndicatorView *)activity
{
    if (!_activity) {
        _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    }
    return _activity;
}

- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [UIView new];
        _shadowView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    }
    return _shadowView;
}
@end
