//
//  ChatViewController.h
//  FreeChat
//
//  Created by Feng Junwen on 2/3/15.
//  Copyright (c) 2015 Feng Junwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConversationStore.h"
#import "UUInputFunctionView.h"

@interface ChatViewController : UIViewController

@property (nonatomic, strong) AVIMConversation *conversation;

@end
