//
//  BackStageViewController.m
//  VMovie
//
//  Created by wyz on 16/3/18.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "BackStageViewController.h"
#import "UIBarButtonItem+Custom.h"
#import "SearchMovieViewController.h"
#import "ArticlesTableViewController.h"

@interface BackStageViewController ()<UIScrollViewDelegate>

/** 标签栏 */
@property (nonatomic, weak) UIScrollView *titleView;

/** 指示器 */
@property (nonatomic, weak) UIView *indicatorView;

/** 选中的按钮 */
@property (nonatomic, weak) UIButton *selectedButton;

/** 容器视图 */
@property (nonatomic, weak) UIScrollView *contentView;

@end

@implementation BackStageViewController

static CGFloat const titleViewHeight = 35;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self addChildViewControllers];
    
    [self setupContentView];
    
    [self setupTitleView];
    
}

/** 添加子控制器*/
- (void) addChildViewControllers {
    
    ArticlesTableViewController *allVc = [[ArticlesTableViewController alloc] init];
    allVc.title = @"全部";
    allVc.type = BackStageTypeAll;
    [self addChildViewController:allVc];
    
    ArticlesTableViewController *studyVc = [[ArticlesTableViewController alloc] init];
    studyVc.title = @"电影自习室";
    studyVc.type = BackStageTypeStudy;
    [self addChildViewController:studyVc];
    
    ArticlesTableViewController *loungeVc = [[ArticlesTableViewController alloc] init];
    loungeVc.title = @"电影会客厅";
    loungeVc.type = BackStageTypeLounge;
    [self addChildViewController:loungeVc];
    
    ArticlesTableViewController *shotVc = [[ArticlesTableViewController alloc] init];
    shotVc.title = @"拍摄";
    shotVc.type = BackStageTypeShot;
    [self addChildViewController:shotVc];
    
    ArticlesTableViewController *overView = [[ArticlesTableViewController alloc] init];
    overView.title = @"综述";
    overView.type = BackStageTypeOverView;
    [self addChildViewController:overView];
    
    ArticlesTableViewController *laterStageVc = [[ArticlesTableViewController alloc] init];
    laterStageVc.title = @"后期";
    laterStageVc.type = BackStageTypeLaterStage;
    [self addChildViewController:laterStageVc];
    
    ArticlesTableViewController *equipmentVc = [[ArticlesTableViewController alloc] init];
    equipmentVc.title = @"器材";
    equipmentVc.type = BackStageTypeEquipment;
    [self addChildViewController:equipmentVc];
    
}

/**容器视图*/
- (void) setupContentView {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.frame = CGRectMake(0, titleViewHeight, self.view.width, self.view.height - titleViewHeight - 64);
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.contentSize = CGSizeMake(self.childViewControllers.count * self.view.bounds.size.width, 0);
    contentView.pagingEnabled = YES;
    contentView.delegate = self;
    contentView.showsVerticalScrollIndicator = NO;
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.bounces = NO;
    [self.view addSubview:contentView];
    self.contentView = contentView;
    
    [self scrollViewDidEndScrollingAnimation:contentView];
}
     
