//
//  LoginTextCell.m
//  VMovie
//
//  Created by wyz on 16/4/6.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "LoginTextCell.h"

@interface LoginTextCell()
@property (strong, nonatomic) UIView *lineView;
@end

@implementation LoginTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!_textField) {
            _textField = [UITextField new];
            [_textField setFont:[UIFont systemFontOfSize:14.0f]];
            _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
//            [_textField addTarget:self action:@selector(editDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
//            [_textField addTarget:self action:@selector(textValueChanged:) forControlEvents:UIControlEventEditingChanged];
//            [_textField addTarget:self action:@selector(editDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
            [self.contentView addSubview:_textField];
            [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(20);
                make.left.equalTo(self.contentView).offset(App_Frame_Width / 5);
                make.right.equalTo(self.contentView).offset(-App_Frame_Width / 5);
                make.centerY.equalTo(self.contentView);
            }];

        }
        
        if (!_lineView) {
            _lineView = [UIView new];
            _lineView.backgroundColor = [UIColor lightGrayColor];
            [self.contentView addSubview:_lineView];
            [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0.5);
                make.left.equalTo(self.contentView).offset(App_Frame_Width / 5);
                make.right.equalTo(self.contentView).offset(-App_Frame_Width / 5);
                make.bottom.equalTo(self.textField).offset(4);
            }];
        }
    }
    return self;
}


@end
