//
//  DSChatRoomVC.h
//  DSLolita
//
//  Created by 赛 丁 on 15/6/5.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "XHMessageTableViewController.h"
#import <AVOSCloudIM/AVOSCloudIM.h>

@interface DSChatRoomVC : XHMessageTableViewController

@property (nonatomic,strong) AVIMConversation* conv;

-(instancetype)initWithConv:(AVIMConversation*)conv;

@end
