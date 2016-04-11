//
//  YZMoviePlayerView.m
//  MoviePlayer
//
//  Created by wyz on 16/3/30.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "YZMoviePlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import "YZPlayerUI.h"
#import <MediaPlayer/MediaPlayer.h>
#import <Masonry/Masonry.h>
#import "YZVerticalProgressView.h"
#import "YZVideoSlider.h"

// 手势方向:水平移动方向和垂直移动方向
typedef NS_ENUM(NSInteger, PanDirection){
    PanDirectionHorizontalMoved, //横向移动
    PanDirectionVerticalMoved    //纵向移动
};

//播放器状态
typedef NS_ENUM(NSInteger,YZMoviePlayerState) {
    YZPlayerStateBuffering,  //缓冲中
    YZPlayerStatePlaying,    //播放中
    YZPlayerStateStopped,    //停止播放
    YZPlayerStatePause       //暂停播放
};

@interface YZMoviePlayerView()<UIGestureRecognizerDelegate>

/**playerUI */
@property (nonatomic, strong) YZPlayerUI *playerUI;

@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic,strong) AVPlayer *player;

/**播放状态 */
@property (nonatomic, assign) YZMoviePlayerState state;
/** 定义一个实例变量，保存枚举值 */
@property (nonatomic, assign) PanDirection  panDirection;
/** 是否被用户暂停 */
@property (nonatomic, assign) BOOL isPauseByUser;
/** 是否为全屏 */
@property (nonatomic, assign) BOOL isFullScreen;
/** 计时器 */
@property (nonatomic, strong) NSTimer *timer;
/** 用来保存快进的总时长 */
@property (nonatomic, assign) CGFloat sumTime;
/** 是否在调节音量*/
@property (nonatomic, assign) BOOL isVolume;
/** slider上次的值 */
@property (nonatomic, assign) CGFloat sliderLastValue;
/** 是否显示UI*/
@property (nonatomic, assign) BOOL isUIShowing;
/** 滑杆 */
@property (nonatomic, strong) UISlider *volumeViewSlider;
/** 是否点了重播 */
@property (nonatomic, assign) BOOL  repeatToPlay;
/** 播放完了*/
@property (nonatomic, assign) BOOL  playDidEnd;
@end

@implementation YZMoviePlayerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        self.state = YZPlayerStateStopped;
        
        [self addNotificationAndAction];
        
        // 监测设备方向
        [self observingRotating];
        [self deviceOrientationDidChange];
        
        // 计时器
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(playerTimerAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        
        // 添加手势
        [self createTapGesture];
        
        //获取系统音量
        [self configureVolume];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
      self.playerUI.titleLabel.text = title;
}

- (void)setVideoUrl:(NSString *)videoUrl {
    
    _videoUrl = [videoUrl copy];
    
    if (!videoUrl || videoUrl.length <= 0) {
        return;
    }
    
  
    
    self.repeatToPlay = NO;
    self.playDidEnd   = NO;
    self.state = YZPlayerStateStopped;
    
    self.playerItem  = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:videoUrl]];
    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    [self.layer insertSublayer:self.playerLayer atIndex:0];

    // 初始化显示PlayerUI为YES
    self.isUIShowing = YES;
    // 延迟隐藏PlayerUI
    [self autoHidePlayerUI];
}

//获取系统音量
- (void)configureVolume
{
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    volumeView.frame = CGRectMake(-1000, -100, 100, 100);
    volumeView.hidden = NO;
    [self addSubview:volumeView];
    _volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            _volumeViewSlider = (UISlider *)view;
            break;
        }
    }
    
    // 使用这个category的应用不会随着手机静音键打开而静音，可在手机静音下播放声音
    NSError *setCategoryError = nil;
    BOOL success = [[AVAudioSession sharedInstance]
                    setCategory: AVAudioSessionCategoryPlayback
                    error: &setCategoryError];
    
    if (!success) { /* handle the error in setCategoryError */ }
}

