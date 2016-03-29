//
//  YZNetworking.h
//  YZNetworking
//
//  Created by wyz on 16/3/28.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^successBlock)(id _Nullable responseObject);
typedef void (^failureBlock)(NSError * _Nonnull error);

@interface YZNetworking : NSObject

+ (void)GET:(NSString * _Nonnull)URLString parameters:(id _Nullable)parameters success:(_Nullable successBlock)success failure:(_Nullable failureBlock)failure;

@end