- (void) setupTitleView {
    
     UIScrollView *titleView = [[UIScrollView alloc] init];
    titleView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    titleView.showsHorizontalScrollIndicator = NO;
    titleView.showsVerticalScrollIndicator = NO;
    titleView.bounces = NO;
     [self.view addSubview:titleView];
     self.titleView = titleView;
    titleView.x = 0;
    titleView.y = 0;
    titleView.width = self.view.bounds.size.width;
    titleView.height = titleViewHeight;
    
    CGFloat maxbuttonX = 0;
     
     for (NSInteger i = 0; i < self.childViewControllers.count; i ++) {
         
         UIButton *button = [[UIButton alloc] init];
      
         [titleView addSubview:button];
         NSString *title = self.childViewControllers[i].title;
         button.tag = i;
         [button setTitle:title forState:UIControlStateNormal];
         button.titleLabel.font = [UIFont systemFontOfSize:13.0];
         [button setTitleColor:[UIColor colorWithWhite:0.4 alpha:1.0] forState:UIControlStateNormal];
         [button setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
         [button  addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
         
         [button sizeToFit];
         button.width = button.width * 1.75;
         button.x = maxbuttonX;
         maxbuttonX = button.x + button.size.width;
         button.y = 4;
         
         if (i == 0) {
             self.selectedButton = button;
             button.enabled = NO;
         }
     }
    
    for (NSInteger i = 0; i < self.childViewControllers.count; i++) {
        UIView *seperatorView = [[UIView alloc] init];
        [titleView addSubview:seperatorView];
        UIButton *button = titleView.subviews[i];
        seperatorView.backgroundColor = [UIColor lightGrayColor];
        seperatorView.width = 1;
        seperatorView.height = 10;
        seperatorView.y = 14;
        seperatorView.x = CGRectGetMaxX(button.frame);
    }
    
    titleView.contentSize = CGSizeMake(maxbuttonX, 0);
     
     //指示器
     UIView *indicatorView = [[UIView alloc] init];
     UIButton *firstButton = titleView.subviews[0];
     [firstButton.titleLabel sizeToFit];
     indicatorView.width =  firstButton.width;
     indicatorView.centerX = firstButton.centerX;
     indicatorView.height = 2;
     indicatorView.y = titleView.height - indicatorView.height;
     indicatorView.backgroundColor = [UIColor blackColor];
     self.indicatorView = indicatorView;
     [titleView addSubview:indicatorView];
}


- (void) setupNav {
    self.navigationItem.title = @"幕后文章";
    self.view.backgroundColor = RANDOM_UICOLOR;
    //两侧按钮
    UIBarButtonItem *detailItem = [UIBarButtonItem itemWithImage:@"img_icon_menu" HighImage:@"img_icon_menu" target:self action:@selector(detailItemClick)];
    self.navigationItem.leftBarButtonItem = detailItem;
    
    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithImage:@"img_icon_search" HighImage:@"img_icon_search" target:self action:@selector(searchItemClick)];
    self.navigationItem.rightBarButtonItem = searchItem;
}

- (void) detailItemClick {
    [SVProgressHUD dismiss];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) searchItemClick {
    [SVProgressHUD dismiss];
    SearchMovieViewController *searchMovieVc = [[SearchMovieViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchMovieVc];
    nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void) titleButtonClick: (UIButton *) button {
    //使用enable 防止重复点击与加载
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;
    
    CGFloat offsetX = button.tag * self.contentView.width;
    [self.contentView setContentOffset:CGPointMake(offsetX, 0) animated:NO];
    [self scrollViewDidEndScrollingAnimation:self.contentView];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.indicatorView.width = button.width ;
        self.indicatorView.centerX = button.centerX;
        
    }];

}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    CGFloat height = scrollView.frame.size.height;
    CGFloat width = scrollView.frame.size.width;
    CGFloat offsetX = scrollView.contentOffset.x;
    
     NSInteger index = scrollView.contentOffset.x / width;
    
    // 让对应的顶部标题居中显示
    UIButton  *titleButton = self.titleView.subviews[index];
    CGPoint titleOffset = self.titleView.contentOffset;
    titleOffset.x = titleButton.center.x - width * 0.5;
    // 左边超出处理
    if (titleOffset.x < 0) titleOffset.x = 0;
    // 右边超出处理
    CGFloat maxTitleOffsetX = self.titleView.contentSize.width - width;
    if (titleOffset.x > maxTitleOffsetX) titleOffset.x = maxTitleOffsetX;
    
    [self.titleView setContentOffset:titleOffset animated:YES];
    
    // 取出需要显示的控制器
    UIViewController *willShowVc = self.childViewControllers[index];
    
    // 如果当前位置的位置已经显示过了，就直接返回
    if ([willShowVc isViewLoaded]) return;
    
    // 添加控制器的view到contentScrollView中;
    willShowVc.view.frame = CGRectMake(offsetX, 0, width, height);
    [scrollView addSubview:willShowVc.view];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    //点击按钮
    
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    [self titleButtonClick:self.titleView.subviews[index]];
    
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
@end
