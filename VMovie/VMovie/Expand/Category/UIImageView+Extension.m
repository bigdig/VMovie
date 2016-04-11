//
//  UIImageView+Extension.m
//  VMovie
//
//  Created by wyz on 16/4/10.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "UIImageView+Extension.h"
#import "UIImage+Category.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (Extension)
-(void)setHeaderImage:(NSString *)imageURL {
    
    UIImage *placeholder = [[UIImage imageNamed:@"menu_avatar_default"] circleImage];
    
    [self sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.image = image ? [image circleImage] : placeholder;
    }];
}
@end
