//
//  VMPageControl.m
//  循环轮播图
//
//  Created by wyz on 16/3/17.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "VMPageControl.h"

@implementation VMPageControl

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _pageIndicatorTintColor = [UIColor grayColor];
        _currentPageIndicatorTintColor = [UIColor blackColor];
        _pageSpace = 6;//默认的点的空隙
        _currentPage = 0;
    }
    return self;
}

#pragma mark 重写pageNumber的setter方法
-(void)setNumberOfPages:(NSInteger)numberOfPages
{
    if (_numberOfPages != numberOfPages) {
        _numberOfPages = numberOfPages;
        
        for (UIView *subView in self.subviews){
            [subView removeFromSuperview];
        }

        //1.获取当前对象的宽高
//        CGFloat myWidth = self.frame.size.width;
        CGFloat myHeight = self.frame.size.height;
//        CGFloat pointWidth = ( myWidth -  (_numberOfPages - 1) * _pageSpace) / _numberOfPages;
        CGFloat pointWidth = 20;
        //2.循环创建图片,添加到self上
        for (NSInteger i = 0; i < _numberOfPages; i++) {
            //每个小点
            UIView *pointView = [[UIImageView alloc]initWithFrame:CGRectMake((_pageSpace + pointWidth) * i +( self.width - ((pointWidth + _pageSpace) * _numberOfPages - _pageSpace)) * 0.5, 0, pointWidth,myHeight)];
            pointView.layer.cornerRadius = myHeight * 0.5;
            pointView.backgroundColor = _pageIndicatorTintColor;
            [self addSubview:pointView];
        }
        //设置被选中的颜色和被选中的点
        UIView *pointView = [self.subviews objectAtIndex:_currentPage];
        pointView.backgroundColor = _currentPageIndicatorTintColor;
    }
}

#pragma mark 设置背景颜色方法
-(void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
{
    _pageIndicatorTintColor = pageIndicatorTintColor;
    //子视图不空的情况下遍历修改每张图的颜色
    if (self.subviews.count != 0) {
        for (UIView *pointView in self.subviews) {
            pointView.backgroundColor = _pageIndicatorTintColor;
        }
        //被选中的颜色,防止被覆盖
        UIView *pointView = [self.subviews objectAtIndex:_currentPage];
        pointView.backgroundColor = _currentPageIndicatorTintColor;
    }
}

#pragma mark 被选中的颜色
-(void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
{
    if (_currentPageIndicatorTintColor != currentPageIndicatorTintColor) {
        _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
        //有图的情况下
        if (self.subviews.count) {
            //修改被选中的那张图片的颜色
            UIView *pointView = [self.subviews objectAtIndex:_currentPage];
            pointView.backgroundColor = _currentPageIndicatorTintColor;
        }
    }
}

#pragma mark 设置当前被选中的下标
-(void)setCurrentPage:(NSInteger)currentPage
{
    if (_currentPage != currentPage) {
        
        _currentPage = currentPage;
        //判断当前图片是否已经存在(即numberOfPages是否为0)
        if (self.subviews.count) {
            //改变没有被选中的颜色
            for (UIView *pointView in self.subviews) {
                pointView.backgroundColor = _pageIndicatorTintColor;
            }
            UIView *pointView = [self.subviews objectAtIndex:_currentPage];
            pointView.backgroundColor = _currentPageIndicatorTintColor;
        }
    }
}
@end
