//
//  Comment.m
//  VMovie
//
//  Created by wyz on 16/4/10.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "Comment.h"
@implementation Comment

- (void)setUserinfo:(NSDictionary *)userinfo {
    _userinfo = userinfo;
    _userinfo = userinfo[@"userid"];
    _username = userinfo[@"username"];
    _avatar = userinfo[@"avatar"];
}

- (void)setAddtime:(NSString *)addtime {
    
    NSTimeInterval t = [addtime integerValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
    NSDateFormatter *dateFormmatter = [[NSDateFormatter alloc] init];
    dateFormmatter.dateFormat = @"MM-dd HH:mm";
    _addtime = [dateFormmatter stringFromDate:date];
}

+ (NSDictionary *) objectClassInArray {
    return @{
             @"subcomment":@"Comment"
             };
}

@end
