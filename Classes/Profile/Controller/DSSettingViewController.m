//
//  DSSettingViewController.m
//  DSLolita
//
//  Created by 赛 丁 on 15/6/1.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSSettingViewController.h"
#import "DSCommonGroup.h"
#import "DSCommonItem.h"
#import "DSCommonArrowItem.h"
#import "DSCommonSwitchItem.h"
#import "DSCommonLabelItem.h"
#import "DSGeneralSettingViewController.h"
#import "LoginViewController.h"
@interface DSSettingViewController ()

@end






@implementation DSSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    
    [self setupGroups];
    
    [self setupFooter];
    
}

- (void)setupFooter {
    
    // 1.创建按钮
    UIButton *logout = [[UIButton alloc] init];
    
    // 2.设置属性
    logout.titleLabel.font = [UIFont systemFontOfSize:14];
    [logout setTitle:@"退出当前账号" forState:UIControlStateNormal];
    [logout setTitleColor:DSColor(255, 10, 10) forState:UIControlStateNormal];
    [logout setBackgroundImage:[UIImage resizableImageWithName:@"common_card_background"] forState:UIControlStateNormal];
    [logout setBackgroundImage:[UIImage resizableImageWithName:@"common_card_background_highlighted"] forState:UIControlStateHighlighted];
    [logout addTarget:self action:@selector(logoutClicked) forControlEvents:UIControlEventTouchUpInside];
    
    // 3.设置尺寸
    logout.height = 35;
    
    self.tableView.tableFooterView = logout;
    
}


- (void)logoutClicked{
    
    [AVUser logOut];

    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginVc = (LoginViewController *)[main instantiateInitialViewController];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = loginVc;

}


// 初始化模型数据
- (void)setupGroups {
    [self setupGroup0];
    [self setupGroup1];
    [self setupGroup2];
}


- (void)setupGroup0 {
    
    // 1.创建组
    DSCommonGroup *group = [DSCommonGroup group];
    group.footer = @"";
    [self.groups addObject:group];
    
    // 2.设置组的所有行
    DSCommonArrowItem *newFriend = [DSCommonArrowItem itemWithTitle:@"账号管理"];
    group.items = @[newFriend];
}



- (void)setupGroup1
{
    // 1.创建组
    DSCommonGroup *group = [DSCommonGroup group];
    [self.groups addObject:group];
    
    // 2.设置组的所有行数据
    DSCommonArrowItem *newFriend = [DSCommonArrowItem itemWithTitle:@"主题、背景"];
    
    group.items = @[newFriend];
}

- (void)setupGroup2
{
    // 1.创建组
    DSCommonGroup *group = [DSCommonGroup group];
    group.header = @"头部";
    [self.groups addObject:group];
    
    // 2.设置组的所有行数据
    DSCommonArrowItem *generalSetting = [DSCommonArrowItem itemWithTitle:@"通用设置"];
    generalSetting.destVcClass = [DSGeneralSettingViewController class];
    
    group.items = @[generalSetting];
}




@end
