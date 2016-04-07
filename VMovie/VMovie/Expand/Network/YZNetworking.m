//
//  YZNetworking.m
//  YZNetworking
//
//  Created by wyz on 16/3/28.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "YZNetworking.h"
#import <AFNetworking/AFNetworking.h>
#import <CommonCrypto/CommonDigest.h>

#define kCACHEPATH @"ResponseCache"

@implementation YZNetworking

+ (instancetype)sharedManager {
    static id sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)GET:(NSString *)URLString parameters:(id)parameters success:(successBlock)success failure:(failureBlock)failure {
    
    //如果URL为空,直接返回
    if (!URLString || URLString.length <= 0) return;
    
    //转码
    URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    id responseData = [self loadResponseDataWithURL:URLString Parameters:parameters];
    if (responseData) {
        success(responseData);
    }
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [self GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(responseObject);
        }
        //缓存
        [self saveResponseData:responseObject WithURL:URLString Parameters:parameters];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
}

//缓存请求返回数据
- (BOOL)saveResponseData:(NSDictionary *)responseData WithURL:(NSString *)urlPath Parameters:(NSDictionary *)parameters{
    NSMutableString *localPath = [urlPath mutableCopy];
    if (parameters) {
        [localPath appendString:parameters.description];
    }
    if([self createDirInCache:kCACHEPATH]){
        NSString *abslutePath = [NSString stringWithFormat:@"%@/%@.plist", [self pathInCacheDirectory:kCACHEPATH], [self md5StrOfString:localPath]];
        return [responseData writeToFile:abslutePath atomically:YES];
    } else{
        return NO;
    }
}

//根据url和参数取出缓存数据
- (id)loadResponseDataWithURL:(NSString *)urlPath Parameters:(NSDictionary *)parameters {
    
    //所有 Get 请求，增加缓存机制
    NSMutableString *localPath = [urlPath mutableCopy];
    if (parameters) {
        [localPath appendString:parameters.description];
    }
    
    //取出缓存数据
    NSString *abslutePath = [NSString stringWithFormat:@"%@/%@.plist", [self pathInCacheDirectory:kCACHEPATH], [self md5StrOfString:localPath]];
    return [NSMutableDictionary dictionaryWithContentsOfFile:abslutePath];
}

//获取cache的地址
- (NSString* )pathInCacheDirectory:(NSString *)fileName
{
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cachePaths objectAtIndex:0];
    return [cachePath stringByAppendingPathComponent:fileName];
}

//创建缓存文件夹
- (BOOL)createDirInCache:(NSString *)dirName
{
    NSString *dirPath = [self pathInCacheDirectory:dirName];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    BOOL isCreated = NO;
    if ( !(isDir == YES && existed == YES) )
    {
        isCreated = [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (existed) {
        isCreated = YES;
    }
    return isCreated;
}

//删除指定url和参数的缓存数据
- (BOOL)deleteResponseCacheWithURL:(NSString *)urlPath Parameters:(NSDictionary *)parameters{
   
    NSMutableString *localPath = [urlPath mutableCopy];
    if (parameters) {
        [localPath appendString:parameters.description];
    }
    
    NSString *abslutePath = [NSString stringWithFormat:@"%@/%@.plist", [self pathInCacheDirectory:kCACHEPATH], [self md5StrOfString:localPath]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:abslutePath]) {
        return [fileManager removeItemAtPath:abslutePath error:nil];
    }else{
        return NO;
    }
}

//删除缓存数据
- (BOOL) deleteResponseCache{
    return [self deleteCacheWithPath:kCACHEPATH];
}

//通过缓存路径删除缓存数据
- (BOOL) deleteCacheWithPath:(NSString *)cachePath{
    NSString *dirPath = [self pathInCacheDirectory:cachePath];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    bool isDeleted = false;
    if ( isDir == YES && existed == YES )
    {
        isDeleted = [fileManager removeItemAtPath:dirPath error:nil];
    }
    return isDeleted;
}

//获取md5字符串
- (NSString *)md5StrOfString:(NSString *)string{
    const char *cStr = [string UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end
