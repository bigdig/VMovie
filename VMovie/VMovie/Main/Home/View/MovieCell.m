//
//  MovieCell.m
//  VMovie
//
//  Created by wyz on 16/3/14.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "MovieCell.h"
#import "UIImageView+WebCache.h"
#import "Movie.h"
#import <HCSStarRatingView/HCSStarRatingView.h>


@interface MovieCell()

/** 背景图片 */
@property (nonatomic, weak) UIImageView *bgView;
/** 标题 */
@property (nonatomic, weak) UILabel *titleLabel;
/** 时长 */
@property (nonatomic, weak) UILabel *durationLabel;
/** 阴影 */
@property (nonatomic, weak) UIImageView *shadowView;
/** 分享 */
@property (nonatomic, weak) UIButton *shareButton;
/** 评分 */
@property (nonatomic, weak) HCSStarRatingView *ratingView;

@end

@implementation MovieCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *bgView = [[UIImageView alloc] init];
        bgView.contentMode = UIViewContentModeScaleAspectFill;
        bgView.backgroundColor = RANDOM_UICOLOR;
        bgView.clipsToBounds = YES;
        [self.contentView addSubview:bgView];
        self.bgView = bgView;
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        UIImageView *shadowView = [[UIImageView alloc] init];
        shadowView.contentMode = UIViewContentModeScaleAspectFill;
        shadowView.image = [UIImage imageNamed:@"home_shadow_bg"];
        [self.contentView addSubview:shadowView];
        self.shadowView = shadowView;
        [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(bgView);
        }];
        
        HCSStarRatingView *ratingView = [[HCSStarRatingView alloc] init];
        ratingView.maximumValue = 5;
        ratingView.minimumValue = 0;
        ratingView.value = 0;
        ratingView.allowsHalfStars = YES;
        ratingView.emptyStarImage = [UIImage imageNamed:@"star_hui"];
        ratingView.filledStarImage = [UIImage imageNamed:@"foregroundStar"];
        ratingView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:ratingView];
        self.ratingView = ratingView;
        [ratingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.bottom.equalTo(self.contentView).offset(-10);
            make.height.equalTo(@25);
            make.width.equalTo(@80);
        }];
        
        UIButton *shareButton= [[UIButton alloc] init];
        [shareButton setImage:[UIImage imageNamed:@"home_share_icon"] forState:UIControlStateDisabled];
        shareButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        shareButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        shareButton.enabled = NO;
        [self.contentView addSubview:shareButton];
        self.shareButton = shareButton;
        [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.width.height.equalTo(ratingView);
            make.left.equalTo(ratingView.mas_right);
        }];
        
        UILabel *durationLabel = [[UILabel alloc] init];
        durationLabel.textColor = [UIColor whiteColor];
        durationLabel.font = [UIFont systemFontOfSize:14.0f];
        durationLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:durationLabel];
        self.durationLabel = durationLabel;
        [durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.width.height.equalTo(ratingView);
            make.right.equalTo(self.contentView).offset(-20);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:17.0f];
        titleLabel.preferredMaxLayoutWidth = App_Frame_Width - 40;
        titleLabel.numberOfLines = 0;
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.bottom.equalTo(ratingView.mas_top).offset(-10);
        }];
    }
    return  self;
}

- (void)setMovie:(Movie *)movie {
    
    _movie = movie;
    
    [self.bgView sd_setImageWithURL:[NSURL URLWithString:movie.image] placeholderImage:[UIImage imageNamed:@"common_button_hi"]];
    self.titleLabel.text = movie.title;
    self.durationLabel.text = movie.duration;
    [self.shareButton setTitle:movie.share_num forState:UIControlStateNormal];
    self.ratingView.value = movie.rating.integerValue * 0.5;
}


@end
