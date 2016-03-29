//
//  MovieChannelCollectionViewController.m
//  VMovie
//
//  Created by wyz on 16/3/16.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "MovieChannelCollectionViewController.h"
#import "UIBarButtonItem+Custom.h"
#import "SearchMovieViewController.h"
#import <MJExtension/MJExtension.h>
#import "Channel.h"
#import "ChannelCell.h"
#import "ChannelClubTableViewController.h"

@interface MovieChannelCollectionViewController ()

/**频道数据 */
@property (nonatomic, strong) NSArray *channelArray;

@end

@implementation MovieChannelCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)init {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemWidth = App_Frame_Width * 0.5;
    CGFloat itemHeight =  itemWidth;
    layout.itemSize = CGSizeMake(itemWidth , itemHeight);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
//    layout.sectionInset = UIEdgeInsetsMake(20, 10, 20, 10);
    
    return [super initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];;
    
    self.navigationItem.title = @"频道";
    //两侧按钮
    UIBarButtonItem *detailItem = [UIBarButtonItem itemWithImage:@"img_icon_menu" HighImage:@"img_icon_menu" target:self action:@selector(detailItemClick)];
    self.navigationItem.leftBarButtonItem = detailItem;
    
    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithImage:@"img_icon_search" HighImage:@"img_icon_search" target:self action:@selector(searchItemClick)];
    self.navigationItem.rightBarButtonItem = searchItem;
    
    // Register cell classes
    [self.collectionView registerClass:[ChannelCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self loadChannels];
}

- (void) loadChannels {
//    http://app.vmoiver.com/apiv3/cate/getList?
    
    [self.collectionView beginLoading];
    [YZNetworking GET:@"http://app.vmoiver.com/apiv3/cate/getList?" parameters:nil success:^(id  _Nullable responseObject) {
        
        self.channelArray = [Channel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.collectionView reloadData];
        [self.collectionView endLoading];
        
        @weakify(self);
        [self.view configWithData:self.channelArray.count > 0 reloadDataBlock:^(id sender) {
            @strongify(self);
            [self loadChannels];
        }];
        
    } failure:^(NSError * _Nonnull error) {
        [self.collectionView endLoading];
        @weakify(self);
        [self.view configWithData:self.channelArray.count > 0 reloadDataBlock:^(id sender) {
            @strongify(self);
            [self loadChannels];
        }];
    }];
    
}

- (void) detailItemClick {
    [self.collectionView endLoading];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) searchItemClick {
    [self.collectionView endLoading];
    SearchMovieViewController *searchMovieVc = [[SearchMovieViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchMovieVc];
    nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark <UICollectionViewDataSource>


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.channelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ChannelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ChannelCell *channelCell = (ChannelCell *) cell;
    channelCell.channel = self.channelArray[indexPath.item];
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ChannelClubTableViewController *channelClubVc = [[ChannelClubTableViewController alloc] init];
    channelClubVc.channel = self.channelArray[indexPath.row];
    [self.navigationController pushViewController:channelClubVc animated:YES];
}

@end
