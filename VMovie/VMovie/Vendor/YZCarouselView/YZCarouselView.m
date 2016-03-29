//
//  YZCarouselView.m
//  循环轮播图
//
//  Created by wyz on 16/3/17.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "YZCarouselView.h"
#import "YZCarouselCell.h"
#import "VMPageControl.h"
#import "UIImageView+WebCache.h"

@interface YZCarouselView() <UICollectionViewDataSource,UICollectionViewDelegate>

/** collectionView */
@property (nonatomic, weak) UICollectionView *collectionView;

/**总的item */
@property (nonatomic, assign) NSInteger totalItems;

/** pageControl */
@property (nonatomic, weak) VMPageControl *pageControl;

/** 定时器 */
@property (nonatomic, weak) NSTimer *timer;

@end

@implementation YZCarouselView

static NSString * const reuseIdentifier = @"CarouselCell";

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupCollectionView];
        
        [self setupPageControl];
  
        [self setupTimer];

    }
    return self;
}

- (void) setupTimer {
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:4.0 target:self selector:@selector(carousel) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}

- (void) setupPageControl {
    
    if (self.pageControl) {
        [self.pageControl removeFromSuperview];
    }
//
//    if (self.imageArray.count <= 1) {
//        return;
//    }
    
    VMPageControl *pageControl = [[VMPageControl alloc] init];
    [self addSubview:pageControl];
    pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:0.8 alpha:0.5];
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl = pageControl;
    
    self.pageControl.width = 150;
    self.pageControl.height = 4;
    self.pageControl.x = (self.width - self.pageControl.width) * 0.5;
    self.pageControl.y = self.height - self.pageControl.height - 8;
}

- (void) setupCollectionView {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = self.bounds.size;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.pagingEnabled = YES;
    collectionView.bounces = NO;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    [collectionView registerClass:[YZCarouselCell class] forCellWithReuseIdentifier:reuseIdentifier];
}

- (void) carousel {
    
    if (self.totalItems == 0) return;
    
    NSInteger currentIndex = self.collectionView.contentOffset.x / self.collectionView.bounds.size.width;
    NSInteger nextIndex = currentIndex + 1;
    if (nextIndex == self.totalItems) {
        nextIndex = self.totalItems * 0.5;
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:nextIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        return;
    }
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:nextIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.collectionView.contentOffset.x == 0 && self.totalItems) {
        NSInteger nextIndex = self.totalItems * 0.5;
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:nextIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
//    self.pageControl.width = 150;
//    self.pageControl.height = 4;
//    self.pageControl.x = (self.width - self.pageControl.width) * 0.5;
//    self.pageControl.y = self.height - self.pageControl.height - 8;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.totalItems;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
   NSInteger itemIndex = indexPath.item % self.imageArray.count;
    YZCarouselCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell.imageView sd_setImageWithURL:self.imageArray[itemIndex] placeholderImage:[UIImage imageNamed:@"common_button_hi"]];
    cell.titleLabel.text = self.titleArray[itemIndex];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger itemIndex = indexPath.item % self.imageArray.count;
    !self.selecItemBlock ? : self.selecItemBlock(itemIndex);
}


- (void)setImageArray:(NSArray *)imageArray {
    
    _imageArray = imageArray;
    self.totalItems = self.imageArray.count * 100;
    
    self.pageControl.numberOfPages = imageArray.count;
    [self.collectionView reloadData];
   
   
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger itemIndex = (scrollView.contentOffset.x + scrollView.bounds.size.width * 0.5) / scrollView.bounds.size.width;
  
    self.pageControl.currentPage= itemIndex % self.imageArray.count;;
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.timer invalidate];
    
    self.timer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [self setupTimer];
}

- (void)dealloc {
    self.collectionView.dataSource = nil;
    self.collectionView.delegate = nil;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        [self.timer invalidate];
        self.timer = nil;
    }
}


@end
