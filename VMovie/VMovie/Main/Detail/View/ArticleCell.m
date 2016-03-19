//
//  ArticleCell.m
//  VMovie
//
//  Created by wyz on 16/3/18.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "ArticleCell.h"
#import "UIImageView+WebCache.h"
#import "Movie.h"

@interface ArticleCell()

/** 图片 */
@property (nonatomic, weak) UIImageView *articleView;

/** 标题 */
@property (nonatomic, weak) UILabel *titleLabel;

/** 分享 */
@property (nonatomic, weak) UIButton *shareButton;

/** 喜欢 */
@property (nonatomic, weak) UIButton *likeButton;

@end

@implementation ArticleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIImageView *articleView = [[UIImageView alloc] init];
        articleView.contentMode = UIViewContentModeScaleAspectFill;
        articleView.clipsToBounds = YES;
        [self.contentView addSubview:articleView];
        self.articleView = articleView;
        [articleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.contentView).offset(10);
            make.bottom.equalTo(self.contentView).offset(-10);
            make.width.equalTo(@(App_Frame_Width /3));
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.numberOfLines = 2;
        titleLabel.font = [UIFont systemFontOfSize:ScaleFrom_iPhone5_Desgin(14.0f)];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(articleView.mas_right).offset(10);
            make.top.equalTo(articleView).offset(ScaleFrom_iPhone5_Desgin(14));
            make.right.equalTo(self.contentView).offset(-10);
        }];
        
        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareButton setImage:[UIImage imageNamed:@"backstage_home_share"] forState:UIControlStateNormal];
        shareButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [shareButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        shareButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [self.contentView addSubview:shareButton];
        self.shareButton = shareButton;
        [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel);
            make.bottom.equalTo(articleView.mas_bottom).offset(-ScaleFrom_iPhone5_Desgin(10));
            make.width.equalTo(@(ScaleFrom_iPhone5_Desgin(60)));
            make.height.equalTo(@(ScaleFrom_iPhone5_Desgin(20)));
        }];
        
        UIButton *likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [likeButton setImage:[UIImage imageNamed:@"backstage_home_like"] forState:UIControlStateNormal];
        likeButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [likeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
         likeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [self.contentView addSubview:likeButton];
        self.likeButton = likeButton;
        [likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(shareButton.mas_right).offset(15);
            make.bottom.equalTo(articleView.mas_bottom).offset(-ScaleFrom_iPhone5_Desgin(10));
            make.width.equalTo(@(ScaleFrom_iPhone5_Desgin(60)));
            make.height.equalTo(@(ScaleFrom_iPhone5_Desgin(20)));
        }];
        
    }
    return  self;
}

- (void)setMovie:(Movie *)movie {
    _movie = movie;
    
    [self.articleView sd_setImageWithURL:[NSURL URLWithString:movie.image] placeholderImage:[UIImage imageNamed:@"common_button_hi"]];
    self.titleLabel.text = movie.title;
    [self.shareButton setTitle:movie.share_num forState:UIControlStateNormal];
    [self.likeButton setTitle:movie.like_num forState:UIControlStateNormal];
}
@end
