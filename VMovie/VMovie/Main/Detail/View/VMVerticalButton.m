//
//  VMVerticalButton.m
//  VMovie
//
//  Created by wyz on 16/3/16.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "VMVerticalButton.h"

@interface VMVerticalButton()

/** 小红点 */
@property (nonatomic, weak) UIImageView *dotView;

@end

@implementation VMVerticalButton

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    
    [self setup];
}

- (void) setup {
    
    self.titleLabel.font = [UIFont systemFontOfSize:10.0f];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    UIImageView *dotView = [[UIImageView alloc] init];
    dotView.image = [UIImage imageNamed:@"menu_message_show"];
    [self addSubview:dotView];
    self.dotView = dotView;
    self.dotView.hidden = YES;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.imageView.width = self.currentImage.size.width;
    self.imageView.height = self.currentImage.size.height;
    self.imageView.y = self.width * 0.2;
    self.imageView.centerX = self.width * 0.5;
    
    self.titleLabel.x = 0;
    self.titleLabel.y = CGRectGetMaxY(self.imageView.frame) - 10;
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.titleLabel.y;
    
    self.dotView.width = 5;
    self.dotView.height = 5;
    self.dotView.x = CGRectGetMaxX(self.imageView.frame) + 5;
    self.dotView.y = CGRectGetMinY(self.imageView.frame);
    
}

- (void)setShowMessage:(BOOL)showMessage {
    _showMessage = showMessage;
    
    self.dotView.hidden = !showMessage;
}

- (void)setHighlighted:(BOOL)highlighted {
    
}

@end
