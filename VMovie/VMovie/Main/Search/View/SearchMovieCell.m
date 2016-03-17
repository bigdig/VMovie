//
//  SearchMovieCell.m
//  VMovie
//
//  Created by wyz on 16/3/15.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "SearchMovieCell.h"
#import <HCSStarRatingView/HCSStarRatingView.h>
#import "UIImageView+WebCache.h"
#import "Movie.h"

@interface SearchMovieCell()
/** 背景图片 */
@property (nonatomic, weak) UIImageView *pictureView;
/** 标题 */
@property (nonatomic, weak) UILabel *titleLabel;
/** 时长 */
@property (nonatomic, weak) UILabel *durationLabel;
/** 阴影 */
@property (nonatomic, weak) UIImageView *shadowView;
/** 分享 */
@property (nonatomic, weak) UIButton *shareButton;
/** 评分视图 */
@property (nonatomic, weak) HCSStarRatingView *ratingView;
/** 评分标签 */
@property (nonatomic, weak) UILabel *ratingLabel;

@end
@implementation SearchMovieCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIImageView *pictureView = [[UIImageView alloc] init];
        pictureView.contentMode = UIViewContentModeScaleAspectFill;
        pictureView.clipsToBounds = YES;
        [self.contentView addSubview:pictureView];
        self.pictureView = pictureView;
        [pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.top.equalTo(self.contentView).offset(5);
            make.bottom.equalTo(self.contentView).offset(-5);
            make.width.equalTo(@(ScaleFrom_iPhone5_Desgin(App_Frame_Width * 0.35)));
        }];
        
        UIImageView *shadowView = [[UIImageView alloc] init];
        shadowView.contentMode = UIViewContentModeScaleAspectFill;
        shadowView.clipsToBounds = YES;
        shadowView.image = [UIImage imageNamed:@"search_shadow_bg"];
        [self.contentView addSubview:shadowView];
        self.shadowView = shadowView;
        [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(pictureView);
        }];
        
        UILabel *durationLabel = [[UILabel alloc] init];
        durationLabel.textColor = [UIColor whiteColor];
        durationLabel.font = [UIFont systemFontOfSize:12.0f];
        [self.contentView addSubview:durationLabel];
        self.durationLabel = durationLabel;
        [durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(pictureView).offset(-5);
            make.right.equalTo(pictureView).offset(-5);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:14.0f];
        titleLabel.numberOfLines = 0;
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(pictureView.mas_right).offset(ScaleFrom_iPhone5_Desgin(10));
            make.right.equalTo(self.contentView).offset(-10);
            make.top.equalTo(pictureView).offset(ScaleFrom_iPhone5_Desgin(10));
        }];
        
        HCSStarRatingView *ratingView = [[HCSStarRatingView alloc] init];
        ratingView.maximumValue = 5;
        ratingView.minimumValue = 0;
        ratingView.value = 0;
        ratingView.allowsHalfStars = YES;
        ratingView.emptyStarImage = [UIImage imageNamed:@"star_hui"];
        ratingView.filledStarImage = [UIImage imageNamed:@"foregroundStar"];
        ratingView.backgroundColor = [UIColor clearColor];
        ratingView.userInteractionEnabled = NO;
        [self.contentView addSubview:ratingView];
        self.ratingView = ratingView;
        [ratingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(pictureView.mas_right).offset(ScaleFrom_iPhone5_Desgin(10));
            make.bottom.equalTo(pictureView).offset(- ScaleFrom_iPhone5_Desgin(5));
            make.height.equalTo(@(ScaleFrom_iPhone5_Desgin(25)));
            make.width.equalTo(@(ScaleFrom_iPhone5_Desgin(70)));
        }];
        
        UILabel *ratingLabel = [[UILabel alloc] init];
        ratingLabel.textColor = [UIColor grayColor];
        ratingLabel.font = [UIFont systemFontOfSize:12.0f];
        [self.contentView addSubview:ratingLabel];
        self.ratingLabel = ratingLabel;
        [ratingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ratingView.mas_right).offset(5);
            make.centerY.equalTo(ratingView);
        }];
        
        UIButton *shareButton= [[UIButton alloc] init];
        [shareButton setImage:[UIImage imageNamed:@"search_share_bg"] forState:UIControlStateDisabled];
        shareButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [shareButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        shareButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        shareButton.enabled = NO;
        [self.contentView addSubview:shareButton];
        self.shareButton = shareButton;
        [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.height.equalTo(ratingView);
            make.left.equalTo(ratingLabel.mas_right);
            make.width.equalTo(@(ScaleFrom_iPhone5_Desgin(50)));
        }];
        
        UIImageView *separatorView = [[UIImageView alloc] init];
        separatorView.image = [UIImage imageNamed:@"search_cell_bottom"];
        [self.contentView addSubview:separatorView];
        [separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.height.equalTo(@1);
        }];
        
    }
    return self;
}

- (void)setMovie:(Movie *)movie {
    _movie = movie;
    
    [self.pictureView sd_setImageWithURL:[NSURL URLWithString:movie.image] placeholderImage:[UIImage imageNamed:@"common_button_hi"]];
    self.titleLabel.text = movie.title;
    self.durationLabel.text = movie.duration;
    [self.shareButton setTitle:movie.share_num forState:UIControlStateNormal];
    
    if (movie.rating.integerValue == 0) {
        self.ratingView.hidden = YES;
        self.ratingLabel.hidden = YES;
    } else {
    self.ratingView.value = movie.rating.integerValue * 0.5;
    self.ratingLabel.text = [NSString stringWithFormat:@"%@分",movie.rating];
        self.ratingLabel.hidden = NO;
        self.ratingView.hidden = NO;
    }
}

@end
