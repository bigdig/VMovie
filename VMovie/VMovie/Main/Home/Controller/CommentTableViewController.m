//
//  CommentTableViewController.m
//  VMovie
//
//  Created by wyz on 16/4/11.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "CommentTableViewController.h"
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>
#import "Comment.h"
#import "CommentCell.h"
#import "Movie.h"

@interface CommentTableViewController ()

/**数据源 */
@property (nonatomic, strong) NSMutableArray *commentArray;
/**页数 */
@property (nonatomic, assign) NSInteger page;
/**行高缓存 */
@property (nonatomic, strong) NSMutableDictionary *rowCache;
/**评论总数 */
@property (nonatomic, assign) NSInteger total;

@end

@implementation CommentTableViewController

 static NSString *const reuseIdentifier = @"CommentCell";

- (NSMutableArray *)commentArray{
    if (!_commentArray) {
        _commentArray = [NSMutableArray array];
    }
    return _commentArray;
}

- (NSMutableDictionary *)rowCache {
    if (_rowCache) {
        _rowCache = [NSMutableDictionary dictionary];
    }
    return _rowCache;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerClass:[CommentCell class] forCellReuseIdentifier:reuseIdentifier];
    
    [self setupRefresh];
}

//设置上下拉刷新
- (void) setupRefresh {
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadLatestComment)];
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
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComment)];
}

- (void) loadLatestComment {
    [self.tableView beginLoading];
    [self.tableView.mj_footer endRefreshing];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = @0;
    params[@"page"] = @1;
    params[@"postid"] = self.movie.postid;
    [[YZNetworking sharedManager] GET:@"http://app.vmoiver.com/apiv3/comment/getLists" parameters:params success:^(id  _Nullable responseObject) {
        
        self.commentArray = [self commentArrayWithDict:responseObject];
        self.total = [responseObject[@"total_num"] integerValue];
        !self.commentCountBlock ? : self.commentCountBlock(self.total);

        [self.tableView reloadData];
        self.page = 1;
        [self.tableView endLoading];
        [self.tableView.mj_header endRefreshing];
        @weakify(self);
        [self.view configWithText:@"还没有人评论呢" hasData:self.commentArray.count > 0 hasError:NO reloadDataBlock:^(id sender) {
            @strongify(self);
            [self loadLatestComment];
        }];
        [self updatefooterState];
    } failure:^(NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView endLoading];
        @weakify(self);
        [self.view configWithText:@"加载失败" hasData:self.commentArray.count > 0 hasError:YES reloadDataBlock:^(id sender) {
            @strongify(self);
            [self loadLatestComment];
        }];
    }];
}

- (void) loadMoreComment {
    [self.tableView.mj_header endRefreshing];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSInteger page = self.page + 1;
    params[@"p"] = @(page);
    params[@"postid"] = self.movie.postid;
    params[@"type"] = @0;
    [[YZNetworking sharedManager] GET:@"http://app.vmoiver.com/apiv3/comment/getLists" parameters:params success:^(id  _Nullable responseObject) {
        NSArray *dataArray = [self commentArrayWithDict:responseObject];
        [self.commentArray addObjectsFromArray:dataArray];
        [self.tableView reloadData];
        self.page = page;
        [self updatefooterState];
    } failure:^(NSError * _Nonnull error) {
        [self.tableView.mj_footer endRefreshing];
        [NSObject showHudTipStr:@"网络连接失败"];
    }];
}

//更新footer状态
- (void) updatefooterState {
    
    if (self.commentArray.count < self.total) {
        [self.tableView.mj_footer endRefreshing];
    } else {
        self.tableView.mj_footer.hidden = YES;
    }
}

- (NSMutableArray *) commentArrayWithDict:(NSDictionary *) responseObject {
    NSMutableArray *dataArray = [NSMutableArray array];
    NSArray *responseArray = [Comment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
    for (Comment *c in responseArray) {
        [dataArray addObject:c];
        if (c.subcomment.count > 0) {
            for(Comment *subc in c.subcomment) {
                subc.isSubComment = YES;
                [dataArray addObject:subc];
            }
        }
    }
    return  dataArray;
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger ) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    tableView.mj_footer.hidden = self.commentArray.count <= 0;
    return self.commentArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    cell.comment = self.commentArray[indexPath.row];
    return cell;
}

- (CGFloat ) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Comment *comment = self.commentArray[indexPath.row];
    CGFloat cellHeight = [self.rowCache[@"comment.commentid"] doubleValue];
    if (!cellHeight) {
        CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        cellHeight = [cell cellHeight:comment];
        self.rowCache[@"comment.commentid"] = @(cellHeight);
    }
    return cellHeight;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 44)];
    headerView.backgroundColor = RGBCOLOR(250, 250, 250);
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 44)];
    countLabel.textColor = [UIColor grayColor];
    countLabel.text = [NSString stringWithFormat:@"%ld用户评论",self.total];
    [headerView addSubview:countLabel];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(headerView.width - 40, 0, 20, 44)];
    [button setImage:[UIImage imageNamed:@"img_arrow_donw"] forState:UIControlStateNormal];
    [headerView addSubview:button];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [headerView addGestureRecognizer:tap];
    return headerView;
}

-(CGFloat ) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (void) tapAction {
    !self.ClickHeaderBlock ? : self.ClickHeaderBlock();
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    !self.beginScrollBlock? : self.beginScrollBlock();
}
@end
