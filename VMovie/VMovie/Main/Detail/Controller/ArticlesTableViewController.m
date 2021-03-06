//
//  ArticlesTableViewController.m
//  VMovie
//
//  Created by wyz on 16/3/18.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "ArticlesTableViewController.h"
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>
#import "Movie.h"
#import "ArticleCell.h"
#import "ArticleWebViewController.h"

@interface ArticlesTableViewController ()

/**数据 */
@property (nonatomic, strong) NSMutableArray *articleArray;

/**页数 */
@property (nonatomic, assign) NSInteger page;

@end

@implementation ArticlesTableViewController

static NSString * const reuseIdentifier = @"ArticleCell";



- (NSMutableArray *)articleArray {
    if (!_articleArray) {
        _articleArray = [NSMutableArray array];
    }
    return _articleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupRefresh];
   
    [self.tableView registerClass:[ArticleCell class] forCellReuseIdentifier:reuseIdentifier];
    self.tableView.rowHeight  = ScaleFrom_iPhone5_Desgin(100);
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void) setupRefresh {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewArticles)];
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
    [self loadNewArticles];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreArticles)];
}

- (void) loadMoreArticles {
    [self.tableView.mj_header endRefreshing];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSInteger page = self.page + 1;
    params[@"p"] = @(page);
    params[@"cateid"] = @(self.type);
    
    [[YZNetworking sharedManager] GET:@"http://app.vmoiver.com/apiv3/backstage/getPostByCate" parameters:params success:^(id  _Nullable responseObject) {
        NSArray *dataArray = [Movie mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.articleArray addObjectsFromArray:dataArray];
        [self.tableView reloadData];
        self.page = page;
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError * _Nonnull error) {
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
    
}

- (void) loadNewArticles {
    
    [self.tableView.mj_footer endRefreshing];
    [self.tableView beginLoading];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"cateid"] = @(self.type);
    params[@"p"] = @1;
    
    [[YZNetworking sharedManager] GET:@"http://app.vmoiver.com/apiv3/backstage/getPostByCate" parameters:params success:^(id  _Nullable responseObject) {
        
        self.articleArray = [Movie mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.tableView reloadData];
        [self.tableView endLoading];
        [self.tableView.mj_header endRefreshing];
        self.page = 1;
        @weakify(self);
        [self.view configWithText:@"加载失败" hasData:self.articleArray.count > 0 hasError:YES reloadDataBlock:^(id sender) {
            @strongify(self);
            [self loadNewArticles];
        }];
        
    } failure:^(NSError * _Nonnull error) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView endLoading];
        @weakify(self);
        [self.view configWithText:@"加载失败" hasData:self.articleArray.count > 0 hasError:YES reloadDataBlock:^(id sender) {
            @strongify(self);
            [self loadNewArticles];
        }];
    }];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   tableView.mj_footer.hidden = (self.articleArray.count == 0);
    return self.articleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    cell.movie = self.articleArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ArticleWebViewController *articleVc = [[ArticleWebViewController alloc] init];
    articleVc.movie = self.articleArray[indexPath.row];
    [self.navigationController pushViewController:articleVc animated:YES];
}


@end
