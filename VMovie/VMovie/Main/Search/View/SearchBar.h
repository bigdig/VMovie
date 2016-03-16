//
//  SearchBar.h
//  VMovie
//
//  Created by wyz on 16/3/15.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ShowHistoryBlock)();

@interface SearchBar : UITextField

+ (instancetype) searchBar;

@property (nonatomic, copy) ShowHistoryBlock showHistoryBlock;

@end
