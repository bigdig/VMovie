//
//  LoginViewController.m
//  VMovie
//
//  Created by wyz on 16/4/5.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "LoginViewController.h"
#import <TPKeyboardAvoiding/TPKeyboardAvoidingTableView.h>
#import "LoginTextCell.h"

#define HEADERHEIGHT App_Frame_Height / 3
#define FOOTERHEIGHT App_Frame_Height * 4 / 9

@interface LoginViewController ()<UITableViewDataSource,UITableViewDelegate>

/** tableView */
@property (nonatomic, weak) TPKeyboardAvoidingTableView *tableView;

/**返回按钮 */
@property (nonatomic, strong) UIButton *dismissButton;

@end

@implementation LoginViewController

static NSString *const reuseIdentifier = @"LoginCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TPKeyboardAvoidingTableView *tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.bounces = NO;
    
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.tableView = tableView;
    
    self.tableView.rowHeight = (App_Frame_Height - HEADERHEIGHT - FOOTERHEIGHT) * 0.5;
    self.tableView.tableHeaderView = [self customHeaderView];
    self.tableView.tableFooterView = [self customFooterView];
    
    [self.tableView registerClass:[LoginTextCell class] forCellReuseIdentifier:reuseIdentifier];
    
    [self showDismissButton:self.showDismissButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)showDismissButton:(BOOL)willShow{
    self.dismissButton.hidden = !willShow;
    if (!self.dismissButton && willShow) {
        self.dismissButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 50, 50)];
        [self.dismissButton setImage:[UIImage imageNamed:@"login_back_button"] forState:UIControlStateNormal];
        @weakify(self);
        [[self.dismissButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [self.view addSubview:self.dismissButton];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LoginTextCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (indexPath.row == 0) {
        cell.textField.placeholder = @"用户名";
        cell.textField.secureTextEntry = NO;
    } else if (indexPath.row == 1) {
        cell.textField.placeholder = @"密码";
        cell.textField.secureTextEntry = YES;
    }
    return cell;
}

#pragma mark - TableView Header Footer

- (UIView *) customHeaderView {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, HEADERHEIGHT)];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"login_top_icon"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [headerView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(headerView);
    }];
    return headerView;
}

- (UIView *) customFooterView {
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, FOOTERHEIGHT)];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:ScaleFrom_iPhone5_Desgin(15.0f)];
    loginButton.backgroundColor = [UIColor blueColor];
    loginButton.height = 40;
    loginButton.layer.masksToBounds = YES;
    loginButton.layer.cornerRadius = loginButton.height/2;
//    loginButton.layer.borderWidth = 1.0;
//    loginButton.layer.borderColor = [UIColor greenColor].CGColor;
    [footerView addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(footerView);
        make.width.equalTo(footerView).multipliedBy(3.0f/5.0f);
        make.height.equalTo(@(ScaleFrom_iPhone5_Desgin(40)));
        make.top.equalTo(footerView).offset(FOOTERHEIGHT / 6 - loginButton.height / 2 - 5);
    }];
    
    UIView *loginView = [[UIView alloc ]init];
    [footerView addSubview:loginView];
    [loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(footerView);
        make.height.equalTo(footerView).multipliedBy(2.0f/3.0f);
    }];
    
    UILabel *noticeLabel = [[UILabel alloc] init];
    noticeLabel.text = @"用社交平台登录/注册";
    noticeLabel.textColor = [UIColor darkGrayColor];
    noticeLabel.font = [UIFont systemFontOfSize:ScaleFrom_iPhone5_Desgin(12.0f)];
    [loginView addSubview:noticeLabel];
    [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(loginView);
        make.top.equalTo(loginView).offset(10);
    }];
    
    UIView *leftSeperator = [[UIView alloc] init];
    leftSeperator.backgroundColor = [UIColor grayColor];
    leftSeperator.clipsToBounds = YES;
    [loginView addSubview:leftSeperator];
    [leftSeperator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(noticeLabel);
        make.right.equalTo(noticeLabel.mas_left).offset(-10);
        make.left.equalTo(loginView).offset(20);
        make.height.equalTo(@1);
    }];
    
    UIView *rightSeperator = [[UIView alloc] init];
    rightSeperator.backgroundColor = [UIColor grayColor];
    rightSeperator.clipsToBounds = YES;
    [loginView addSubview:rightSeperator];
    [rightSeperator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(noticeLabel);
        make.right.equalTo(loginView).offset(-20);
        make.left.equalTo(noticeLabel.mas_right).offset(10);
        make.height.equalTo(@1);
    }];
    
    UIButton *sinaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sinaButton setBackgroundImage:[UIImage imageNamed:@"login_sina_icon"] forState:UIControlStateNormal];
    [loginView addSubview:sinaButton];
    [sinaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginView).offset(ScaleFrom_iPhone5_Desgin(50));
        make.centerY.equalTo(loginView);
    }];
    
    UIButton *qqButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [qqButton setBackgroundImage:[UIImage imageNamed:@"login_qq_icon"] forState:UIControlStateNormal];
    [loginView addSubview:qqButton];
    [qqButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(loginView);
    }];
    
    UIButton *wxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [wxButton setBackgroundImage:[UIImage imageNamed:@"login_wx_icon"] forState:UIControlStateNormal];
    [loginView addSubview:wxButton];
    [wxButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(loginView).offset(-ScaleFrom_iPhone5_Desgin(50));
        make.centerY.equalTo(loginView);
    }];
    
    UILabel *copyrightLabel = [[UILabel alloc] init];
    copyrightLabel.text = @"©VMOVIER";
    copyrightLabel.textColor = [UIColor grayColor];
    copyrightLabel.font = [UIFont  systemFontOfSize:ScaleFrom_iPhone5_Desgin(12.0f)];
    [loginView addSubview:copyrightLabel];
    [copyrightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(loginView).offset(-10);
        make.centerX.equalTo(loginView);
    }];
    
      return footerView;
}
@end
