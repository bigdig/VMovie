//
//  SearchMovieViewController.m
//  VMovie
//
//  Created by wyz on 16/3/15.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "SearchMovieViewController.h"
#import "SearchBar.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>
#import "Movie.h"
#import "SearchMovieCell.h"
#import "MoviePlayerViewController.h"
#import "NSArray+Categoty.h"
#import "UITableView+Extension.h"

@interface SearchMovieViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

/**搜索历史 */
@property (nonatomic, strong) NSMutableArray *historyies;
/**TableView */
@property (nonatomic, weak) UITableView *tableView;
/** 清除历史按钮 */
@property (nonatomic, weak) UIButton *clearButton;
/**微电影数据 */
@property (nonatomic, strong) NSMutableArray *movieArray;
/**网络管理 */
@property (nonatomic, strong) AFHTTPSessionManager *manager;
/**页数 */
@property (nonatomic, assign) NSInteger page;

/** 搜索框 */
@property (nonatomic, weak) SearchBar *searchBar;
/**搜索内容 */
@property (nonatomic, copy) NSString *searchText;

/**是否显示搜索历史 */
@property (nonatomic, assign) BOOL showHistory;
/** 搜索结果提示 */
@property (nonatomic, weak) UILabel *resultLabel;
/**搜索结果总数 */
@property (nonatomic, assign) NSInteger total;

/** 底部视图 */
@property (nonatomic, strong) UIView *footerView;
/**顶部视图 */
@property (nonatomic, strong) UIView *headerView;

@end

@implementation SearchMovieViewController

static NSString *HistoryIdentifier = @"HistoryIdentifier";
static NSString *MovieIdentifier = @"MovieIdentifier";

#pragma mark - life cycle 生命周期

//视图显示时从沙盒加载历史记录
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
      self.navigationController.navigationBarHidden = YES;
    self.historyies = [NSMutableArray arrayWithContentsOfFile:[PATH_OF_DOCUMENT stringByAppendingPathComponent:@"SearchHistory.plist"]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

//视图初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    
    [self setupTableView];
    [self setupTopView];
    [self setupRefresh];
}

//控制器销毁时取消网络请求
-(void)dealloc {
    [self.tableView endLoading];
    [self.manager.dataTasks makeObjectsPerformSelector:@selector(cancel)];
}

#pragma mark - Delegate 视图委托

#pragma mark UITableViewDataSource,UITableViewDelegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //更新footer及清除历史记录的状态
    tableView.mj_footer.hidden = self.movieArray.count == 0 || self.showHistory;
    self.clearButton.hidden = (self.historyies.count == 0) || (!self.showHistory);
    return !self.showHistory ? self.movieArray.count : self.historyies.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    if (!self.showHistory) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell = [tableView dequeueReusableCellWithIdentifier:MovieIdentifier];
    } else {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        cell = [tableView dequeueReusableCellWithIdentifier:HistoryIdentifier];
        
    }
    return cell;
}

//在willDisplayCell中更新数据
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.showHistory) {
        SearchMovieCell *sMovieCell = (SearchMovieCell *)cell;
        sMovieCell.movie = self.movieArray[indexPath.row];
    } else {
        cell.textLabel.text = self.historyies[indexPath.row];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.showHistory) {
        return ScaleFrom_iPhone5_Desgin(100);
    } else {
        return ScaleFrom_iPhone5_Desgin(44);
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!self.showHistory) {
        MoviePlayerViewController *moviePlayerVc = [[MoviePlayerViewController alloc] init];
        moviePlayerVc.movie = self.movieArray[indexPath.row];
        [self.navigationController pushViewController:moviePlayerVc animated:YES];
    } else {
        self.searchBar.text = self.historyies[indexPath.row];
        [self textFieldShouldReturn:self.searchBar];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
}

#pragma  mark  UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //搜索时将tableview滚动到顶部
    [self.tableView setContentOffset:CGPointZero animated:YES];
    
    //取消上次请求
    [self.manager.dataTasks makeObjectsPerformSelector:@selector(cancel)];
    
    //将要搜索的文字加入搜索历史
    if (textField.text.length > 0 ) {
        [self.historyies insertObject:textField.text atIndex:0];
        self.historyies = [self.historyies deleteRepetitionElements];
        if (self.historyies.count > 5) {
            [self.historyies removeLastObject];
        }
        //将搜索内容写入沙盒
        self.searchText = textField.text;
        [self.historyies writeToFile:[PATH_OF_DOCUMENT stringByAppendingPathComponent:@"SearchHistory.plist"] atomically:YES];
        //加载搜索结果
        self.resultLabel.text = nil;
        [self.movieArray removeAllObjects];
        self.showHistory = NO;
        [self loadSearchResultMovies];
        //退出键盘
        [self.view endEditing:YES];
    }
    
    return YES;
}

#pragma mark - private methods 私有方法

//刷新控件
- (void) setupRefresh {
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreMovies)];
    self.tableView.mj_footer.hidden = YES;
}

//tableView
- (void) setupTableView {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, App_Frame_Width, App_Frame_Height - 44) style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[SearchMovieCell class] forCellReuseIdentifier:MovieIdentifier];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:HistoryIdentifier];
    tableView.tableHeaderView = self.headerView;
    tableView.tableFooterView = self.footerView;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

