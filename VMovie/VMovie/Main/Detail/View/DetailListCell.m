//
//  DetailListCell.m
//  VMovie
//
//  Created by wyz on 16/3/16.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "DetailListCell.h"

@interface DetailListCell()

/** 指示器 */
@property (nonatomic, weak) UIView *indicatorView;

@end

@implementation DetailListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.textColor = [UIColor grayColor];
        
        UIView *indicatorView = [[UIView alloc] init];
        indicatorView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:indicatorView];
        self.indicatorView = indicatorView;
        
    }
    return  self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.indicatorView.x = 0;
    self.indicatorView.y = 0;
    self.indicatorView.width = 5;
    self.indicatorView.height = self.height;
    
    self.imageView.x = self.width * 0.1;
    self.textLabel.x = CGRectGetMaxX(self.imageView.frame) + 20;
}

- (void)setImageName:(NSString *)imageName {
    _imageName = [imageName copy];
    self.imageView.image = [UIImage imageNamed:[imageName stringByAppendingString:@"_focus"]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.indicatorView.hidden = !selected;
    
    self.textLabel.textColor = selected ? [UIColor whiteColor] : [UIColor grayColor];
    
    self.backgroundColor = selected ? [UIColor colorWithWhite:0.1 alpha:1.0] : [UIColor clearColor];
    
    
    NSString *focusImageName = [self.imageName stringByAppendingString:@"_focus"];
    if (focusImageName) {
        self.imageView.image = !selected ? [UIImage imageNamed:focusImageName] : [UIImage imageNamed:self.imageName];
    }
    
}

@end
