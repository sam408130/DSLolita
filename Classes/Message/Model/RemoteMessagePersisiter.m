//
//  RemoteMessagePersisiter.m
//  FreeChat
//
//  Created by Feng Junwen on 3/4/15.
//  Copyright (c) 2015 Feng Junwen. All rights reserved.
//

#import "RemoteMessagePersisiter.h"

@implementation RemoteMessagePersisiter

+(instancetype)sharedInstance {
    static RemoteMessagePersisiter *_persister = nil;
    if (nil == _persister) {
        _persister = [[RemoteMessagePersisiter alloc] init];
    }
    return _persister;
}

- (void)pullMessagesForConversation:(AVIMConversation*)conversation preceded:(NSString*)lastMessageId timestamp:(int64_t)timestamp limit:(int)limit callback:(ArrayResultBlock)block {
    [conversation queryMessagesBeforeId:lastMessageId timestamp:timestamp limit:limit callback:^(NSArray *objects, NSError *error) {
        NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:[objects count]];
        int objectCount = [objects count];
        for (int i = 0; i < objectCount; i++) {
            Message *msg = [[Message alloc] initWithAVIMMessage:objects[i]];
            [result addObject:msg];
        }
        if (block) {
            block(result, error);
        }
    }];
}

@end
