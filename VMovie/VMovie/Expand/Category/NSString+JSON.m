//
//  NSString+JSON.m
//  VMovie
//
//  Created by wyz on 16/3/18.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "NSString+JSON.h"

@implementation NSString (JSON)

+(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}

@end
