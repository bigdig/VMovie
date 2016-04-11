//
//  YZPlayerUI.h
//  MoviePlayer
//
//  Created by wyz on 16/3/31.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YZVerticalProgressView,YZVideoSlider;
@interface YZPlayerUI : UIView

/**阴影视图 */
@property (nonatomic, strong) UIView *shadowView;
/**顶部视图 */
@property (nonatomic, strong) UIView *topView;
/**返回按钮 */
@property (nonatomic, strong) UIButton *backButton;
/**标题标签 */
@property (nonatomic, strong) UILabel *titleLabel;
/**喜欢按钮 */
@property (nonatomic, strong) UIButton *likeButton;
/**下载按钮 */
@property (nonatomic, strong) UIButton *cacheButton;
/**分享按钮 */
@property (nonatomic, strong) UIButton *shareButton;

/**底部视图 */
@property (nonatomic, strong) UIView *bottomView;
/**当前时长标签 */
@property (nonatomic, strong) UILabel *currentDurationLabel;
/**进度条 */
@property (nonatomic, strong) UIProgressView *progressView;
/**滑动条 */
@property (nonatomic, strong) YZVideoSlider *videoSlider;
/**全屏按钮 */
@property (nonatomic, strong) UIButton *fullScreenButton;
/**总时长按钮 */
@property (nonatomic, strong) UILabel *totalDurationLabel;

/**亮度调节 */
@property (nonatomic, strong) YZVerticalProgressView *brightnessProgressView;
/**音量调节 */
@property (nonatomic, strong) YZVerticalProgressView *volumeProgressView;

/**中部视图 */
@property (nonatomic, strong) UIView *centerView;
/**播放暂停按钮 */
@property (nonatomic, strong) UIButton *playButton;
/**重播按钮 */
@property (nonatomic, strong) UIButton *repeatButton;
/**进度提示标签*/
@property (nonatomic, strong) UILabel *horizontalLabel;

/**菊花 */
@property (nonatomic, strong) UIActivityIndicatorView *activity;

- (void) resetPlayerUI;
- (void) hidePlayerUI;
- (void) showPlayerUI;

@end