#pragma mark -动画
//显示UI
- (void)showPlayerUI
{
    if (self.isUIShowing) {
        return;
    }
    [self.playerUI showPlayerUI];
    self.isUIShowing = YES;
    [self autoHidePlayerUI];
}

//延时隐藏UI
- (void)autoHidePlayerUI
{
    if (!self.isUIShowing) {
        return;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hidePlayerUI) object:nil];
    [self performSelector:@selector(hidePlayerUI) withObject:nil afterDelay:7.0f];
}

//隐藏UI
- (void)hidePlayerUI
{
    if (!self.isUIShowing) return;
    [self.playerUI hidePlayerUI];
    self.isUIShowing = NO;
}

- (void)cancelAutoHidePlayerUI {
     [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark - 添加通知和响应事件

- (void)addNotificationAndAction {
    // AVPlayer播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    // app退到后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    // app进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayGround) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    //播放按钮点击事件
    [self.playerUI.playButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    // 全屏按钮点击事件
    [self.playerUI.fullScreenButton addTarget:self action:@selector(fullScreenAction:) forControlEvents:UIControlEventTouchUpInside];
    //重播按钮点击事件
    [self.playerUI.repeatButton addTarget:self action:@selector(repeatPlay:) forControlEvents:UIControlEventTouchUpInside];
    //返回按钮
    [self.playerUI.backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    // slider开始滑动事件
    [self.playerUI.videoSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
    // slider滑动中事件
    [self.playerUI.videoSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    // slider结束滑动事件
    [self.playerUI.videoSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
    
    [self.player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - 计时器事件

- (void)playerTimerAction {
    if (self.playerItem.duration.timescale != 0) {
        self.playerUI.videoSlider.maximumValue = 1;//音乐总共时长
        self.playerUI.videoSlider.value = CMTimeGetSeconds([self.playerItem currentTime]) / (self.playerItem.duration.value / _playerItem.duration.timescale);//当前进度
        
        //当前时长进度progress
        NSInteger proMin = (NSInteger)CMTimeGetSeconds([self.player currentTime]) / 60;//当前秒
        NSInteger proSec = (NSInteger)CMTimeGetSeconds([self.player currentTime]) % 60;//当前分钟
        
        //duration 总时长
        NSInteger durMin = (NSInteger)_playerItem.duration.value / _playerItem.duration.timescale / 60;//总秒
        NSInteger durSec = (NSInteger)_playerItem.duration.value / _playerItem.duration.timescale % 60;//总分钟
        
        self.playerUI.currentDurationLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
        self.playerUI.totalDurationLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
    }
}

#pragma mark - NSNotification action

//开始播放
- (void) play {
    self.state = YZPlayerStatePlaying;
    [self playButtonAction:self.playerUI.playButton];
}

//暂停
- (void)pause {
    self.state = YZPlayerStatePause;
    [self playButtonAction:self.playerUI.playButton];
}

//重置播放器
- (void)resetPlayer
{
    self.playDidEnd = NO;
    self.playerItem = nil;
    self.state = YZPlayerStateStopped;
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 关闭定时器
    [self.timer invalidate];
    self.timer = nil;
    // 暂停
    [self pause];
    // 移除原来的layer
    [self.playerLayer removeFromSuperlayer];
    // 替换PlayerItem
    [self.player replaceCurrentItemWithPlayerItem:nil];
    // 重置控制层View
    [self.playerUI resetPlayerUI];
    // 非重播时，移除当前playerView
    if (!self.repeatToPlay) {
        [self removeFromSuperview];
    }
}

- (void)playButtonAction:(UIButton *)button {
    
    button.selected = !button.selected;
    self.isPauseByUser = !button.isSelected;
    if (button.selected) {
        [self.player play];
    } else {
        [self.player pause];
    }
    [self autoHidePlayerUI];
}

//重播
- (void)repeatPlay:(UIButton *)button {
    // 隐藏重播按钮
    self.playerUI.repeatButton.hidden = YES;
    self.repeatToPlay = YES;
    // 重置Player
    [self resetPlayer];
    [self setVideoUrl:self.videoUrl];
    self.playerUI.playButton.selected = NO;
    [self playButtonAction:self.playerUI.playButton];
    self.isUIShowing = NO;
    [self showPlayerUI];
}

- (void) backAction {
    [self interfaceOrientation:UIInterfaceOrientationPortrait];
}

//播放结束
- (void)moviePlayDidEnd:(NSNotification *)notification {
    self.state = YZPlayerStateStopped;
    self.playDidEnd  = YES;
    self.playerUI.repeatButton.hidden = NO;
    self.isUIShowing = YES;
    [self hidePlayerUI];
}

// 应用退到后台
- (void)appDidEnterBackground {
    [self pause];
}

// 应用进入前台
- (void)appDidEnterPlayGround {
    self.isUIShowing = NO;
    [self showPlayerUI];
    if (!self.isPauseByUser) {
        self.playerUI.playButton.selected = YES;
        self.isPauseByUser = NO;
        [self play];
    }
}



#pragma mark - Slider action

// slider开始滑动事件
- (void)progressSliderTouchBegan:(UISlider *)slider
{
    if (self.player.status == AVPlayerStatusReadyToPlay) {
        // 暂停timer
        [self.timer setFireDate:[NSDate distantFuture]];
    }
}

// slider滑动中事件
- (void)progressSliderValueChanged:(UISlider *)slider
{
    
    if (self.player.status == AVPlayerStatusReadyToPlay) {
        NSString *style = @"";
        CGFloat value = slider.value - self.sliderLastValue;
        if (value > 0) {
            style = @">>";
        } else if (value < 0) {
            style = @"<<";
        }
        self.sliderLastValue = slider.value;
        //拖动改变视频播放进度
        if (self.player.status == AVPlayerStatusReadyToPlay) {
            
            [self.player pause];
            //计算出拖动的当前秒数
            CGFloat total  = (CGFloat)self.playerItem.duration.value / self.playerItem.duration.timescale;
            
            NSInteger dragedSeconds = floorf(total * slider.value);
            
            //转换成CMTime才能给player来控制播放进度
            
            CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
            // 拖拽的时长
            NSInteger proMin = (NSInteger)CMTimeGetSeconds(dragedCMTime) / 60;//当前秒
            NSInteger proSec = (NSInteger)CMTimeGetSeconds(dragedCMTime) % 60;//当前分钟
            
            //duration 总时长
            NSInteger durMin = (NSInteger)total / 60;//总秒
            NSInteger durSec = (NSInteger)total % 60;//总分钟
            
            NSString *currentTime = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
            NSString *totalTime = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
            
            if (total > 0) {
                self.playerUI.currentDurationLabel.text = currentTime;
                self.playerUI.horizontalLabel.hidden = NO;
                self.playerUI.horizontalLabel.text  = [NSString stringWithFormat:@"%@ %@ / %@",style, currentTime, totalTime];
            } else {
                slider.value = 0;
            }
        }
    } else {
        slider.value = 0;
    }
}

// slider结束滑动事件
- (void)progressSliderTouchEnded:(UISlider *)slider
{
    
    if (self.player.status == AVPlayerStatusReadyToPlay) {
        // 继续开启timer
        [self.timer setFireDate:[NSDate date]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.playerUI.horizontalLabel.hidden = YES;
        });
        // 结束滑动时候把开始播放按钮改为播放状态
        self.playerUI.playButton.selected = YES;
        self.isPauseByUser = NO;
        
        //计算出拖动的当前秒数
        CGFloat total = (CGFloat)_playerItem.duration.value / _playerItem.duration.timescale;
        
        NSInteger dragedSeconds = floorf(total * slider.value);
        
        //转换成CMTime才能给player来控制播放进度
        
        CMTime dragedCMTime     = CMTimeMake(dragedSeconds, 1);
        
        [self endSlideTheVideo:dragedCMTime];
    }
 
}

// 滑动结束视频跳转
- (void)endSlideTheVideo:(CMTime)dragedCMTime
{
    [self.player seekToTime:dragedCMTime completionHandler:^(BOOL finish){
        // 如果点击了暂停按钮
        if (self.isPauseByUser) {
            return ;
        }
        [self.player play];
        if (!self.playerItem.isPlaybackLikelyToKeepUp) {
            self.state = YZPlayerStateBuffering;
        }
    }];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    
    if (object == self.player) {
        if ([keyPath isEqualToString:@"rate"]) {
            if (self.player.rate == 0 && self.state != YZPlayerStateBuffering) {
                self.isPlaying = NO;
            } else {
                self.isPlaying = YES;
            }
        }
    }
    if (object == self.playerItem) {
        if ([keyPath isEqualToString:@"status"]) {
            
            if (self.player.status == AVPlayerStatusReadyToPlay) {
                
                self.state = YZPlayerStatePlaying;
                // 加载完成后，再添加拖拽手势
                // 添加平移手势，用来控制音量、亮度、快进快退
                UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panDirection:)];
                pan.delegate = self;
                [self.playerUI.centerView addGestureRecognizer:pan];
                
            } else if (self.player.status == AVPlayerStatusFailed){
                
                [self.playerUI.activity startAnimating];
            }
            
        } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) { // 计算缓冲进度
            
            NSTimeInterval timeInterval = [self availableDuration];
            CMTime duration  = self.playerItem.duration;
            CGFloat totalDuration = CMTimeGetSeconds(duration);
            [self.playerUI.progressView setProgress:timeInterval / totalDuration animated:NO];
            
        } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) { // 当缓冲是空的时候
            
            if (self.playerItem.playbackBufferEmpty) {
                [self bufferingForSeconds];
            }
            
        }else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) { // 当缓冲好的时候
            
            if (self.playerItem.playbackLikelyToKeepUp){
                self.state = YZPlayerStatePlaying;
            }
            
        }
    }
}

//计算缓冲进度
- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[self.player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

//缓冲较差时候
- (void)bufferingForSeconds
{
    self.state = YZPlayerStateBuffering;
    // playbackBufferEmpty会反复进入，因此在bufferingOneSecond延时播放执行完之前再调用bufferingSomeSecond都忽略
    static BOOL isBuffering = NO;
    if (isBuffering) {
        return;
    }
    isBuffering = YES;
    
    // 需要先暂停一小会之后再播放，否则网络状况不好的时候时间在走，声音播放不出来
    [self.player pause];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 如果此时用户已经暂停了，则不再需要开启播放了
        if (self.isPauseByUser) {
            isBuffering = NO;
            return;
        }
        
        [self.player play];
        // 如果执行了play还是没有播放则说明还没有缓存好，则再次缓存一段时间
        isBuffering = NO;
        if (!self.playerItem.isPlaybackLikelyToKeepUp) {
            [self bufferingForSeconds];
        }
    });
}

#pragma mark - 点击手势
//创建手势
- (void)createTapGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tap.delegate = self;
    [self.playerUI.centerView addGestureRecognizer:tap];
}

// 轻拍方法
- (void)tapAction:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        if (self.isUIShowing) {
            [self hidePlayerUI];
        } else {
            [self showPlayerUI];
        }
    }
}

