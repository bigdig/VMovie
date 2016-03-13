//
//  NewFeatureCell.h
//  VMovie
//
//  Created by wyz on 16/3/13.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewFeatureCell : UICollectionViewCell

/**图片索引 */
@property (nonatomic, assign) NSInteger imageIndex;

+ (instancetype) newFeatureCell;

@end
