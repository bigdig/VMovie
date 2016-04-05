//
//  SeriesCell.m
//  VMovie
//
//  Created by wyz on 16/4/5.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "SeriesCell.h"
#import "UIImageView+WebCache.h"
#import "Series.h"

@interface SeriesCell()
/**图片 */
@property (nonatomic, strong) UIImageView *bgImageView;
/**标题 */
@property (nonatomic, strong) UILabel *titleLabel;
/**最新 */
@property (nonatomic, strong) UILabel *updateLabel;
/**订阅 */
@property (nonatomic, strong) UILabel *followLabel;
/**订阅按钮*/
@property (nonatomic, strong) UIButton *followButton;
/**正文 */
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation SeriesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.bgImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.updateLabel];
        [self.contentView addSubview:self.followLabel];
        [self.contentView addSubview:self.followButton];
        [self.contentView addSubview:self.contentLabel];
        
        [self makeConstraints];
    }
    return self;
}

- (void)makeConstraints {
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(@200);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.bgImageView.mas_bottom).offset(10);
    }];
    
    [self.updateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
    }];
    
    [self.followLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.updateLabel.mas_right).offset(10);
        make.top.equalTo(self.updateLabel);
    }];
    
    [self.followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.titleLabel);
        make.width.equalTo(@22);
        make.height.equalTo(@22);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.updateLabel.mas_bottom).offset(10);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
    
}

- (void)setSeries:(Series *)series {
    
    _series = series;
    
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:series.image]];
    self.titleLabel.text = series.title;
    self.updateLabel.text = [NSString stringWithFormat:@"已更新至%@集",series.update_to];
    self.followLabel.text = [series.follower_num stringByAppendingString:@"已订阅"];
    self.contentLabel.text = series.content;
}

#pragma mark - 懒加载

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.backgroundColor = RANDOM_UICOLOR;
        _bgImageView.clipsToBounds = YES;
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:17.0f];
    }
    return _titleLabel;
}

- (UILabel *)updateLabel {
    if (!_updateLabel) {
        _updateLabel = [[UILabel alloc] init];
        _updateLabel.textColor = [UIColor grayColor];
        _updateLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return _updateLabel;
}

- (UILabel *)followLabel {
    if (!_followLabel) {
        _followLabel = [[UILabel alloc] init];
        _followLabel.textColor = [UIColor grayColor];
        _followLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return _followLabel;
}

- (UIButton *)followButton {
    if (!_followButton) {
        _followButton = [[UIButton alloc] init];
        [_followButton setBackgroundImage:[UIImage imageNamed:@"img_attention"] forState:UIControlStateNormal];
    }
    return _followButton;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.font = [UIFont systemFontOfSize:14.0f];
        _contentLabel.numberOfLines = 2;
    }
    return _contentLabel;
}

@end
