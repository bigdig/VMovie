//
//  MovieListTableViewController.m
//  VMovie
//
//  Created by wyz on 16/3/15.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "MovieListTableViewController.h"
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>
#import "Movie.h"
#import "MovieCell.h"
#import "Banner.h"
#import "MoviePlayerViewController.h"
#import "YZCarouselView.h"
#import "BannerADViewController.h"


@interface MovieListTableViewController ()
/**微电影数据 */
@property (nonatomic, strong) NSMutableArray *movieArray;

/**页数 */
@property (nonatomic, assign) NSInteger page;

/**广告数据 */
@property (nonatomic, strong) NSMutableArray *bannerArray;


/** 广告视图 */
@property (nonatomic, weak) YZCarouselView *carouselView;
@end

@implementation MovieListTableViewController

static NSString * const movieCellIdentifier = @"movieCellIdentifier";

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
    
    if ([self.vTitle isEqualToString:@"latest"]) {
        [self setupBannerView];
    }
    
    [self setupRefresh];
}

//设置轮播图
- (void) setupBannerView {
    //    http://app.vmoiver.com/apiv3/index/getBanner/?
    UIView *bannerView = [[UIView alloc] init];
    bannerView.width = App_Frame_Width;
    bannerView.height = ScaleFrom_iPhone5_Desgin(200);
    bannerView.backgroundColor = [UIColor whiteColor];
    bannerView.clipsToBounds = YES;
    self.tableView.tableHeaderView = bannerView;
    YZCarouselView *carouselView = [[YZCarouselView alloc] initWithFrame:bannerView.bounds];
    carouselView.backgroundColor = [UIColor whiteColor];
    [bannerView addSubview:carouselView];
    self.carouselView = carouselView;
    
    @weakify(self);
    carouselView.selecItemBlock = ^(NSInteger index) {
        @strongify(self);
        Banner *banner = self.bannerArray[index];
//        NSLog(@"%ld--%@",banner.bannerType,banner.bannerURL);
        switch (banner.bannerType) {
            case BannerTypeMovie: {
                Movie *movie = [[Movie alloc] init];
                movie.postid = banner.bannerURL;
                MoviePlayerViewController *moviePlayerVc = [[MoviePlayerViewController alloc] init];
                moviePlayerVc.movie = movie;
                [self.navigationController pushViewController:moviePlayerVc animated:YES];
            }
                break;
            case BannerTypeAD:{
                
                BannerADViewController *BannerADVc = [[BannerADViewController alloc] init];
                BannerADVc.banner = banner;
                [self.navigationController pushViewController:BannerADVc animated:YES];
            }
                break;
            default:
                break;
        }
    };
}

//网络请求加载banner
- (void) loadBanner{
    
    [YZNetworking GET:@"http://app.vmoiver.com/apiv3/index/getBanner/?" parameters:nil success:^(id  _Nullable responseObject) {
        self.bannerArray = [Banner mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        NSMutableArray *urlArray = [NSMutableArray array];
        NSMutableArray *titleArray = [NSMutableArray array];
        
        for (Banner *banner in self.bannerArray) {
            [urlArray addObject:[NSURL URLWithString:banner.image]];
            [titleArray addObject:banner.title];
        }
        self.carouselView.imageArray = urlArray;
        self.carouselView.titleArray = titleArray;
    
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

//设置上下拉刷新
- (void) setupRefresh {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadLatestMovies)];
    [header setTitle:@"下拉刷新..." forState:MJRefreshStateIdle];
    [header setTitle:@"释放立即刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"刷新中..." forState:MJRefreshStateRefreshing];
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    header.stateLabel.shadowColor = [UIColor blackColor];
    header.stateLabel.shadowOffset = CGSizeMake(0.1, 0.1);
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12];
    
    // 设置颜色
    header.stateLabel.textColor = RGBCOLOR(125, 136, 157);
    header.lastUpdatedTimeLabel.textColor = RGBCOLOR(125, 136, 157);
    
    self.tableView.mj_header = header;
    [self loadLatestMovies];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreMovies)];
}

//加载最新数据
- (void) loadLatestMovies {
 
    [self.view beginLoading];
    [self.tableView.mj_footer endRefreshing];
    
    if ([self.vTitle isEqualToString:@"latest"]) {
        [self loadBanner];
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"p"] = @1;
    params[@"tab"] = self.vTitle;
    
    [YZNetworking GET:@"http://app.vmoiver.com/apiv3/post/getPostByTab" parameters:params success:^(id  _Nullable responseObject) {
        self.movieArray = [Movie mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.tableView reloadData];
        self.page = 1;
        [self.tableView.mj_header endRefreshing];
        [self.view endLoading];

        @weakify(self);
        [self.view configWithData:self.movieArray.count > 0 reloadDataBlock:^(id sender) {
            @strongify(self);
            [self loadLatestMovies];
        }];
    } failure:^(NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [self.view endLoading];
        @weakify(self);
        [self.view configWithData:self.movieArray.count > 0 reloadDataBlock:^(id sender) {
            @strongify(self);
            [self loadLatestMovies];
        }];
    }];
    

}

//上拉加载更多数据
- (void) loadMoreMovies {
    
    [self.tableView.mj_header endRefreshing];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSInteger page = self.page + 1;
    params[@"p"] = @(page);
    params[@"tab"] = self.vTitle;
    
    [YZNetworking GET:@"http://app.vmoiver.com/apiv3/post/getPostByTab" parameters:params success:^(id  _Nullable responseObject) {
        NSArray *dataArray = [Movie mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.movieArray addObjectsFromArray:dataArray];
        [self.tableView reloadData];
        self.page = page;
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError * _Nonnull error) {
        [self.tableView.mj_footer endRefreshing];
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

//在willDisplayCell中更新数据
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieCell *movieCell = (MovieCell *)cell;
    movieCell.movie = self.movieArray[indexPath.row];
}

//跳转到播放界面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MoviePlayerViewController *moviePlayerVc = [[MoviePlayerViewController alloc] init];
    moviePlayerVc.movie = self.movieArray[indexPath.row];
    [self.navigationController pushViewController:moviePlayerVc animated:YES];
}


@end
