//
//  DSTabBarController.m
//  DSLolita
//
//  Created by 赛 丁 on 15/5/25.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSTabBarController.h"
#import "DSHomeViewController.h"
#import "DSMessageViewController.h"
#import "DSDiscoverViewController.h"
#import "DSProfileViewController.h"
#import "DSNavigationController.h"
#import "DSComposeViewController.h"
#import "DSTabBar.h"
#import "DSConvsVC.h"


@interface DSTabBarController () <DSTabBarDelegate>

@property (nonatomic , weak)DSHomeViewController *homeViewController;
@property (nonatomic , weak)DSMessageViewController *messageViewController;
@property (nonatomic , weak)DSProfileViewController *profileViewController;

@end

@implementation DSTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    //1.添加所有的自控制器
    [self addAllChildVcs];
    
    //2.创建自定义tabbar
    [self addCustomTabBar];
    
    //3.设置用户信息为读书 （利用定时器获取用户未读数）
    [self getUnreadCount];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(getUnreadCount) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    [self openClient];
    
}

- (void)openClient{
    AVUser *currentUser = [AVUser currentUser];
    [DSCache registerUser:currentUser];
    DSIM *im = [DSIM sharedInstance];
    WEAKSELF
    [DSUtils showNetworkIndicator];
    [DSIMConfig config].userDelegate = [DSIMService shareInstance];
    [im openWithClientId:currentUser.objectId callback:^(BOOL succeeded , NSError *error){
        [DSUtils hideNetworkIndicator];
        
    }];
}


- (void)getUnreadCount {
 
    
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//创建自定义tabbar

- (void)addCustomTabBar {
    
    //创建自定义tabbar
    DSTabBar *customTabBar = [[DSTabBar alloc] init];
    customTabBar.tabBarDelegate = self;
    
    //更换系统自带的tabbar
    [self setValue:customTabBar forKey:@"tabBar"];
    
}


/**
 *  添加一个子控制器
 *
 *  @param childVc           子控制器对象
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */

- (void)addOneChildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName {
    
    //childVc.view.backgroundColor = DSRandomColor;
    
    //设置标题
    childVc.title = title;
    if ([childVc class] == [DSDiscoverViewController class]){
        childVc.navigationItem.title = @"Lolita社区";
    }
    
    //设置图标
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    
    //设置选中图标
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    if (iOS7) {
        //声明这张图用原图
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    childVc.tabBarItem.selectedImage = selectedImage;
    
    //添加导航控制器
    DSNavigationController *nav = [[DSNavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];


}


- (void)addAllChildVcs
{
    
    DSHomeViewController *home = [[DSHomeViewController alloc] init];
    [self addOneChildVc:home title:@"首页" imageName:@"tabbar_home" selectedImageName:@"tabbar_home_selected"];
    _homeViewController = home;
    DSConvsVC *message = [[DSConvsVC alloc] init];
    [self addOneChildVc:message title:@"消息" imageName:@"tabbar_message_center" selectedImageName:@"tabbar_message_center_selected"];
    _messageViewController = message;
    DSDiscoverViewController *discover = [[DSDiscoverViewController alloc] init];
    [self addOneChildVc:discover title:@"发现" imageName:@"tabbar_discover" selectedImageName:@"tabbar_discover_selected"];
    DSProfileViewController *profile = [[DSProfileViewController alloc] init];
    [self addOneChildVc:profile title:@"我" imageName:@"tabbar_profile" selectedImageName:@"tabbar_profile_selected"];
    _profileViewController = profile;
}




// 在iOS7中, 会对selectedImage的图片进行再次渲染为蓝色
// 要想显示原图, 就必须得告诉它: 不要渲染

// Xcode的插件安装路径: /Users/用户名/Library/Application Support/Developer/Shared/Xcode/Plug-ins

/**
 *  默认只调用该功能一次
 */

+ (void)initialize
{
    //设置底部tabbar的主题样式
    UITabBarItem *appearance = [UITabBarItem appearance];
    [appearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:DSCommonColor, NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
}



#pragma mark - DSTabBarDelegate
- (void)tabBarDidClickedPlusButton:(DSTabBar *)tabBar
{
    // 弹出发微博控制器
    DSComposeViewController *compose = [[DSComposeViewController alloc] init];
    compose.source = @"compose";
    compose.homeVc = self.homeViewController;
    DSNavigationController *nav = [[DSNavigationController alloc] initWithRootViewController:compose];
    [self presentViewController:nav animated:YES completion:nil];
}




@end
