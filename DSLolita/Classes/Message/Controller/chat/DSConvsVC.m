//
//  DSConvsVC.m
//  DSLolita
//
//  Created by 赛 丁 on 15/6/5.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSConvsVC.h"
#import "DSUtils.h"
#import "DSIMService.h"

@interface DSConvsVC ()<DSChatListVCDelegate>

@end

@implementation DSConvsVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"消息";
        self.tabBarItem.image = [UIImage imageNamed:@"tabbar_profile_highlighted"];
        self.chatListDelegate=self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewController:(UIViewController *)viewController didSelectConv:(AVIMConversation *)conv{
    [[DSIMService shareInstance] goWithConv:conv fromNav:viewController.navigationController];
}

-(void)setBadgeWithTotalUnreadCount:(NSInteger)totalUnreadCount{
    if(totalUnreadCount>0){
        self.tabBarItem.badgeValue=[NSString stringWithFormat:@"%ld",(long)totalUnreadCount];
    }else{
        self.tabBarItem.badgeValue=nil;
    }
}

@end