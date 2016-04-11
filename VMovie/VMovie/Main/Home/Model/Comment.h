//
//  Comment.h
//  VMovie
//
//  Created by wyz on 16/4/10.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject
/**id */
@property (nonatomic, copy) NSString *commentid;
/**内容 */
@property (nonatomic, copy) NSString *content;
/**时间 */
@property (nonatomic, copy) NSString *addtime;
/**用户id */
@property (nonatomic, copy) NSString *userid;
/**点赞数 */
@property (nonatomic, copy) NSString *count_approve;
/**用户姓名 */
@property (nonatomic, copy) NSString *username;
/**头像 */
@property (nonatomic, copy) NSString *avatar;
/**用户信息 */
@property (nonatomic, strong) NSDictionary *userinfo;
/**回复用户姓名 */
@property (nonatomic, copy) NSString *reply_username;
/**是否是评论回复 */
@property (nonatomic, assign) BOOL isSubComment;

/**子评论 */
@property (nonatomic, strong) NSMutableArray  *subcomment;

@end
