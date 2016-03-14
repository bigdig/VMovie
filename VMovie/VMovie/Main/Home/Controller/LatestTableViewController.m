//
//  LatestTableViewController.m
//  VMovie
//
//  Created by wyz on 16/3/14.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "LatestTableViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "Movie.h"
#import "MovieCell.h"
#import <MJRefresh/MJRefresh.h>

@interface LatestTableViewController ()

/**微电影数据 */
@property (nonatomic, strong) NSMutableArray *movieArray;

/**页数 */
@property (nonatomic, assign) NSInteger page;

@end

@implementation LatestTableViewController

static NSString *movieCellIdentifier = @"movieCellIdentifier";

- (NSMutableArray *)movieArray {
    
    if (!_movieArray) {
        _movieArray = [NSMutableArray array];
    }
    return _movieArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[MovieCell class] forCellReuseIdentifier:movieCellIdentifier];
    self.tableView.rowHeight = ScaleFrom_iPhone5_Desgin(200);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self setupRefresh];
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
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"p"] = @1;
    params[@"tab"] = @"latest";
    
    [manager GET:@"http://app.vmoiver.com/apiv3/post/getPostByTab" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
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
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSInteger page = self.page + 1;
    params[@"p"] = @(page);
    params[@"tab"] = @"latest";
    
    [manager GET:@"http://app.vmoiver.com/apiv3/post/getPostByTab" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
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
