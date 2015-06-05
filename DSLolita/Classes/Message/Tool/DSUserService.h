//
//  DSUserService.h
//  DSLolita
//
//  Created by 赛 丁 on 15/6/5.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSAddRequest.h"
#import "DSAbuseReport.h"

@interface DSUserService : NSObject

+(void)findFriendsWithBlock:(AVArrayResultBlock)block;

+(void)isMyFriend:(AVUser*)user block:(AVBooleanResultBlock)block;

+(void)findUsersByPartname:(NSString*)partName withBlock:(AVArrayResultBlock)block;

+(NSString*)getPeerIdOfUser:(AVUser*)user;

+(void)findUsersByIds:(NSArray*)userIds callback:(AVArrayResultBlock)callback;

+(void)displayAvatarOfUser:(AVUser*)user avatarView:(UIImageView*)avatarView;

+(void)getAvatarImageOfUser:(AVUser*)user block:(void (^)(UIImage* image))block;

+(void)displayBigAvatarOfUser:(AVUser*)user avatarView:(UIImageView*)avatarView;

+(void)saveAvatar:(UIImage*)image callback:(AVBooleanResultBlock)callback;

+(void)addFriend:(AVUser*)user callback:(AVBooleanResultBlock)callback;

+(void)removeFriend:(AVUser*)user callback:(AVBooleanResultBlock)callback;

+(void)countAddRequestsWithBlock:(AVIntegerResultBlock)block;

+(void)findAddRequestsWithBlock:(AVArrayResultBlock)block;

+(void)agreeAddRequest:(DSAddRequest*)addRequest callback:(AVBooleanResultBlock)callback;

+(void)tryCreateAddRequestWithToUser:(AVUser*)user callback:(AVBooleanResultBlock)callback;

+(void)reportAbuseWithReason:(NSString*)reason convid:(NSString*)convid block:(AVBooleanResultBlock)block;

@end