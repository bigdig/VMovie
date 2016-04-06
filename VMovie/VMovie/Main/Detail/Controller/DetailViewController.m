//
//  DetailViewController.m
//  VMovie
//
//  Created by wyz on 16/3/16.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailHeaderView.h"
#import "DetailListCell.h"
#import "MovieChannelCollectionViewController.h"
#import "VMNavigationController.h"
#import "BackStageViewController.h"
#import "SeriesTableViewController.h"
#import "MarkTableViewController.h"
#import "DownTableViewController.h"
#import "LikeTableViewController.h"
#import "LoginViewController.h"
#import "SettingTableViewController.h"
#import "MessageTableViewController.h"

@interface DetailViewController () <UITableViewDataSource,UITableViewDelegate>

/** 关闭按钮 */
@property (nonatomic, weak) UIButton *backButton;

/**标题数据 */
@property (nonatomic, strong) NSArray *titles;
/**图标数据 */
@property (nonatomic, strong) NSArray *images;

@end

@implementation DetailViewController

static NSString *DetailListCellIdentifier = @"DetailListCellIdentifier";

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self setupBackButton];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupSubViews];
    
    //数据源
    self.titles = @[@"首页",@"频道",@"系列",@"幕后"];
    self.images = @[@"side_home",@"side_channel",@"side_series",@"side_behind"];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void) setupSubViews {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = self.bgImage;
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    bgView.contentMode = UIViewContentModeScaleAspectFill;
    bgView.image = [UIImage imageNamed:@"menu_top_bg"];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate =self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.rowHeight = ScaleFrom_iPhone5_Desgin(50);
    [self.view addSubview:tableView];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [tableView registerClass:[DetailListCell class] forCellReuseIdentifier:DetailListCellIdentifier];
    
    [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    
    DetailHeaderView *headerView = [DetailHeaderView headerView];
    @weakify(self);
    headerView.LoginBlock = ^{
        @strongify(self);
        LoginViewController *loginVc = [[LoginViewController alloc] init];
        loginVc.showDismissButton = YES;
        [self presentViewController:loginVc animated:YES completion:nil];
    };
    headerView.SettingBlock = ^{
        @strongify(self);
        SettingTableViewController *settingVc = [[SettingTableViewController alloc] init];
        [self.navigationController pushViewController:settingVc animated:YES];
    };
    headerView.MessageBlock = ^{
        @strongify(self);
        MessageTableViewController *messageVc = [[MessageTableViewController alloc] init];
        [self.navigationController pushViewController:messageVc animated:YES];
    };
    headerView.MarkBlock = ^{
        NSLog(@"点击了订阅");
    };
    headerView.DownBlock = ^{
        
    };
    headerView.LikeBlock = ^{
        
    };
    tableView.tableHeaderView = headerView;
}

- (void) setupBackButton {
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundColor:[UIColor blackColor]];
    [backButton setBackgroundImage:[UIImage imageNamed:@"menu_close_bg"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    self.backButton = backButton;
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@60);
        make.bottom.equalTo(self.view).offset(-(App_Frame_Height * 0.05));
        make.right.equalTo(self.view).offset(-(App_Frame_Width * 0.15));
    }];
    
    backButton.layer.cornerRadius = 30;
    backButton.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:5.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        backButton.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
    }];
    
    @weakify(self);
    [[backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

#pragma mark UITableViewDataSource 

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:DetailListCellIdentifier];
    
    if (indexPath.row == 0) {
        cell.selected = YES;
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailListCell *detailListcell = (DetailListCell *) cell;
    detailListcell.textLabel.text = self.titles[indexPath.row];
    detailListcell.imageName = self.images[indexPath.row];
    if (indexPath.row == 0) {
        detailListcell.imageView.image = [UIImage imageNamed:self.images[0]];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.backButton) {
        [self.backButton removeFromSuperview];
    }
    
    if (indexPath.row == 0) { //点击首页
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    if (indexPath.row == 1) { // 点击频道
        
        MovieChannelCollectionViewController *movieChannelVc = [[MovieChannelCollectionViewController alloc] init];
        VMNavigationController *vmNav = [[VMNavigationController alloc] initWithRootViewController:movieChannelVc];
        vmNav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vmNav animated:YES completion:nil];
    }
    
    if (indexPath.row == 2) { //点击系列
        
        SeriesTableViewController *seriesVc = [[SeriesTableViewController alloc] init];
        VMNavigationController *vmNav = [[VMNavigationController alloc] initWithRootViewController:seriesVc];
        vmNav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vmNav animated:YES completion:nil];
    }
    
    if (indexPath.row == 3) { //点击幕后
        
        BackStageViewController *backStageVc = [[BackStageViewController alloc] init];
        VMNavigationController *vmNav = [[VMNavigationController alloc] initWithRootViewController:backStageVc];
        vmNav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vmNav animated:YES completion:nil];
    }
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

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
