//
//  DSMessageViewController.h
//  DSLolita
//
//  Created by 赛 丁 on 15/5/25.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConversationStore.h"
#import "DSCommonTableViewController.h"

@interface DSMessageViewController : UITableViewController

@property (nonatomic , strong) NSMutableArray *recentConversations;

@end
