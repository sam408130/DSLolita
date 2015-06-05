//
//  DSCache.h
//  DSLolita
//
//  Created by 赛 丁 on 15/6/5.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DSCache : NSObject

+ (void)registerUsers:(NSArray*)users;

+ (void)registerUser:(AVUser*)user;

+ (AVUser *)lookupUser:(NSString*)userId;

+(AVIMConversation*)lookupConvById:(NSString*)convid;

+(void)registerConv:(AVIMConversation*)conv;

+(void)cacheUsersWithIds:(NSSet*)userIds callback:(AVBooleanResultBlock)callback;

+(void)cacheConvsWithIds:(NSMutableSet*)convids callback:(AVArrayResultBlock)callback;

+(void)registerConvs:(NSArray*)convs;

#pragma mark - current conv

+(void)setCurConv:(AVIMConversation*)conv;

+(AVIMConversation*)getCurConv;

+(void)refreshCurConv:(AVBooleanResultBlock)callback;

+(void)cacheAndFillRooms:(NSMutableArray*)rooms callback:(AVBooleanResultBlock)callback;

@end
