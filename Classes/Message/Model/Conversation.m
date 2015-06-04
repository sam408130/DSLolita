//
//  Conversation.m
//  FreeChat
//
//  Created by Feng Junwen on 2/5/15.
//  Copyright (c) 2015 Feng Junwen. All rights reserved.
//

#import "Conversation.h"

@implementation Conversation

- (instancetype)initWithAVIMConversation:(AVIMConversation*)conversation {
    self = [super init];
    if (self) {
        self.imConversation = conversation;
        self.title = conversation.name;
        self.members = conversation.members;
        self.convId = conversation.conversationId;
    }
    return self;
}

@end
