//
//  SeriesTableViewController.m
//  VMovie
//
//  Created by wyz on 16/4/5.
//  Copyright © 2016年 wyz. All rights reserved.
//  http://app.vmoiver.com/apiv3/series/getList?p=1

#import "SeriesTableViewController.h"
#import "UIBarButtonItem+Custom.h"
#import "SearchMovieViewController.h"
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>
#import "Series.h"
#import "SeriesCell.h"

@interface SeriesTableViewController ()
/**页数 */
@property (nonatomic, assign) NSInteger page;

/**数据 */
@property (nonatomic, strong) NSMutableArray *seriesList;

@end

@implementation SeriesTableViewController

static NSString * const reuseIdentifier = @"SeriesCell";

- (NSMutableArray *)seriesList {
    if (!_seriesList) {
        _seriesList = [NSMutableArray array];
    }
    return  _seriesList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNav];
    [self setupRefresh];
    
    [self.tableView registerClass:[SeriesCell class] forCellReuseIdentifier:reuseIdentifier];
    
    self.tableView.rowHeight = 320;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void) setupNav {
    //两侧按钮
    UIBarButtonItem *detailItem = [UIBarButtonItem itemWithImage:@"img_icon_menu" HighImage:@"img_icon_menu" target:self action:@selector(detailItemClick)];
    self.navigationItem.leftBarButtonItem = detailItem;
    
    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithImage:@"img_icon_search" HighImage:@"img_icon_search" target:self action:@selector(searchItemClick)];
    self.navigationItem.rightBarButtonItem = searchItem;
}

- (void) setupRefresh {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadLastetSeries)];
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
    [self loadLastetSeries];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreSeries)];
}

- (void) loadLastetSeries {
    
    [self.tableView.mj_footer endRefreshing];
    [self.tableView beginLoading];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"p"] = @1;
    
    [[YZNetworking sharedManager] GET:@"http://app.vmoiver.com/apiv3/series/getList" parameters:params success:^(id  _Nullable responseObject) {
        
        self.seriesList = [Series mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.tableView reloadData];
        [self.tableView endLoading];
        [self.tableView.mj_header endRefreshing];
        self.page = 1;
        @weakify(self);
        [self.view configWithText:@"加载失败" hasData:self.seriesList.count > 0 hasError:YES reloadDataBlock:^(id sender) {
            @strongify(self);
            [self loadLastetSeries];
        }];
        
    } failure:^(NSError * _Nonnull error) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView endLoading];
        @weakify(self);
        [self.view configWithText:@"加载失败" hasData:self.seriesList.count > 0 hasError:YES reloadDataBlock:^(id sender) {
            @strongify(self);
            [self loadLastetSeries];
        }];
    }];
}

- (void) loadMoreSeries {
    [self.tableView.mj_header endRefreshing];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSInteger page = self.page + 1;
    params[@"p"] = @(page);
    
    [[YZNetworking sharedManager] GET:@"http://app.vmoiver.com/apiv3/series/getList" parameters:params success:^(id  _Nullable responseObject) {
        NSArray *dataArray = [Series mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.seriesList addObjectsFromArray:dataArray];
        [self.tableView reloadData];
        self.page = page;
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError * _Nonnull error) {
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
    
}

- (void) detailItemClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) searchItemClick {
    [SVProgressHUD dismiss];
    SearchMovieViewController *searchMovieVc = [[SearchMovieViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchMovieVc];
    nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nav animated:YES completion:nil];
  
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    tableView.mj_footer.hidden = self.seriesList.count <= 0;
    return self.seriesList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SeriesCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SeriesCell *seriesCell = (SeriesCell *)cell;
    seriesCell.series = self.seriesList[indexPath.row];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
