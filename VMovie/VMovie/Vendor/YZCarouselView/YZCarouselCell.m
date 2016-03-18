//
//  YZCarouselCell.m
//  循环轮播图
//
//  Created by wyz on 16/3/17.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "YZCarouselCell.h"

@interface YZCarouselCell()

/**阴影 */
@property (nonatomic, strong) UIImageView *shadowView;

@end

@implementation YZCarouselCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _imageView = [UIImageView new];
        _imageView.backgroundColor = [UIColor whiteColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self.contentView addSubview:_imageView];
        
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:16.0f];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.numberOfLines = 0;
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    _imageView.frame = self.bounds;
    _shadowView.frame = self.bounds;
    
    _titleLabel.x = 15;
    _titleLabel.y = self.height  - 50;
    _titleLabel.width = App_Frame_Width - 2 * _titleLabel.x;
    _titleLabel.height = 30;
}

@end
