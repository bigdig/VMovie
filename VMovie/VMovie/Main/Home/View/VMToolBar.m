//
//  VMToolBar.m
//  VMovie
//
//  Created by wyz on 16/4/10.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "VMToolBar.h"

@interface VMToolBar()
/**消息按钮 */
@property (nonatomic, strong) UIButton *messageButton;
/**评论消息 */
@property (nonatomic, strong) UITextField *textField;
/**喜欢按钮 */
@property (nonatomic, strong) UIButton *likeButton;
/**下载按钮 */
@property (nonatomic, strong) UIButton *cacheButton;

/**发送按钮 */
@property (nonatomic, strong) UIButton *sendButton;

@end

@implementation VMToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, -1);
        self.layer.shadowRadius = 1;
        self.layer.shadowOpacity = 0.5;
        [self addSubview:self.messageButton];
        [self addSubview:self.textField];
        [self addSubview:self.likeButton];
        [self addSubview:self.cacheButton];
        [self addSubview:self.commentButton];
        [self addSubview:self.sendButton];
        
        [self addConstraints];
    }
    return self;
}

- (void) addConstraints {
    
    [self.messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.centerY.equalTo(self);
        make.width.equalTo(@22);
        make.height.equalTo(@22);
    }];
    
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.centerY.height.equalTo(self.messageButton);
        make.width.equalTo(@44);
    }];
    
    [self.cacheButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.commentButton.mas_left).offset(-15);
        make.height.centerY.equalTo(self.messageButton);
        make.width.equalTo(@22);
    }];
    
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.cacheButton.mas_left).offset(-15);
        make.height.centerY.equalTo(self.messageButton);
        make.width.equalTo(@44);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.messageButton.mas_right).offset(10);
        make.right.equalTo(self.likeButton.mas_left).offset(-10);
        make.centerY.equalTo(self);
        make.height.equalTo(self);
    }];
    
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self);
        make.width.equalTo(@60);
    }];
}

- (void) EditingChanged:(UITextField *) sender {
    if (sender.text.length > 0) {
        self.likeButton.hidden = YES;
        self.cacheButton.hidden = YES;
        self.commentButton.hidden = YES;
        self.sendButton.hidden = NO;
        [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.messageButton.mas_right).offset(10);
            make.right.equalTo(self.sendButton.mas_left).offset(-10);
            make.centerY.height.equalTo(self);
        }];
    } else {
        self.likeButton.hidden = NO;
        self.cacheButton.hidden = NO;
        self.commentButton.hidden = NO;
        self.sendButton.hidden = YES;
        [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.likeButton.mas_left).offset(-10);
            make.left.equalTo(self.messageButton.mas_right).offset(10);
            make.centerY.height.equalTo(self);
        }];
    }
}

#pragma mark - 懒加载
- (UIButton *)messageButton {
    if (!_messageButton) {
        _messageButton = [UIButton new];
        [_messageButton setImage:[UIImage imageNamed:@"img_details_message"] forState:UIControlStateNormal];
    }
    return _messageButton;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [UITextField new];
        _textField.placeholder = @"我来说两句...";
        _textField.font = [UIFont  systemFontOfSize:14.0f];
        [_textField addTarget:self action:@selector(EditingChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (UIButton *)likeButton {
    if (!_likeButton) {
        _likeButton = [UIButton new];
        [_likeButton setImage:[UIImage imageNamed:@"img_back_like"] forState:UIControlStateNormal];
    }
    return _likeButton;
}

- (UIButton *)cacheButton {
    if (!_cacheButton) {
        _cacheButton = [UIButton new];
        [_cacheButton setImage:[UIImage imageNamed:@"img_player_bottom_cache"] forState:UIControlStateNormal];
    }
    return _cacheButton;
}

- (UIButton *)commentButton {
    if (!_commentButton) {
        _commentButton = [UIButton new];
        [_commentButton setImage:[UIImage imageNamed:@"img_details_message_number"] forState:UIControlStateNormal];
        [_commentButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _commentButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [[_commentButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            !self.commentBlock? :self.commentBlock();
        }];
    }
    return _commentButton;
}

- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [UIButton new];
        [_sendButton setBackgroundColor:RGBCOLOR(0, 182, 231)];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sendButton.hidden = YES;
    }
    return _sendButton;
}
@end
