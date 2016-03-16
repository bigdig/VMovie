//
//  MovieListTableViewController.m
//  VMovie
//
//  Created by wyz on 16/3/15.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "MovieListTableViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "Movie.h"
#import "MovieCell.h"
#import "Banner.h"
#import "MoviePlayerViewController.h"


@interface MovieListTableViewController () <SDCycleScrollViewDelegate>
/**微电影数据 */
@property (nonatomic, strong) NSMutableArray *movieArray;

/**页数 */
@property (nonatomic, assign) NSInteger page;

/**广告数据 */
@property (nonatomic, strong) NSMutableArray *bannerArray;

/**manager */
@property (nonatomic, strong) AFHTTPSessionManager *manager;

/** 广告视图 */
@property (nonatomic, weak) SDCycleScrollView *cycleScrollView;
@end

@implementation MovieListTableViewController

static NSString *movieCellIdentifier = @"movieCellIdentifier";

- (AFHTTPSessionManager *)manager {
    
    if (! _manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (NSMutableArray *)bannerArray {
    
    if (!_bannerArray) {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}

- (NSMutableArray *)movieArray {
    
    if (!_movieArray) {
        _movieArray = [NSMutableArray array];
    }
    return _movieArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerClass:[MovieCell class] forCellReuseIdentifier:movieCellIdentifier];
    self.tableView.rowHeight = ScaleFrom_iPhone5_Desgin(200);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self setupRefresh];
    
    if ([self.vTitle isEqualToString:@"latest"]) {
        [self setupBannerView];
    }
}

- (void) setupBannerView {
    //    http://app.vmoiver.com/apiv3/index/getBanner/?
    UIView *bannerView = [[UIView alloc] init];
    bannerView.width = App_Frame_Width;
    bannerView.height = ScaleFrom_iPhone5_Desgin(200);
    bannerView.backgroundColor = [UIColor cyanColor];
    bannerView.clipsToBounds = YES;
    self.tableView.tableHeaderView = bannerView;
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:bannerView.bounds delegate:self placeholderImage:[UIImage imageNamed:@"common_button_hi"]];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    [bannerView addSubview:cycleScrollView];
    self.cycleScrollView = cycleScrollView;
    
    [self loadBanner];
}

- (void) loadBanner{
    
    [self.manager GET:@"http://app.vmoiver.com/apiv3/index/getBanner/?" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.bannerArray = [Banner mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        NSMutableArray *urlArray = [NSMutableArray array];
        NSMutableArray *titleArray = [NSMutableArray array];
        for (Banner *banner in self.bannerArray) {
            [urlArray addObject:[NSURL URLWithString:banner.image]];
            [titleArray addObject:banner.title];
        }
        self.cycleScrollView.imageURLStringsGroup = urlArray;
        self.cycleScrollView.titlesGroup = titleArray;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void) setupRefresh {
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadLatestMovies)];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreMovies)];
}

- (void) loadLatestMovies {
    
    [SVProgressHUD show];
    [self.tableView.mj_footer endRefreshing];
    [self.manager.dataTasks makeObjectsPerformSelector:@selector(cancel)];
    
    if ([self.vTitle isEqualToString:@"latest"]) {
        [self loadBanner];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"p"] = @1;
    params[@"tab"] = self.vTitle;
    
    [self.manager GET:@"http://app.vmoiver.com/apiv3/post/getPostByTab" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.movieArray = [Movie mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.tableView reloadData];
        self.page = 1;
        [self.tableView.mj_header endRefreshing];
        [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
}

- (void) loadMoreMovies {
    
    [self.tableView.mj_header endRefreshing];
    [self.manager.dataTasks makeObjectsPerformSelector:@selector(cancel)];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSInteger page = self.page + 1;
    params[@"p"] = @(page);
    params[@"tab"] = self.vTitle;
    
    [self.manager GET:@"http://app.vmoiver.com/apiv3/post/getPostByTab" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *dataArray = [Movie mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.movieArray addObjectsFromArray:dataArray];
        [self.tableView reloadData];
        self.page = page;
        [self.tableView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    tableView.mj_footer.hidden = (self.movieArray.count == 0);
    return self.movieArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:movieCellIdentifier];
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieCell *movieCell = (MovieCell *)cell;
    movieCell.movie = self.movieArray[indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MoviePlayerViewController *moviePlayerVc = [[MoviePlayerViewController alloc] init];
    moviePlayerVc.movie = self.movieArray[indexPath.row];
    [self.navigationController pushViewController:moviePlayerVc animated:YES];
}


@end