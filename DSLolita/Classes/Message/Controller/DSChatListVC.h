//
//  DSChatListVC.h
//  DSLolita
//
//  Created by 赛 丁 on 15/6/5.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "MCBaseTC.h"
#import "AVIMConversation+Custom.h"

@class DSChatListVC;

@protocol DSChatListVCDelegate <NSObject>

-(void)setBadgeWithTotalUnreadCount:(NSInteger)totalUnreadCount;

-(void)viewController:(UIViewController*)viewController didSelectConv:(AVIMConversation*)conv;

@end

@interface DSChatListVC : MCBaseTC

@property (nonatomic,strong) id<DSChatListVCDelegate> chatListDelegate;

@end
