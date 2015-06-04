//
//  ConversationStore.h
//  FreeChat
//
//  Created by Feng Junwen on 2/5/15.
//  Copyright (c) 2015 Feng Junwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AVOSCloudIM/AVOSCloudIM.h"
#import "Message.h"
#import "Constrains.h"


@protocol IMEventObserver <NSObject>

- (void)newMessageArrived:(Message*)message conversation:(AVIMConversation*)conversation;
- (void)messageDelivered:(Message*)message conversation:(AVIMConversation*)conversation;

@end

@protocol ConversationOperationDelegate <NSObject>

@optional
-(void)addMembers:(NSArray*)clients conversation:(AVIMConversation*)conversation;
-(void)kickoffMembers:(NSArray*)client conversation:(AVIMConversation*)conversation;
-(void)mute:(BOOL)on conversation:(AVIMConversation*)conversation;
-(void)changeName:(NSString*)newName conversation:(AVIMConversation*)conversation;
-(void)exitConversation:(AVIMConversation*)conversation;
-(void)switch2NewConversation:(AVIMConversation*)conversation;

@end

@interface ConversationStore : NSObject

@property (nonatomic, strong) AVIMClient *imClient;
@property (nonatomic) BOOL networkAvailable;

+(instancetype)sharedInstance;

-(void)reviveFromLocal:(AVUser*)user;
-(void)dump2Local:(AVUser*)user;

// 打开了某对话
- (void)openConversation:(AVIMConversation*)conversation;
- (void)quitConversation:(AVIMConversation*)conversation;

// 获取最近对话列表
- (NSArray*)recentConversations;

// 获取某个对话的更多消息
- (void)queryMoreMessages:(AVIMConversation*)conversation from:(NSString*)msgId timestamp:(int64_t)ts limit:(int)limit callback:(ArrayResultBlock)callback;

// 新消息到达
- (void)newMessageSent:(AVIMMessage*)message conversation:(AVIMConversation*)conv;
- (void)newMessageArrived:(AVIMMessage*)message conversation:(AVIMConversation*)conv;
- (void)messageDelivered:(AVIMMessage*)message conversation:(AVIMConversation*)conv;
// 对话中新的事件发生
- (void)newConversationEvent:(IMMessageType)event conversation:(AVIMConversation*)conv from:(NSString*)clientId to:(NSArray*)clientIds;

// 获取对话中未读消息数量
- (int)conversationUnreadCount:(NSString*)conversationId;

- (void)addEventObserver:(id<IMEventObserver>)observer forConversation:(NSString*)conversationId;
- (void)removeEventObserver:(id<IMEventObserver>)observer forConversation:(NSString*)conversationId;

@end
