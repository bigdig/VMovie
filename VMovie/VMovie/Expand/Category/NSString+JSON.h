//
//  NSString+JSON.h
//  VMovie
//
//  Created by wyz on 16/3/18.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JSON)

+(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString;

@end
