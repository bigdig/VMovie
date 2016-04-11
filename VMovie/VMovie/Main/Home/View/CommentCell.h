//
//  CommentCell.h
//  VMovie
//
//  Created by wyz on 16/4/10.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Comment;
@interface CommentCell : UITableViewCell
/**模型 */
@property (nonatomic, strong) Comment *comment;

- (CGFloat ) cellHeight:(Comment *) comment;
@end
