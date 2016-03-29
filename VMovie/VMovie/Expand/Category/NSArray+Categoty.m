//
//  NSArray+Categoty.m
//  VMovie
//
//  Created by wyz on 16/3/29.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "NSArray+Categoty.h"

@implementation NSArray (Categoty)

- (instancetype)deleteRepetitionElements {
    
    NSMutableArray *arrayM = [[NSMutableArray alloc] init];
    
    for (id object in self) {
        if (![arrayM containsObject:object]) {
            [arrayM addObject:object];
        }
    }
    
    return arrayM;
}
@end
