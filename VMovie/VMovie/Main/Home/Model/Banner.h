//
//  Banner.h
//  VMovie
//
//  Created by wyz on 16/3/15.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,BannerType) {
    BannerTypeMovie = 2,
    BannerTypeAD = 1
};

@interface Banner : NSObject
/**编号 */
@property (nonatomic, copy) NSString *bannerid;
/**标题 */
@property (nonatomic, copy) NSString *title;
/**图片 */
@property (nonatomic, copy) NSString *image;
/**添加时间 */
@property (nonatomic, copy) NSString *addtime;
/**额外信息 */
@property (nonatomic, copy) NSString *extra;

/**类型 */
@property (nonatomic, assign) BannerType bannerType;

/**连接 */
@property (nonatomic, copy) NSString *bannerURL;

@end
