//
//  CommentCell.m
//  VMovie
//
//  Created by wyz on 16/4/10.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "CommentCell.h"
#import "Comment.h"
#import "UIImageView+Extension.h"

@interface CommentCell()
/**头像 */
@property (nonatomic, strong) UIImageView *avatarView;
/**用户名 */
@property (nonatomic, strong) UILabel *usernameLabel;
/**时间 */
@property (nonatomic, strong) UILabel *timeLabel;
/**点赞 */
@property (nonatomic, strong) UIButton *appreciatedButton;
/**评论内容 */
@property (nonatomic, strong) UILabel *contentLabel;
@end
@implementation CommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.avatarView];
        [self.contentView  addSubview:self.usernameLabel];
        [self.contentView  addSubview:self.timeLabel];
        [self.contentView  addSubview:self.appreciatedButton];
        [self.contentView addSubview:self.contentLabel];
        
        [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.contentView).offset(10);
            make.width.height.equalTo(@35);
        }];
        
        [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarView.mas_right).offset(15);
            make.top.equalTo(self.avatarView);
        }];
        
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.usernameLabel);
            make.top.equalTo(self.usernameLabel.mas_bottom);
        }];
        
        [self.appreciatedButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarView);
            make.right.equalTo(self.contentView).offset(-30);
        }];
        
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.usernameLabel);
            make.top.equalTo(self.avatarView.mas_bottom).offset(5);
//            make.right.equalTo(self.appreciatedButton);
        }];
        
    }
    return self;
}

- (CGFloat ) cellHeight:(Comment *)comment {
    self.comment = comment;
    [self layoutIfNeeded];
    return CGRectGetMaxY(self.contentLabel.frame) + 10;
}

- (void)setComment:(Comment *)comment {
    _comment = comment;
    
    [self.avatarView setHeaderImage:comment.avatar];
    self.usernameLabel.text = comment.username;
    self.timeLabel.text = comment.addtime;
    [self.appreciatedButton setTitle:comment.count_approve forState:UIControlStateNormal];
    if ([comment.count_approve integerValue] > 0) {
        [self.appreciatedButton setImage:[UIImage imageNamed:@"img_details_appreciated_finish"] forState:UIControlStateNormal];
    } else {
        [self.appreciatedButton setImage:[UIImage imageNamed:@"img_details_appreciated"] forState:UIControlStateNormal];
    }
    
    if (comment.isSubComment) {
        self.contentLabel.text = [NSString stringWithFormat:@"回复 %@:%@",comment.reply_username,comment.content];
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(60);
            make.right.top.bottom.equalTo(self);
        }];
    } else {
        self.contentLabel.text = comment.content;
        
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
}

#pragma mark - 懒加载
- (UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [UIImageView new];
        _avatarView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _avatarView;
}

- (UILabel *)usernameLabel {
    if (!_usernameLabel) {
        _usernameLabel = [UILabel new];
        [_usernameLabel setTextColor:[UIColor blackColor]];
        _usernameLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _usernameLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        [_timeLabel setTextColor:[UIColor grayColor]];
        _timeLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return _timeLabel;
}

- (UIButton *)appreciatedButton {
    if (!_appreciatedButton) {
        _appreciatedButton = [UIButton new];
        [_appreciatedButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _appreciatedButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [_appreciatedButton setImage:[UIImage imageNamed:@"img_details_appreciated"] forState:UIControlStateNormal];
    }
    return _appreciatedButton;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.font = [UIFont systemFontOfSize:16.0f];
        _contentLabel.numberOfLines = 0;
        _contentLabel.preferredMaxLayoutWidth = self.contentView.width - 95;
    }
    return _contentLabel;
}

@end
