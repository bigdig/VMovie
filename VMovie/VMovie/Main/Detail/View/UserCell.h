//
//  UserCell.h
//  VMovie
//
//  Created by wyz on 16/4/6.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCell : UITableViewCell
/**退出 */
@property (nonatomic, copy) void (^logoutBlock)();
@end
