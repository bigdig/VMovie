//
//  SearchBar.m
//  VMovie
//
//  Created by wyz on 16/3/15.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "SearchBar.h"

@implementation SearchBar

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.frame = frame;
        
//        self.borderStyle = UITextBorderStyleRoundedRect;
        self.returnKeyType = UIReturnKeySearch;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        self.font = [UIFont systemFontOfSize:15.0];
        self.placeholder = @"请输入要搜索的内容";
        
        //设置背景图片
        UIImage *image = [UIImage imageNamed:@"searchbar_textfield_background"];
        UIImage *resizeImage = [image stretchableImageWithLeftCapWidth:image.size.width*0.5 topCapHeight:image.size.height*0.5];
        [self setBackground:resizeImage];
        
        //设置搜索图标
        
        UIImage *searchImage = [UIImage imageNamed:@"search_search_bg"];
        UIImageView *imageView= [[UIImageView alloc] init];
        imageView.image = searchImage;
        
        CGRect frame = imageView.frame;
        frame.size.width = 40;
        frame.size.height = 30;
        imageView.frame = frame;
        
        imageView.contentMode = UIViewContentModeCenter;
        self.leftView = imageView;
        self.leftViewMode = UITextFieldViewModeAlways;
        
    }
    
    return self;
}

+ (instancetype) searchBar {
    
    return [[self alloc] init];
}

- (BOOL)becomeFirstResponder {
    
    !self.showHistoryBlock? : self.showHistoryBlock();
    return [super becomeFirstResponder];
}

@end
