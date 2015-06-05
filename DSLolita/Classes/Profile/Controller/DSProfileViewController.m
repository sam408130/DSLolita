//
//  DSProfileViewController.m
//  DSLolita
//
//  Created by 赛 丁 on 15/5/25.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSProfileViewController.h"
#import "DSSettingViewController.h"
#import "DSCommonGroup.h"
#import "DSCommonItem.h"
#import "DSCommonCell.h"
#import "DSCommonArrowItem.h"
#import "DSCommonSwitchItem.h"
#import "DSCommonLabelItem.h"

@interface DSProfileViewController ()

@property (nonatomic , assign , getter=isLogin ) NSString *login;

@end

@implementation DSProfileViewController

-(NSString *)isLogin {
    
    if ( _login == nil){
        //需要判断当前是否登录
        if ([AVUser currentUser] == nil){
            _login = @"false";
        }else{
            _login = @"true";
        }
    }
    
    return  _login;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationItem];
    
    [self setupGroups];


}


/**
 *  初始化模型数据
 */
- (void)setupGroups
{
    [self setupGroup0];
    [self setupGroup1];
}



- (void)setupGroup0 {
    
    // 1.创建组
    DSCommonGroup *group = [DSCommonGroup group];
    [self.groups addObject:group];
    // 2.设置所有行
    DSCommonArrowItem *newFriend = [DSCommonArrowItem itemWithTitle:@"新的朋友" icon:@"new_friend"];
    newFriend.badgeValue = @"12";
    group.items = @[newFriend];
    
    
    
    
    
}



- (void)setupGroup1 {
    
    // 1.创建组
    DSCommonGroup *group = [DSCommonGroup group];
    [self.groups addObject:group];
    
    // 2.穿建你每一行
    DSCommonArrowItem *album = [DSCommonArrowItem itemWithTitle:@"我的相册" icon:@"album"];
    album.subtitle = @"101";
    
    DSCommonArrowItem *collect = [DSCommonArrowItem itemWithTitle:@"我的收藏" icon:@"collect"];
    collect.subtitle = @"(10)";
    collect.badgeValue = @"1";
    
    DSCommonArrowItem *like = [DSCommonArrowItem itemWithTitle:@"赞" icon:@"like"];
    like.subtitle = @"(36)";
    like.badgeValue = @"10";
    
    group.items = @[album, collect, like];
    
    
}


- (void)setupNavigationItem {
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem BarButtonItemWithTitle:@"设置" style:UIBarButtonItemStyleDone target:self action:@selector(setting)];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem BarButtonItemWithTitle:@"添加朋友" style:UIBarButtonItemStyleDone target:self action:@selector(addFriends)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setting {
    
    DSSettingViewController *setting = [[DSSettingViewController alloc] init];
    [self.navigationController pushViewController:setting animated:YES];
    
}

- (void)addFriends {
    
    NSLog(@"添加朋友");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
