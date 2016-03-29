//
//  ChannelClubTableViewController.m
//  VMovie
//
//  Created by wyz on 16/3/17.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "ChannelClubTableViewController.h"
#import "UIBarButtonItem+Custom.h"
#import "Channel.h"
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>
#import "MovieCell.h"
#import "Movie.h"
#import "MoviePlayerViewController.h"

@interface ChannelClubTableViewController ()

/**微电影数据 */
@property (nonatomic, strong) NSMutableArray *movieArray;

/**页数 */
@property (nonatomic, assign) NSInteger page;

/**广告数据 */
@property (nonatomic, strong) NSMutableArray *bannerArray;


@end

@implementation ChannelClubTableViewController

static NSString * const movieCellIdentifier = @"movieCellIdentifier";

- (NSMutableArray *)movieArray {
    
    if (!_movieArray) {
        _movieArray = [NSMutableArray array];
    }
    return _movieArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor  = [UIColor whiteColor];
    
    self.navigationItem.title = self.channel.catename;
    
    UIBarButtonItem *backItem = [UIBarButtonItem itemWithImage:@"login_back_button" HighImage:@"login_back_button" target:self action:@selector(backItemClick)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    [self.tableView registerClass:[MovieCell class] forCellReuseIdentifier:movieCellIdentifier];
    self.tableView.rowHeight = ScaleFrom_iPhone5_Desgin(200);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self setupRefresh];
}

- (void) setupRefresh {
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadLatestMovies)];
    [header setTitle:@"下拉刷新..." forState:MJRefreshStateIdle];
    [header setTitle:@"释放立即刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"刷新中..." forState:MJRefreshStateRefreshing];
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    
    // 设置颜色
    header.stateLabel.textColor = RGBCOLOR(125, 136, 157);
    header.lastUpdatedTimeLabel.textColor = RGBCOLOR(125, 136, 157);
    self.tableView.mj_header = header;
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadLatestMovies)];
//    [self.tableView.mj_header beginRefreshing];
    [self loadLatestMovies];
//    self.tableView.mj_header
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreMovies)];
}

- (void) loadLatestMovies {
    
    [self.tableView beginLoading];
    [self.tableView.mj_footer endRefreshing];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"p"] = @1;
    params[@"cateid"] = self.channel.cateid;
    
    [YZNetworking GET:@"http://app.vmoiver.com/apiv3/post/getPostInCate" parameters:params success:^(id  _Nullable responseObject) {
        self.movieArray = [Movie mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.tableView reloadData];
        self.page = 1;
        [self.tableView.mj_header endRefreshing];
        [self.tableView endLoading];
        @weakify(self);
        [self.view configWithData:self.movieArray.count > 0 reloadDataBlock:^(id sender) {
            @strongify(self);
            [self loadLatestMovies];
        }];
    } failure:^(NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView endLoading];
        @weakify(self);
        [self.view configWithData:self.movieArray.count > 0 reloadDataBlock:^(id sender) {
            @strongify(self);
            [self loadLatestMovies];
        }];
    }];
}

- (void) loadMoreMovies {
    
    [self.tableView.mj_header endRefreshing];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSInteger page = self.page + 1;
    params[@"p"] = @(page);
    params[@"cateid"] = self.channel.cateid;
    
    [YZNetworking GET:@"http://app.vmoiver.com/apiv3/post/getPostByTab" parameters:params success:^(id  _Nullable responseObject) {
        NSArray *dataArray = [Movie mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.movieArray addObjectsFromArray:dataArray];
        [self.tableView reloadData];
        self.page = page;
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError * _Nonnull error) {
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
}

- (void) backItemClick {
    [self.tableView endLoading];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
