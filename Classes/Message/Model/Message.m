//
//  Message.m
//  FreeChat
//
//  Created by Feng Junwen on 2/5/15.
//  Copyright (c) 2015 Feng Junwen. All rights reserved.
//

#import "Message.h"
#import "AVUserStore.h"

#define kCoderKey_EventType @"eventType"
#define kCoderKey_ConvId    @"conversationId"
#define kCoderKey_IMMessage @"rawMessage"
#define kCoderKey_ByClient  @"messageFrom"
#define kCoderKey_ClientArray @"convClients"
#define kCoderKey_SentTimestamp @"sentTimestamp"

@implementation Message

- (id)copyWithZone:(NSZone *)zone {
    Message *copy = [[[self class] allocWithZone:zone] init];
    copy.eventType = self.eventType;
    copy.convId = [self.convId copyWithZone:zone];
    copy.imMessage = [self.imMessage copyWithZone:zone];
    copy.byClient = [self.byClient copyWithZone:zone];
    copy.clients = [self.clients copyWithZone:zone];
    copy.sentTimestamp = self.sentTimestamp;
    return copy;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInt:self.eventType forKey:kCoderKey_EventType];
    [aCoder encodeObject:self.convId forKey:kCoderKey_ConvId];
    [aCoder encodeObject:self.imMessage forKey:kCoderKey_IMMessage];
    [aCoder encodeObject:self.byClient forKey:kCoderKey_ByClient];
    [aCoder encodeObject:self.clients forKey:kCoderKey_ClientArray];
    [aCoder encodeInt64:self.sentTimestamp forKey:kCoderKey_SentTimestamp];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.eventType = [aDecoder decodeIntForKey:kCoderKey_EventType];
        self.convId = [aDecoder decodeObjectForKey:kCoderKey_ConvId];
        self.imMessage = [aDecoder decodeObjectForKey:kCoderKey_IMMessage];
        self.byClient = [aDecoder decodeObjectForKey:kCoderKey_ByClient];
        self.clients = [aDecoder decodeObjectForKey:kCoderKey_ClientArray];
        self.sentTimestamp = [aDecoder decodeInt64ForKey:kCoderKey_SentTimestamp];
    }
    return self;
}

- (id)initWithAVIMMessage:(AVIMMessage*)message {
    self = [super init];
    if (self) {
        self.eventType = CommonMessage;
        self.convId = message.conversationId;
        self.imMessage = message;
        self.byClient = message.clientId;
        self.sentTimestamp = message.sendTimestamp;
        self.clients = nil;
    }
    return self;
}

+ (NSString*)getNotificationContent:(Message*)message {
    NSString *notificationText = nil;
    AVUserStore *store = [AVUserStore sharedInstance];
    UserProfile *objectProfile = [store getUserProfile:message.byClient];
    int memberCount = message.clients.count;
    switch (message.eventType) {
        case EventInvited:
            notificationText = [NSString stringWithFormat:@"%@ 邀请你加入", objectProfile.nickname];
            break;
        case EventKicked:
            notificationText = [NSString stringWithFormat:@"%@ 剔除了你", objectProfile.nickname];
            break;
        case EventMemberAdd:
            notificationText = [NSString stringWithFormat:@"%@ 邀请 ", objectProfile.nickname];
            for (int i = 0; i < memberCount; i++) {
                UserProfile *tmp = [store getUserProfile:message.clients[i]];
                if (i == memberCount - 1) {
                    notificationText = [notificationText stringByAppendingString:[NSString stringWithFormat:@"%@ 加入", tmp.nickname]];
                } else {
                    notificationText = [notificationText stringByAppendingString:[NSString stringWithFormat:@"%@,", tmp.nickname]];
                }
            }
            break;
        case EventMemberRemove:
            notificationText = [NSString stringWithFormat:@"%@ 剔除了 ", objectProfile.nickname];
            for (int i = 0; i < memberCount; i++) {
                UserProfile *tmp = [store getUserProfile:message.clients[i]];
                if (i == memberCount - 1) {
                    notificationText = [notificationText stringByAppendingString:[NSString stringWithFormat:@"%@", tmp.nickname]];
                } else {
                    notificationText = [notificationText stringByAppendingString:[NSString stringWithFormat:@"%@,", tmp.nickname]];
                }
            }
            break;
        default:
            break;
    }
    return notificationText;
}

@end