#pragma mark - 拖动手势

- (void)panDirection:(UIPanGestureRecognizer *)pan {
    //根据在view上Pan的位置，确定是调音量还是亮度
    CGPoint locationPoint = [pan locationInView:self];
    
    // 我们要响应水平移动和垂直移动
    // 根据上次和本次移动的位置，算出一个速率的point
    CGPoint veloctyPoint = [pan velocityInView:self];
    
    // 判断是垂直移动还是水平移动
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{ // 开始移动
            // 使用绝对值来判断移动的方向
            CGFloat x = fabs(veloctyPoint.x);
            CGFloat y = fabs(veloctyPoint.y);
            if (x > y) { // 水平移动
                self.panDirection = PanDirectionHorizontalMoved;
                // 取消隐藏
                self.playerUI.horizontalLabel.hidden = NO;
                // 给sumTime初值
                CMTime time = self.player.currentTime;
                self.sumTime = time.value/time.timescale;
                
                // 暂停视频播放
                [self.player pause];
                // 暂停timer
                [self.timer setFireDate:[NSDate distantFuture]];
            }
            else if (x < y){ // 垂直移动
                self.panDirection = PanDirectionVerticalMoved;
                // 开始滑动的时候,状态改为正在控制音量
                if (locationPoint.x > self.bounds.size.width / 2) {
                    self.isVolume = YES;
                    self.playerUI.volumeProgressView.hidden = NO;
                }else { // 状态改为显示亮度调节
                    self.isVolume = NO;
                    self.playerUI.brightnessProgressView.hidden = NO;
                }
                
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{ // 正在移动
            switch (self.panDirection) {
                case PanDirectionHorizontalMoved:{
                    [self horizontalMoved:veloctyPoint.x]; // 水平移动的方法只要x方向的值
                    break;
                }
                case PanDirectionVerticalMoved:{
                    [self verticalMoved:veloctyPoint.y]; // 垂直移动方法只要y方向的值
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{ // 移动停止
            // 移动结束也需要判断垂直或者平移
            // 比如水平移动结束时，要快进到指定位置，如果这里没有判断，当我们调节音量完之后，会出现屏幕跳动的bug
            switch (self.panDirection) {
                case PanDirectionHorizontalMoved:{
                    
                    // 继续播放
                    [self.player play];
                    [self.timer setFireDate:[NSDate date]];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        // 隐藏视图
                        self.playerUI.horizontalLabel.hidden = YES;
                    });
                    //快进、快退时候把开始播放按钮改为播放状态
                    self.playerUI.playButton.selected = YES;
                    self.isPauseByUser = NO;
                    
                    // 转换成CMTime才能给player来控制播放进度
                    CMTime dragedCMTime = CMTimeMake(self.sumTime, 1);
                    
                    [self endSlideTheVideo:dragedCMTime];
                    
                    // 把sumTime滞空，不然会越加越多
                    self.sumTime = 0;
                    break;
                }
                case PanDirectionVerticalMoved:{
                    // 垂直移动结束后，把状态改为不再控制音量
                    self.playerUI.volumeProgressView.hidden = YES;
                    self.playerUI.brightnessProgressView.hidden = YES;
                    self.isVolume = NO;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        self.playerUI.horizontalLabel.hidden = YES;
                    });
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }

}

- (void)verticalMoved:(CGFloat)value
{
    if (self.isVolume) {
        // 更改系统的音量
        self.volumeViewSlider.value -= value / 10000;// 越小幅度越小
        self.playerUI.volumeProgressView.progress = self.volumeViewSlider.value;
    }else {
        //亮度
        [UIScreen mainScreen].brightness -= value / 10000;
        self.playerUI.brightnessProgressView.progress = [UIScreen mainScreen].brightness;
    }
}

- (void)horizontalMoved:(CGFloat)value
{
    // 快进快退的方法
    NSString *style = @"";
    if (value < 0) {
        style = @"<<";
    }
    else if (value > 0){
        style = @">>";
    }
    
    // 每次滑动需要叠加时间
    self.sumTime += value / 200;
    
    // 需要限定sumTime的范围
    CMTime totalTime           = self.playerItem.duration;
    CGFloat totalMovieDuration = (CGFloat)totalTime.value/totalTime.timescale;
    if (self.sumTime > totalMovieDuration) {
        self.sumTime = totalMovieDuration;
    }else if (self.sumTime < 0){
        self.sumTime = 0;
    }
    
    // 当前快进的时间
    NSString *nowTime  = [self durationStringWithTime:(int)self.sumTime];
    // 总时间
    NSString *durationTime  = [self durationStringWithTime:(int)totalMovieDuration];
    // 给label赋值
    self.playerUI.horizontalLabel.text = [NSString stringWithFormat:@"%@ %@ / %@",style, nowTime, durationTime];
}

- (NSString *)durationStringWithTime:(int)time
{
    // 获取分钟
    NSString *min = [NSString stringWithFormat:@"%02d",time / 60];
    // 获取秒数
    NSString *sec = [NSString stringWithFormat:@"%02d",time % 60];
    return [NSString stringWithFormat:@"%@:%@", min, sec];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{

    if([touch.view isKindOfClass:[UIButton class]] || self.playDidEnd) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - 屏幕旋转

//监听屏幕方向变化
- (void)observingRotating {
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationDidChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:[UIDevice currentDevice]];
}

//屏幕方向发生变化调用这个方法
- (void)deviceOrientationDidChange {
    
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortrait:{
            self.isFullScreen = NO;
            self.playerUI.fullScreenButton.selected = NO;
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            self.isFullScreen = YES;
            self.playerUI.fullScreenButton.selected = YES;
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            self.isFullScreen = YES;
            self.playerUI.fullScreenButton.selected = YES;
        }
            break;
        default:
            break;
    }
}

//强制旋转屏幕
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

// 全屏按钮事件
- (void)fullScreenAction:(UIButton *)sender {
    
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:{
            [self interfaceOrientation:UIInterfaceOrientationPortrait];
        }
            break;
        case UIInterfaceOrientationPortrait:{
            [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            [self interfaceOrientation:UIInterfaceOrientationPortrait];
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            [self interfaceOrientation:UIInterfaceOrientationPortrait];
        }
            break;
        default:
            break;
    }
}

 #pragma mark - Getter & Setter

- (void)setIsFullScreen:(BOOL)isFullScreen {
    _isFullScreen = isFullScreen;
    if (isFullScreen == NO) {
        self.playerUI.topView.hidden = YES;
    } else {
        self.playerUI.topView.hidden = NO;
    }
}

- (void)setState:(YZMoviePlayerState)state {
    _state = state;
    
    if (state == YZPlayerStateBuffering) {
        [self.playerUI.activity startAnimating];
        self.playerUI.playButton.alpha = 0.0;
    }
    if (state != YZPlayerStateBuffering) {
        [self.playerUI.activity stopAnimating];
        if (self.isUIShowing) {
             self.playerUI.playButton.alpha = 1.0;
        }
    }
}

- (AVPlayerLayer *)playerLayer {
    if (!_playerLayer) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        _playerLayer.backgroundColor = [UIColor blackColor].CGColor;
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;//视频填充模式
        
    }
    return _playerLayer;
}

- (AVPlayer *)player {
    if (!_player) {
         _player = [AVPlayer playerWithPlayerItem:self.playerItem];
    }
    return _player;
}

- (void)setPlayerItem:(AVPlayerItem *)playerItem {
    if (_playerItem == playerItem) return;
    
    if (_playerItem) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
        [_playerItem removeObserver:self forKeyPath:@"status"];
        [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [_playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        [_playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    }
    _playerItem = playerItem;
    if (playerItem) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
        [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        // 缓冲区空了，需要等待数据
        [playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
        // 缓冲区有足够数据可以播放了
        [playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (YZPlayerUI *)playerUI {
    if (!_playerUI) {
        _playerUI = [[YZPlayerUI alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width*9.0/16.0)];
        [self addSubview:_playerUI];
        [_playerUI mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return _playerUI;
}

#pragma mark - dealloc

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_player removeObserver:self forKeyPath:@"rate"];
    NSLog(@"%s",__func__);
}

@end
