//
//  ChannelCell.h
//  VMovie
//
//  Created by wyz on 16/3/16.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Channel;

@interface ChannelCell : UICollectionViewCell

/**channel模型 */
@property (nonatomic, strong) Channel *channel;

@end
