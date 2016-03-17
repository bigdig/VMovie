//
//  DetailHeaderView.m
//  VMovie
//
//  Created by wyz on 16/3/16.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "DetailHeaderView.h"
#import "VMVerticalButton.h"

@implementation DetailHeaderView

+ (instancetype)headerView {
    
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.height = App_Frame_Height * 0.45;
        
        [self setupAvatarView];
        [self setupListView];
        
        
        

    }
    return self;
}

- (void) setupAvatarView {
    UIView *avatarView = [[UIView alloc] init];
    avatarView.backgroundColor = [UIColor clearColor];;
    [self addSubview:avatarView];
    [avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.equalTo(@(App_Frame_Height * 0.30));
    }];
    
    UIButton *avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    avatarButton.backgroundColor = RANDOM_UICOLOR;
    [avatarButton setImage:[UIImage imageNamed:@"menu_avatar_default"] forState:UIControlStateNormal];
    [avatarButton setImage:[UIImage imageNamed:@"menu_avatar_default"] forState:UIControlStateHighlighted];
    [avatarButton setTitle:@"点击登录" forState:UIControlStateNormal];
    avatarButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [avatarButton.titleLabel sizeToFit];
    [avatarButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    avatarButton.titleEdgeInsets = UIEdgeInsetsMake(avatarButton.currentImage.size.height + 10, -avatarButton.currentImage.size.width, 0, 0);
    avatarButton.imageEdgeInsets = UIEdgeInsetsMake(-avatarButton.titleLabel.height, 0, 0, 0);
    [avatarView addSubview:avatarButton];
    [avatarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(avatarView).offset(20);
        make.bottom.centerX.equalTo(avatarView);
        make.width.equalTo(@83);
    }];
    
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingButton setBackgroundImage:[UIImage imageNamed:@"menu_setting_bg"] forState:UIControlStateNormal];
    [avatarView addSubview:settingButton];
    [settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@30);
        make.centerY.equalTo(avatarButton);
        make.right.equalTo(avatarButton.mas_left).offset(-ScaleFrom_iPhone5_Desgin(30));
    }];
    
    UIButton *voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [voiceButton setBackgroundImage:[UIImage imageNamed:@"menu_setting_message"] forState:UIControlStateNormal];
    [avatarView addSubview:voiceButton];
    [voiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerY.equalTo(settingButton);
        make.left.equalTo(avatarButton.mas_right).offset(ScaleFrom_iPhone5_Desgin(30));
    }];

}

- (void) setupListView {
    
    UIView *listView = [[UIView alloc] init];
    listView.backgroundColor = [UIColor clearColor];
    [self addSubview:listView];
    [listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(- ScaleFrom_iPhone5_Desgin(10));
        make.height.equalTo(@(App_Frame_Height * 0.13));
    }];
    
    VMVerticalButton *markButton = [VMVerticalButton buttonWithType:UIButtonTypeCustom];
    [markButton setImage:[UIImage imageNamed:@"menu_mark_bg"] forState:UIControlStateNormal];
    [markButton setTitle:@"我的订阅" forState:UIControlStateNormal];
    [listView addSubview:markButton];
    [markButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(listView);
        make.width.equalTo(@(App_Frame_Width / 3));
    }];
    
    VMVerticalButton *downButton = [VMVerticalButton buttonWithType:UIButtonTypeCustom];
    [downButton setImage:[UIImage imageNamed:@"menu_down_bg"] forState:UIControlStateNormal];
    [downButton setTitle:@"离线下载" forState:UIControlStateNormal];
    downButton.showMessage = YES;
    [listView addSubview:downButton];
    [downButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(markButton.mas_right);
        make.width.height.top.equalTo(markButton);
    }];
    
    VMVerticalButton *likeButton = [VMVerticalButton buttonWithType:UIButtonTypeCustom];
    [likeButton setImage:[UIImage imageNamed:@"menu_like_bg"] forState:UIControlStateNormal];
    [likeButton setTitle:@"我喜欢的" forState:UIControlStateNormal];
    [listView addSubview:likeButton];
    [likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(downButton.mas_right);
        make.width.height.top.equalTo(markButton);
    }];
    
    UIImageView *separator1 = [[UIImageView alloc] init];
    separator1.image = [UIImage imageNamed:@"backStage_seperate_bg"];
    [listView addSubview:separator1];
    [separator1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(markButton.mas_right);
        make.height.equalTo(@20);
        make.width.equalTo(@1);
        make.centerY.equalTo(markButton).offset(5);
    }];
    
    UIImageView *separator2 = [[UIImageView alloc] init];
    separator2.image = [UIImage imageNamed:@"backStage_seperate_bg"];
    [listView addSubview:separator2];
    [separator2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(downButton.mas_right);
        make.height.equalTo(@20);
        make.width.equalTo(@1);
        make.centerY.equalTo(markButton).offset(5);
    }];

}

@end
