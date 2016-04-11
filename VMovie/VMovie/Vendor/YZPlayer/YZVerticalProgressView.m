//
//  YZVerticalProgressView.m
//  YZVerticalProgressView
//
//  Created by wyz on 16/3/31.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "YZVerticalProgressView.h"
#import "UIView+Frame.h"

@interface YZVerticalProgressView()

/**顶部图片 */
@property (nonatomic, strong) UIImageView *topImageView;
/**底部图片 */
@property (nonatomic, strong) UIImageView *bottomImageView;

@end

@implementation YZVerticalProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
        
        if (!_topImageView) {
            _topImageView = [UIImageView new];
            _topImageView.contentMode = UIViewContentModeScaleAspectFill;
            [self addSubview:_topImageView];
        }
        
        if (!_bottomImageView) {
            _bottomImageView = [UIImageView new];
            _bottomImageView.contentMode = UIViewContentModeScaleAspectFill;
            [self addSubview:_bottomImageView];
        }
        
    }
    return self;
}

- (void)setProgress:(CGFloat)progress {
    
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)setTopImage:(UIImage *)topImage bottomImage:(UIImage *)bottomImage {
    self.topImageView.image = topImage;
    self.bottomImageView.image = bottomImage;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.topImageView.centerX = self.width * 0.5;
    self.topImageView.y = 0;
    self.topImageView.width = self.topImageView.image.size.width;
    self.topImageView.height = self.topImageView.image.size.height;
    
    self.bottomImageView.centerX = self.width * 0.5;
    self.bottomImageView.width = self.bottomImageView.image.size.width;
    self.bottomImageView.height = self.bottomImageView.image.size.height;
    self.bottomImageView.y = self.height - self.bottomImageView.height;
    
}

- (void)drawRect:(CGRect)rect {
    
    CGFloat centerX = self.width * 0.5;
    CGFloat topY = CGRectGetMaxY(self.topImageView.frame);
    CGFloat maxY = CGRectGetMinY(self.bottomImageView.frame);
    CGFloat height = self.height - self.topImageView.height - self.bottomImageView.height;
    CGFloat width = 4;
    
    CGPoint startPoint = CGPointMake(centerX, maxY);
    CGPoint endPoint = CGPointMake(centerX, maxY - height * self.progress);
    
    CGContextRef ctx1 = UIGraphicsGetCurrentContext();
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 moveToPoint:startPoint];
    [path1 addLineToPoint:CGPointMake(centerX, topY)];
    CGContextAddPath(ctx1, path1.CGPath);
    CGContextSetLineWidth(ctx1, width);
    CGContextSetLineCap(ctx1, kCGLineCapRound);
    [[UIColor colorWithWhite:0.5 alpha:0.5] set];
    CGContextStrokePath(ctx1);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    CGContextAddPath(ctx, path.CGPath);
    CGContextSetLineWidth(ctx, width);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    [[UIColor whiteColor] set];
    CGContextStrokePath(ctx);
}

@end
