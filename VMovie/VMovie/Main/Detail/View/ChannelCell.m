//
//  ChannelCell.m
//  VMovie
//
//  Created by wyz on 16/3/16.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "ChannelCell.h"
#import "Channel.h"
#import "UIImageView+WebCache.h"

@interface ChannelCell()

/**icon */
@property (nonatomic, weak) UIImageView *bgView;
/**名字 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 别名 */
@property (nonatomic, weak) UILabel *aliasLabel;

/** 阴影 */
@property (nonatomic, weak) UIView *shadowView;

@end

@implementation ChannelCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {

        UIImageView *bgView = [[UIImageView alloc] init];
        bgView.backgroundColor = RANDOM_UICOLOR;
        bgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:bgView];
        self.bgView = bgView;
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        UIView *shadowView = [[UIView alloc] init];
        shadowView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
        [self.contentView addSubview:shadowView];
        self.shadowView = shadowView;
        [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(bgView);
        }];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
        
        UILabel *aliasLabel = [[UILabel alloc] init];
        aliasLabel.textColor = [UIColor whiteColor];
        aliasLabel.font = [UIFont systemFontOfSize:13.0f];
        [self.contentView addSubview:aliasLabel];
        self.aliasLabel = aliasLabel;
        [aliasLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(nameLabel);
            make.top.equalTo(nameLabel.mas_bottom);
        }];
    }
    
    return self;
}

- (void)setChannel:(Channel *)channel {
    _channel = channel;
    
    [self.bgView sd_setImageWithURL:[NSURL URLWithString:channel.icon] placeholderImage:[UIImage imageNamed:@"common_button_hi"]];
    
    self.nameLabel.text = [NSString stringWithFormat:@"#%@#",channel.catename];
    
    self.aliasLabel.text = channel.alias;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    self.shadowView.hidden = selected;
}

@end
