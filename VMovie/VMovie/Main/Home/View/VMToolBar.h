//
//  VMToolBar.h
//  VMovie
//
//  Created by wyz on 16/4/10.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VMToolBar : UIView
/**评论按钮 */
@property (nonatomic, strong) UIButton *commentButton;
/**评论 */
@property (nonatomic, copy) void(^commentBlock)();
@end
