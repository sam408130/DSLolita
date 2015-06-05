//
//  DSStorage.h
//  DSLolita
//
//  Created by 赛 丁 on 15/6/5.
//  Copyright (c) 2015年 samDing. All rights reserved.
//


#import "FMDB.h"
#import "DSRoom.h"

@interface DSStorage : NSObject

+(instancetype)sharedInstance;

-(void)close;

-(void)setupWithUserId:(NSString*)userId;

-(NSArray*)getMsgsWithConvid:(NSString*)convid maxTime:(int64_t)time limit:(int)limit;

-(int64_t)insertMsg:(AVIMTypedMessage*)msg;

-(BOOL)updateStatus:(AVIMMessageStatus)status byMsgId:(NSString*)msgId;

-(BOOL)updateFailedMsg:(AVIMTypedMessage*)msg byTmpId:(NSString*)tmpId;

-(void)deleteMsgsByConvid:(NSString*)convid;

-(NSArray*)getRooms;

-(NSInteger)countUnread;

-(void)insertRoomWithConvid:(NSString*)convid;

-(void)deleteRoomByConvid:(NSString*)convid;

-(void)incrementUnreadWithConvid:(NSString*)convid;

-(void)clearUnreadWithConvid:(NSString*)convid;


@end
