//
//  Series.h
//  VMovie
//
//  Created by wyz on 16/4/5.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Series : NSObject

/**编号 */
@property (nonatomic, copy) NSString *seriesid;
/**标题 */
@property (nonatomic, copy) NSString *title;
/**图片 */
@property (nonatomic, copy) NSString *image;
/**内容 */
@property (nonatomic, copy) NSString *content;
/**最新 */
@property (nonatomic, copy) NSString *update_to;
/**订阅 */
@property (nonatomic, copy) NSString *follower_num;
/**是否订阅 */
@property (nonatomic, copy) NSString *isfollow;
/**是否结束 */
@property (nonatomic, copy) NSString *is_end;
/**app图片 */
@property (nonatomic, copy) NSString *app_image;

@end