//顶部搜索框视图
- (void) setupTopView {
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.equalTo(@64);
    }];
    
    SearchBar *searchBar = [[SearchBar alloc] init];
    searchBar.delegate = self;
    [searchBar becomeFirstResponder];
    @weakify(self);
    searchBar.showHistoryBlock = ^{
        @strongify(self);
        [SVProgressHUD dismiss];
        self.showHistory = YES;
    };
    [topView addSubview:searchBar];
    self.searchBar = searchBar;
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(20);
        make.bottom.equalTo(topView).offset(-7);
        make.width.equalTo(@(App_Frame_Width - 80));
        make.height.equalTo(@30);
    }];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [topView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchBar.mas_right).offset(10);
        make.bottom.height.equalTo(searchBar);
        make.right.equalTo(topView).offset(-15);
    }];
    [[cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.view endEditing:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIImageView *separatorView = [[UIImageView alloc] init];
    separatorView.image = [UIImage imageNamed:@"search_cell_bottom"];
    [topView addSubview:separatorView];
    [separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(topView);
        make.height.equalTo(@1);
    }];
}

//发送请求加载首页
- (void) loadSearchResultMovies{
    
    [self.manager.dataTasks makeObjectsPerformSelector:@selector(cancel)];
    [self.tableView beginLoading];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"kw"] = self.searchText;
    params[@"p"] = @1;
    
    [self.manager GET:@"http://app.vmoiver.com/apiv3/search" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.movieArray = [Movie mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        NSNumber *total = responseObject[@"total"];
        self.total = total.integerValue;
        
        if (self.movieArray.count == 0) {
            self.resultLabel.text = @"根据您的搜索条件,没有查询到任何相关内容";
        } else {
            self.resultLabel.text = [NSString stringWithFormat:@"搜索到%@条关于\"%@\"的内容",total,self.searchText];
        }
        [self.tableView reloadData];
        
        self.page  = 1;
        
        [self.tableView endLoading];
        
//        @weakify(self);
//        [self.view configWithData:self.movieArray.count > 0 reloadDataBlock:^(id sender) {
//            @strongify(self);
//            [self loadSearchResultMovies];
//        }];
        
        [self updatefooterState];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.tableView endLoading];
        
        @weakify(self);
        [self.view configWithData:self.movieArray.count > 0 reloadDataBlock:^(id sender) {
            @strongify(self);
            [self loadSearchResultMovies];
        }];
    }];
    
}

//加载更多数据
- (void) loadMoreMovies {
    
    [self.manager.dataTasks makeObjectsPerformSelector:@selector(cancel)];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSInteger page = self.page + 1;
    params[@"p"] = @(page);
    params[@"kw"] = self.searchText;
    
    [self.manager GET:@"http://app.vmoiver.com/apiv3/search" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *dataArray = [Movie mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        [self.movieArray addObjectsFromArray:dataArray];
        [self.tableView reloadData];
        self.page = page;
        [self updatefooterState];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"网络好像出问题了哟('_')"];
    }];
}

//更新footer状态
- (void) updatefooterState {
    
    if (self.movieArray.count < self.total) {
        [self.tableView.mj_footer endRefreshing];
    } else {
        self.tableView.mj_footer.hidden = YES;
    }
}

#pragma mark - getters and setters 属性

//网络管理者
- (AFHTTPSessionManager *)manager {
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

//微电影数据
- (NSMutableArray *)movieArray {
    if (!_movieArray) {
        _movieArray = [NSMutableArray array];
    }
    return _movieArray;
}

//历史记录数据
- (NSMutableArray *)historyies {
    if (!_historyies) {
        _historyies = [NSMutableArray array];
    }
    return _historyies;
}

//底部视图
- (UIView *)footerView {
    
    if (!_footerView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.height = 100;
        self.footerView = view;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"search_clearHistory_bg"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"search_clearHistory_bg"] forState:UIControlStateHighlighted];
        button.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitle:@"清除历史记录" forState:UIControlStateNormal];
        
         @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.historyies removeAllObjects];
            [self.tableView reloadData];
            [self.historyies writeToFile:[PATH_OF_DOCUMENT stringByAppendingPathComponent:@"SearchHistory.plist"] atomically:YES];
        }];
        
        [view addSubview:button];
        self.clearButton = button;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(view);
            make.width.equalTo(@200);
            make.height.equalTo(@50);
        }];
    }
    return _footerView;
}

//头部视图
-(UIView *)headerView {
    if (!_headerView) {
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.height  = 100;
        self.headerView = view;
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.numberOfLines = 0;
        [view addSubview:label];
        self.resultLabel = label;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(view);
        }];
        
        UIImageView *separatorView = [[UIImageView alloc] init];
        separatorView.image = [UIImage imageNamed:@"search_cell_bottom"];
        [view addSubview:separatorView];
        [separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(view);
            make.height.equalTo(@1);
        }];
    }
    return _headerView;
}

- (void)setShowHistory:(BOOL)showHistory {
    
    _showHistory = showHistory;
    [self.tableView reloadData];
    if (showHistory) {
        [self.tableView endLoading];
        self.tableView.tableFooterView = self.footerView;
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 0.1)];
    } else {
        self.tableView.tableHeaderView = self.headerView;
        self.tableView.tableFooterView = nil;
    }
}

#pragma mark - 屏幕
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
