//
//  MessageTableViewController.m
//  VMovie
//
//  Created by wyz on 16/4/6.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "MessageTableViewController.h"
#import "UIBarButtonItem+Custom.h"

@interface MessageTableViewController ()

/**数据源 */
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation MessageTableViewController

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBCOLOR(245, 245, 245);
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.navigationItem.title = @"消息";
    [self.view configWithText:@"还没有消息呢" hasData:self.dataSource.count > 0 hasError:NO reloadDataBlock:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        [NSObject showHudTipStr:@"网络连接失败"];
    }
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 0;
}


@end
