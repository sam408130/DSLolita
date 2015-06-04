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


@interface DSTabBarController () <DSTabBarDelegate,AVIMClientDelegate>

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
    
    // 添加私聊
    [self setupConversations];
    
}


- (void)getUnreadCount {
 
    
    
}


- (void)setupConversations{
    
    AVUser *currentUser = [AVUser currentUser];
    AVIMClient *imclient = [[AVIMClient alloc] init];
    imclient.delegate = self;
    NSLog(@"open AVIMClient");
    [imclient openWithClientId:currentUser.objectId callback:^(BOOL succeed , NSError *error){
        if (error){
            NSLog(@"聊天不可用");
        }else{
            ConversationStore *store = [ConversationStore sharedInstance];
            store.imClient = imclient;
            [store reviveFromLocal:currentUser];
        }
        
    }];
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
    DSMessageViewController *message = [[DSMessageViewController alloc] init];
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
    DSNavigationController *nav = [[DSNavigationController alloc] initWithRootViewController:compose];
    [self presentViewController:nav animated:YES completion:nil];
}


#pragma AVIMClientDelegate
/*!
 当前聊天状态被暂停，常见于网络断开时触发。
 */
- (void)imClientPaused:(AVIMClient *)imClient {
    ConversationStore *store = [ConversationStore sharedInstance];
    store.networkAvailable = NO;
}

/*!
 当前聊天状态开始恢复，常见于网络断开后开始重新连接。
 */
- (void)imClientResuming:(AVIMClient *)imClient {
}
/*!
 当前聊天状态已经恢复，常见于网络断开后重新连接上。
 */
- (void)imClientResumed:(AVIMClient *)imClient {
    ConversationStore *store = [ConversationStore sharedInstance];
    store.networkAvailable = YES;
}

/*!
 接收到新的普通消息。
 @param conversation － 所属对话
 @param message - 具体的消息
 @return None.
 */
- (void)conversation:(AVIMConversation *)conversation didReceiveCommonMessage:(AVIMMessage *)message {
    ConversationStore *store = [ConversationStore sharedInstance];
    [store newMessageArrived:message conversation:conversation];
}

/*!
 接收到新的富媒体消息。
 @param conversation － 所属对话
 @param message - 具体的消息
 @return None.
 */
- (void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message {
    ConversationStore *store = [ConversationStore sharedInstance];
    [store newMessageArrived:message conversation:conversation];
}

/*!
 消息已投递给对方。
 @param conversation － 所属对话
 @param message - 具体的消息
 @return None.
 */
- (void)conversation:(AVIMConversation *)conversation messageDelivered:(AVIMMessage *)message {
    ConversationStore *store = [ConversationStore sharedInstance];
    [store messageDelivered:message conversation:conversation];
}

/*!
 对话中有新成员加入的通知。
 @param conversation － 所属对话
 @param clientIds - 加入的新成员列表
 @param clientId - 邀请者的 id
 @return None.
 */
- (void)conversation:(AVIMConversation *)conversation membersAdded:(NSArray *)clientIds byClientId:(NSString *)clientId {
    if ([clientId compare:[[AVUser currentUser] objectId]] == NSOrderedSame) {
        // A 邀请 B 加入对话，LeanCloud 云端也会给 A 发送成员增加通知。这时候 clientId 等于 A 的 userId。
    }
    
    ConversationStore *store = [ConversationStore sharedInstance];
    [store newConversationEvent:EventMemberAdd conversation:conversation from:clientId to:clientIds];
}

/*!
 对话中有成员离开的通知。
 @param conversation － 所属对话
 @param clientIds - 离开的成员列表
 @param clientId - 操作者的 id
 @return None.
 */
- (void)conversation:(AVIMConversation *)conversation membersRemoved:(NSArray *)clientIds byClientId:(NSString *)clientId {
    if ([clientId compare:[[AVUser currentUser] objectId]] == NSOrderedSame) {
        // A 将 B 踢出对话，LeanCloud 云端也会给 A 发送通知。这时候 clientId 等于 A 的 userId。
    }
    
    ConversationStore *store = [ConversationStore sharedInstance];
    [store newConversationEvent:EventMemberRemove conversation:conversation from:clientId to:clientIds];
}

/*!
 被邀请加入对话的通知。
 @param conversation － 所属对话
 @param clientId - 邀请者的 id
 @return None.
 */
- (void)conversation:(AVIMConversation *)conversation invitedByClientId:(NSString *)clientId {
    if ([clientId compare:[[AVUser currentUser] objectId]] == NSOrderedSame) {
        // A 邀请 B 加入对话，LeanCloud 云端也会给 A 发送邀请通知。这时候 clientId 等于 A 的 userId。
        // 这种消息无需处理。
        return;
    }
    ConversationStore *store = [ConversationStore sharedInstance];
    [store newConversationEvent:EventInvited conversation:conversation from:clientId to:nil];
}

/*!
 从对话中被移除的通知。
 @param conversation － 所属对话
 @param clientId - 操作者的 id
 @return None.
 */
- (void)conversation:(AVIMConversation *)conversation kickedByClientId:(NSString *)clientId {
    if ([clientId compare:[[AVUser currentUser] objectId]] == NSOrderedSame) {
        // 自己退出的场合，忽略这一事件
        return;
    }
    ConversationStore *store = [ConversationStore sharedInstance];
    [store newConversationEvent:EventKicked conversation:conversation from:clientId to:nil];
}




@end
