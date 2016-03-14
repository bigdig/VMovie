//
//  HomeViewController.m
//  VMovie
//
//  Created by wyz on 16/3/12.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "HomeViewController.h"
#import "UIBarButtonItem+Custom.h"
#import "LatestTableViewController.h"
#import "HotTableViewController.h"

@interface HomeViewController () <UIScrollViewDelegate>

/** 导航栏标签视图 */
@property (nonatomic, weak) UIView *titleView;
/** 标签指示器 */
@property (nonatomic, weak) UIView *indicatiorView;
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
}

/** 添加子控制器*/
- (void) addChildViewControllers {
    
    LatestTableViewController *latestVc = [[LatestTableViewController alloc] init];
    [self addChildViewController:latestVc];
    
    HotTableViewController *hotVc = [[HotTableViewController alloc] init];
    [self addChildViewController:hotVc];
}

/**容器视图*/
- (void) setupContentView {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.frame = self.view.bounds;
    contentView.backgroundColor = [UIColor yellowColor];
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
        [button setTitleColor:[UIColor colorWithWhite:0.6 alpha:1.0] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [button  addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            self.selectedButton = button;
            button.enabled = NO;
            button.titleLabel.font = [UIFont systemFontOfSize:20.0f];
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
    self.indicatiorView = indicatorView;
    [titleView addSubview:indicatorView];
}

- (void) titleButtonClick:(UIButton *) button {
    
    //使用enable 防止重复点击与加载
    self.selectedButton.enabled = YES;
    self.selectedButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    button.enabled = NO;
    button.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    [button.titleLabel sizeToFit];
    self.selectedButton = button;
    
    //动画
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatiorView.width = 1.5 * button.titleLabel.width;
        self.indicatiorView.centerX = button.centerX;
    }];
    
    CGFloat offsetX = button.tag * App_Frame_Width;
    [self.contentView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

- (void) detailItemClick {
    NSLog(@"%s",__func__);
}

- (void) searchItemClick {
    NSLog(@"%s",__func__);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    
    UIViewController *viewController = self.childViewControllers[index];
    viewController.view.x = index * scrollView.width;
    viewController.view.y = 0;
    viewController.view.height = scrollView.height;
    
    [self.contentView addSubview:viewController.view];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    //点击按钮
    
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    [self titleButtonClick:self.titleView.subviews[index]];
    
}



@end
