//
//  YZMoviePlayerView.h
//  MoviePlayer
//
//  Created by wyz on 16/3/30.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PlayButtonBlock)();

@interface YZMoviePlayerView : UIView

/**标题 */
@property (nonatomic, copy) NSString *title;

/**是否正在播放 */
@property (nonatomic, assign) BOOL isPlaying;

/** video url */
@property (nonatomic, copy) NSString *videoUrl;

- (void)cancelAutoHidePlayerUI;

- (void) resetPlayer;

- (void) play;
- (void) pause;

@end
