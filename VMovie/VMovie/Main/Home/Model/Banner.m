//
//  Banner.m
//  VMovie
//
//  Created by wyz on 16/3/15.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "Banner.h"
#import "NSString+JSON.h"

@implementation Banner

- (void)setExtra:(NSString *)extra {
    
    _extra = extra;
    
    if (extra.length > 0) {
        NSDictionary *extraDict = [NSString parseJSONStringToNSDictionary:extra];
        
        NSNumber *type  = extraDict[@"app_banner_type"];
        _bannerType = type.integerValue;
        _bannerURL = extraDict[@"app_banner_param"];
    }
    
}

@end
