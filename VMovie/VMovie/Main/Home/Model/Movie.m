//
//  Movie.m
//  VMovie
//
//  Created by wyz on 16/3/14.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "Movie.h"

@implementation Movie

- (NSString *)duration {
    
    NSInteger durationTime = _duration.integerValue;
    
    NSInteger minute = durationTime / 60;
    NSInteger second = durationTime % 60;
   
    return  [NSString stringWithFormat:@"%02ld:%02ld",(long)minute,(long)second];
}

@end
