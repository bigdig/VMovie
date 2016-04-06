//
//  DetailHeaderView.h
//  VMovie
//
//  Created by wyz on 16/3/16.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailHeaderView : UIView

+ (instancetype) headerView;

/**点击订阅按钮 */
@property (nonatomic, copy) void (^MarkBlock)();
/**点击缓存按钮 */
@property (nonatomic, copy) void (^DownBlock)();
/**点击喜欢按钮 */
@property (nonatomic, copy) void (^LikeBlock)();
/**登录 */
@property (nonatomic, copy) void (^LoginBlock)();
/**设置 */
@property (nonatomic, copy) void (^SettingBlock)();
/**消息 */
@property (nonatomic, copy) void (^MessageBlock)();

@end
