//
//  SettingTableViewController.m
//  VMovie
//
//  Created by wyz on 16/4/6.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "SettingTableViewController.h"
#import "UIBarButtonItem+Custom.h"
#import "UIImage+Category.h"
#import "UserCell.h"
#import <SDWebImage/SDImageCache.h>

@interface SettingTableViewController ()
/**数据源 */
@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation SettingTableViewController

static NSString * const userCellIdentifier = @"UserCell";

- (instancetype)init {
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBCOLOR(245, 245, 245);
    self.navigationItem.title = @"设置";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"login_back_button" HighImage:@"login_back_button" target:self action:@selector(back)];
    
    self.dataSource = @[@[@"碎梦旧人"],
                            @[@"用户反馈",@"清除图片缓存",@"允许非Wi-Fi网络下载",@"给V电影评分",@"版本更新"],
                            @[@"分享给好友",@"关注微信公众号",@"加入用户QQ群",@"关于我们",@"免责声明"]];
    [self.tableView registerClass:[UserCell class] forCellReuseIdentifier:userCellIdentifier];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 50;
    
}

- (void) back {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0 && indexPath.row == 0) { //用户
        UserCell  *cell = [tableView dequeueReusableCellWithIdentifier:userCellIdentifier];
        cell.textLabel.text = self.dataSource[indexPath.section][indexPath.row];
        cell.imageView.image = [[UIImage imageNamed:@"1"] circleImage];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        @weakify(self);
        cell.logoutBlock = ^{
            @strongify(self);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要退出吗?" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
             [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                 [SVProgressHUD showSuccessWithStatus:@"出不去啦~\(≧▽≦)/~啦啦啦"];
             }]];
            [self presentViewController:alert animated:YES completion:nil];
             };
        return cell;
    } else {
    static NSString * const reuseIdentifier = @"SettingCell";
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.dataSource[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
    
    if(indexPath.section == 1 && indexPath.row == 1) { //清除缓存
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ldM",[SDImageCache sharedImageCache].getSize];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM",[self getSize] / 1000.0 / 1000.0];
    }
    
    if(indexPath.section == 1 && indexPath.row == 2){ //允许非Wi-Fi网络下载
        cell.accessoryView = [[UISwitch alloc] init];
    }
    
    if(indexPath.section == 1 && indexPath.row == 4) {//版本更新
        cell.detailTextLabel.text = @"V5.0.1";
    }
        
    return cell;
    }
   
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 60;
    } else {
        return 50;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 20)];
    headerView.backgroundColor = RGBCOLOR(245, 245, 245);
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1 && indexPath.row == 1) {
//        [[SDImageCache sharedImageCache] clearDisk];
        [self clearCache];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.detailTextLabel.text = @"0M";
//        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (NSInteger)getSize
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *cachePath = [caches stringByAppendingPathComponent:@"default/com.hackemist.SDWebImageCache.default"];
    
    NSDirectoryEnumerator *fileEnumerator = [manager enumeratorAtPath:cachePath];
    NSInteger totalSize = 0;
    for (NSString *fileName in fileEnumerator) {
        NSString *filepath = [cachePath stringByAppendingPathComponent:fileName];
        
        NSDictionary *attrs = [manager attributesOfItemAtPath:filepath error:nil];
        if ([attrs[NSFileType] isEqualToString:NSFileTypeDirectory]) continue;
        
        totalSize += [attrs[NSFileSize] integerValue];
    }
    return totalSize;
}


-(void) clearCache
{
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess)
                                              withObject:nil waitUntilDone:YES];});
}

-(void)clearCacheSuccess
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"缓存清理成功！"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}
@end
