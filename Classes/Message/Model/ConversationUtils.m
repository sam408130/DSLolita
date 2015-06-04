//
//  ConversationUtils.m
//  FreeChat
//
//  Created by Feng Junwen on 3/6/15.
//  Copyright (c) 2015 Feng Junwen. All rights reserved.
//

#import "ConversationUtils.h"
#import "AVUserStore.h"

@implementation ConversationUtils

+(NSString*)getConversationDisplayname:(AVIMConversation*)conversation {
    int memberCount = [conversation.members count];
    AVUser *currentUser = [AVUser currentUser];
    if (memberCount < 1) {
        return conversation.conversationId;
    }
    UserProfile *profile = nil;
    AVUserStore *store = [AVUserStore sharedInstance];
    for (int i = 0; i < memberCount; i++) {
        NSString *tmpUserId = conversation.members[i];
        profile = [store getUserProfile:tmpUserId];
        if (profile.nickname.length > 0 && [tmpUserId compare:currentUser.objectId] != NSOrderedSame) {
            return profile.nickname;
        }
    }
    return nil;
}

@end
