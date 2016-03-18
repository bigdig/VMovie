//
//  YZCarouselView.h
//  循环轮播图
//
//  Created by wyz on 16/3/17.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SelectItemBlock)(NSInteger index);

@interface YZCarouselView : UIView

/**图片数组 */
@property (nonatomic, strong) NSArray *imageArray;
/**标题数组 */
@property (nonatomic, strong) NSArray *titleArray;

/**点击item的block */
@property (nonatomic, copy) SelectItemBlock selecItemBlock;
@end
