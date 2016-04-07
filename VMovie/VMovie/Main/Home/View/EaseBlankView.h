//
//  EaseBlankView.h
//  VMovie
//
//  Created by wyz on 16/3/25.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EaseBlankView : UIView
- (void) configWithText:(NSString *)text hasData:(BOOL)hasData hasError:(BOOL)hasError reloadDataBlock:(void(^)(id)) block;
@end
