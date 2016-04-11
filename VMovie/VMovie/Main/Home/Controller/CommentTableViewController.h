//
//  CommentTableViewController.h
//  VMovie
//
//  Created by wyz on 16/4/11.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Movie;
@interface CommentTableViewController : UITableViewController
/**电影模型 */
@property (nonatomic, strong) Movie *movie;

/**取得评论总数 */
@property (nonatomic, copy) void (^commentCountBlock)(NSInteger);

/**点击头 */
@property (nonatomic, copy) void (^ClickHeaderBlock)();
@property (nonatomic, copy) void (^beginScrollBlock)();
@end
