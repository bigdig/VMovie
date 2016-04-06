//
//  UserCell.m
//  VMovie
//
//  Created by wyz on 16/4/6.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "UserCell.h"
#import "UIButton+Bootstrap.h"

@implementation UserCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIButton *logoutButton =  [UIButton buttonWithStyle:StrapWarningStyle andTitle:@"退出" andFrame:CGRectMake(0, 0, 60, 25) target:self  action:@selector(logout)];
        logoutButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        self.accessoryView = logoutButton;
    }
    return self;
}


-(void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.width = 40;
    self.imageView.height = 40;
    self.imageView.centerY = self.contentView.centerY;
    
    self.textLabel.x = CGRectGetMaxX(self.imageView.frame)+20;
}

- (void) logout {
    !self.logoutBlock ? :self.logoutBlock();
}

@end
