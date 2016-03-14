//
//  Movie.h
//  VMovie
//
//  Created by wyz on 16/3/14.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject
/**编号 */
@property (nonatomic, copy) NSString *postid;
/**标题 */
@property (nonatomic, copy) NSString *title;
/**图片 */
@property (nonatomic, copy) NSString *image;
/**评分 */
@property (nonatomic, copy) NSString *rating;
/**时长 */
@property (nonatomic, copy) NSString *duration;
/**发布时间 */
@property (nonatomic, copy) NSString *publish_time;
/**喜欢人数 */
@property (nonatomic, copy) NSString *like_num;
/**分享人数 */
@property (nonatomic, copy) NSString *share_num;

@end
