//
//  MessagePersister.h
//  FreeChat
//
//  Created by Feng Junwen on 3/4/15.
//  Copyright (c) 2015 Feng Junwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Message.h"
#import "Constrains.h"

@protocol MessagePersister <NSObject>

@optional
- (void)pushMessage:(Message*)message;

- (void)pullMessagesForConversation:(AVIMConversation*)conversation preceded:(NSString*)lastMessageId timestamp:(int64_t)timestamp limit:(int)limit callback:(ArrayResultBlock)block;

@end
