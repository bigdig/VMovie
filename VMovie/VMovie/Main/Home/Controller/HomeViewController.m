//
//  HomeViewController.m
//  VMovie
//
//  Created by wyz on 16/3/12.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "HomeViewController.h"
#import "UIBarButtonItem+Custom.h"
#import "MovieListTableViewController.h"
#import "SearchMovieViewController.h"
#import "VMAnimator.h"
#import "DetailViewController.h"
#import "UIImage+Category.h"
#import "YZTopWindow.h"
#import "VMNavigationController.h"

@interface HomeViewController () <UIScrollViewDelegate>

/** 导航栏标签视图 */
@property (nonatomic, weak) UIView *titleView;
/** 标签指示器 */
@property (nonatomic, weak) UIView *indicatorView;
/** 选中的标签按钮 */
@property (nonatomic, strong) UIButton *selectedButton;
/** 容器视图 */
@property (nonatomic, weak) UIScrollView *contentView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addChildViewControllers];
    
    [self setupNav];
    
    [self setupContentView];
    
    [YZTopWindow show];
}


/** 添加子控制器*/
- (void) addChildViewControllers {
    
    MovieListTableViewController *latestVc = [[MovieListTableViewController alloc] init];
    latestVc.vTitle = @"latest";
    [self addChildViewController:latestVc];
    
    MovieListTableViewController *hotVc = [[MovieListTableViewController alloc] init];
    hotVc.vTitle = @"hot";
    [self addChildViewController:hotVc];
    
}

/**容器视图*/
- (void) setupContentView {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.frame = self.view.bounds;
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.contentSize = CGSizeMake(2 * App_Frame_Width, 0);
    contentView.pagingEnabled = YES;
    contentView.delegate = self;
    contentView.bounces = NO;
    [self.view addSubview:contentView];
    self.contentView = contentView;
    
    [self scrollViewDidEndScrollingAnimation:contentView];
}

- (void) setupNav {
    //标题
    [self setupTitleView];
    
    //两侧按钮
    UIBarButtonItem *detailItem = [UIBarButtonItem itemWithImage:@"img_icon_menu" HighImage:@"img_icon_menu" target:self action:@selector(detailItemClick)];
    self.navigationItem.leftBarButtonItem = detailItem;
    
    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithImage:@"img_icon_search" HighImage:@"img_icon_search" target:self action:@selector(searchItemClick)];
    self.navigationItem.rightBarButtonItem = searchItem;
}

- (void) setupTitleView {
    
    UIView *titleView = [[UIView alloc] init];
    titleView.width = App_Frame_Width;
    titleView.height = 35;
    titleView.width = ScaleFrom_iPhone5_Desgin(150);
    titleView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleView];
    self.titleView = titleView;
    self.navigationItem.titleView = titleView;
    
    NSArray *titles = @[@"最新",@"热门"];
    CGFloat width = titleView.width / 2;
    CGFloat height = titleView.height;
    
    for (NSInteger i = 0; i < titles.count; i ++) {
        
        UIButton *button = [[UIButton alloc] init];
        button.width = width;
        button.height = height;
        button.x = width * i;
        [titleView addSubview:button];
        
        button.tag = i;
        [button setTitle:titles[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [button setTitleColor:[UIColor colorWithWhite:0.7 alpha:1.0] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [button  addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            self.selectedButton = button;
            button.enabled = NO;
            self.selectedButton.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }
    }
    
    //指示器
    UIView *indicatorView = [[UIView alloc] init];
    UIButton *firstButton = titleView.subviews[0];
    [firstButton.titleLabel sizeToFit];
    indicatorView.width =  1.5 * firstButton.titleLabel.width;
    indicatorView.centerX = firstButton.centerX;
    indicatorView.height = 2;
    indicatorView.y = titleView.height - indicatorView.height;
    indicatorView.backgroundColor = [UIColor whiteColor];
    self.indicatorView = indicatorView;
    [titleView addSubview:indicatorView];
}

- (void) titleButtonClick:(UIButton *) button {
    
    //使用enable 防止重复点击与加载
    self.selectedButton.enabled = YES;
    if (self.selectedButton != button) {
        self.selectedButton.transform = CGAffineTransformIdentity;
    }
    button.enabled = NO;
    self.selectedButton = button;
    
    //动画
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.width = 1.5 * button.titleLabel.width;
        self.indicatorView.centerX = button.centerX;
        self.selectedButton.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }];
    
    CGFloat offsetX = button.tag * App_Frame_Width;
    [self.contentView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

- (void) detailItemClick {
    DetailViewController *detailVc = [[DetailViewController alloc] init];
    VMNavigationController *vmNav = [[VMNavigationController alloc] initWithRootViewController:detailVc];
    detailVc.bgImage = [UIImage imageWithCaptureOfView:self.view];
    detailVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vmNav animated:YES completion:nil];
}

- (void) searchItemClick {
    [SVProgressHUD dismiss];
    SearchMovieViewController *searchMovieVc = [[SearchMovieViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchMovieVc];

//    nav.transitioningDelegate = [VMAnimator sharedAnimator];
//    nav.modalPresentationStyle = UIModalPresentationCustom;
    nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nav animated:YES completion:nil];
//    [self.navigationController pushViewController:searchMovieVc animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    
    UIViewController *viewController = self.childViewControllers[index];
    viewController.view.x = index * scrollView.width;
    viewController.view.y = 0;
    viewController.view.height = scrollView.height - 64;
    [self.contentView addSubview:viewController.view];
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
