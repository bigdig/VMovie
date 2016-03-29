//
//  EaseBlankView.m
//  VMovie
//
//  Created by wyz on 16/3/25.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "EaseBlankView.h"

@interface EaseBlankView()
/**提示标签 */
@property (nonatomic, strong) UILabel *tipLabel;
/**重新加载 */
@property (nonatomic, strong) UIButton *reloadButton;

@property (copy, nonatomic) void(^reloadButtonBlock)(id sender);

@end

@implementation EaseBlankView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void) configWithData:(BOOL) hasData  reloadDataBlock:(void(^)(id)) block {
    
    
    if (hasData) {
        [self removeFromSuperview];
        return;
    }
    
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.backgroundColor = [UIColor clearColor];
        _tipLabel.numberOfLines = 0;
        _tipLabel.font = [UIFont systemFontOfSize:14.0f];
        _tipLabel.textColor = [UIColor lightGrayColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.text = @"加载失败";
        [self addSubview:_tipLabel];
    }
    
    if (!_reloadButton) {
        _reloadButton = [[UIButton alloc] init];
        [_reloadButton setTitle:@"点击重试" forState:UIControlStateNormal];
        _reloadButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_reloadButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_reloadButton sizeToFit];
        _reloadButton.layer.masksToBounds = YES;
        _reloadButton.layer.cornerRadius = _reloadButton.height/2;
        _reloadButton.layer.borderWidth = 1.0;
        _reloadButton.layer.borderColor = [UIColor blueColor].CGColor;
        [self addSubview:_reloadButton];
    }
    //    布局
    [_reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_centerY);
        make.width.equalTo(@120);
    }];
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerX.equalTo(self);
        make.bottom.equalTo(_reloadButton.mas_top);
        make.height.mas_equalTo(50);
    }];
    
    _reloadButtonBlock = block;
}

- (void) reloadButtonClick:(UIButton *) button {
    self.hidden = YES;
    [self removeFromSuperview];
    
    !_reloadButtonBlock? :_reloadButtonBlock(button);
}
@end
