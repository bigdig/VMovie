//
//  HotTableViewController.m
//  VMovie
//
//  Created by wyz on 16/3/14.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "HotTableViewController.h"
#import <AFNetworking/AFNetworking.h>
@interface HotTableViewController ()

@end

@implementation HotTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HotCell"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"HOT----%zd",indexPath.row];
    
    return cell;
}


@end
