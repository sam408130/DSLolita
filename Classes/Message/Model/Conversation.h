//
//  Conversation.h
//  FreeChat
//
//  Created by Feng Junwen on 2/5/15.
//  Copyright (c) 2015 Feng Junwen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVOSCloudIM/AVOSCloudIM.h"

@interface Conversation : NSObject

@property (nonatomic, copy) NSString* convId;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, strong) NSArray* members;
@property (nonatomic, strong) AVIMConversation *imConversation;

- (instancetype)initWithAVIMConversation:(AVIMConversation*)conversation;

@end
