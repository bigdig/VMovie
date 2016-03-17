//
//  Channel.h
//  VMovie
//
//  Created by wyz on 16/3/16.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Channel : NSObject

/**编号 */
@property (nonatomic, copy) NSString *orderid;
/**分类编号 */
@property (nonatomic, copy) NSString *cateid;
/**分类名称 */
@property (nonatomic, copy) NSString *catename;
/**别名 */
@property (nonatomic, copy) NSString *alias;
/**url */
@property (nonatomic, copy) NSString *icon;

@end
