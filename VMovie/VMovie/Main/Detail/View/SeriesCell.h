//
//  SeriesCell.h
//  VMovie
//
//  Created by wyz on 16/4/5.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Series;
@interface SeriesCell : UITableViewCell

/**模型 */
@property (nonatomic, strong) Series *series;

@end
