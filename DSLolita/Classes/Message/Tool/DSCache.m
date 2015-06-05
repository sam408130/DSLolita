//
//  DSCache.m
//  DSLolita
//
//  Created by 赛 丁 on 15/6/5.
//  Copyright (c) 2015年 samDing. All rights reserved.
//
#import "DSCache.h"
#import "DSUtils.h"
#import "DSUserService.h"

@implementation DSCache

static NSMutableDictionary *cachedConvs;
static NSMutableDictionary *cachedUsers;
static AVIMConversation* curConv;
static DSIM* _im;

+(void)initialize{
    [super initialize];
    cachedConvs=[[NSMutableDictionary alloc] init];
    cachedUsers=[[NSMutableDictionary alloc] init];
    _im=[DSIM sharedInstance];
}

#pragma mark - user cache

+ (void)registerUsers:(NSArray*)users{
    for(int i=0;i<users.count;i++){
        [self registerUser:[users objectAtIndex:i]];
    }
}

+(void) registerUser:(AVUser*)user{
    [cachedUsers setObject:user forKey:user.objectId];
}

+(AVUser *)lookupUser:(NSString*)userId{
    return [cachedUsers valueForKey:userId];
}

#pragma mark - group cache

+(AVIMConversation*)lookupConvById:(NSString*)convid{
    return [cachedConvs valueForKey:convid];
}

+(void)registerConv:(AVIMConversation*)conv{
    [cachedConvs setObject:conv forKey:conv.conversationId];
}

+(void)registerConvs:(NSArray*)convs{
    for(AVIMConversation* conv in convs){
        [self registerConv:conv];
    }
}

+(void)cacheConvsWithIds:(NSMutableSet*)convids callback:(AVArrayResultBlock)callback{
    NSMutableSet* uncacheConvids=[[NSMutableSet alloc] init];
    for(NSString * convid in convids){
        if([self lookupConvById:convid]==nil){
            [uncacheConvids addObject:convid];
        }
    }
    [_im fetchConvsWithConvids:uncacheConvids callback:^(NSArray *objects, NSError *error) {
        [DSUtils filterError:error callback:^{
            for(AVIMConversation* conv in objects){
                [self registerConv:conv];
            }
            callback(objects,error);
        }];
    }];
}

+(void)cacheUsersWithIds:(NSSet*)userIds callback:(AVBooleanResultBlock)callback{
    NSMutableSet* uncachedUserIds=[[NSMutableSet alloc] init];
    for(NSString* userId in userIds){
        if([self lookupUser:userId]==nil){
            [uncachedUserIds addObject:userId];
        }
    }
    if([uncachedUserIds count]>0){
        [DSUserService findUsersByIds:[[NSMutableArray alloc] initWithArray:[uncachedUserIds allObjects]] callback:^(NSArray *objects, NSError *error) {
            if(objects){
                [self registerUsers:objects];
            }
            callback(YES,error);
        }];
    }else{
        callback(YES,nil);
    }
}

#pragma mark - current cache group

+(void)setCurConv:(AVIMConversation*)conv{
    curConv=conv;
}

+(AVIMConversation*)getCurConv{
    return curConv;
}

+(void)refreshCurConv:(AVBooleanResultBlock)callback{
    if(curConv!=nil){
        DSIM* im=[DSIM sharedInstance];
        [im fecthConvWithId:curConv.conversationId callback:^(AVIMConversation *conversation, NSError *error) {
            if(error){
                callback(NO,error);
            }else{
                [self setCurConv:conversation];
                [[DSNotify sharedInstance] postConvNotify];
                callback(YES,nil);
            }
        }];
    }else{
        callback(NO,[NSError errorWithDomain:nil code:0 userInfo:@{NSLocalizedDescriptionKey:@"current conv is nil"}]);
    }
}

#pragma mark - rooms

+(void)cacheAndFillRooms:(NSMutableArray*)rooms callback:(AVBooleanResultBlock)callback{
    NSMutableSet* convids=[NSMutableSet set];
    for(DSRoom* room in rooms){
        [convids addObject:room.convid];
    }
    [DSCache cacheConvsWithIds:convids callback:^(NSArray *objects, NSError *error) {
        if(error){
            callback(NO,error);
        }else{
            for(DSRoom * room in rooms){
                room.conv=[DSCache lookupConvById:room.convid];
                if(room.conv==nil){
                    [NSException raise:@"not found conv" format:nil];
                }
            }
            NSMutableSet* userIds=[NSMutableSet set];
            for(DSRoom* room in rooms){
                if(room.conv.type==DSConvTypeSingle){
                    [userIds addObject:room.conv.otherId];
                }
            }
            [DSCache cacheUsersWithIds:userIds callback:callback];
        }
    }];
}

@end
