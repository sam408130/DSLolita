//
//  SQLiteMessagePersister.m
//  FreeChat
//
//  Created by Feng Junwen on 3/4/15.
//  Copyright (c) 2015 Feng Junwen. All rights reserved.
//

#import "SQLiteMessagePersister.h"
#import "FMDB.h"

// msgId
// timestamp
// convId
// msgType
// content
#define CREATE_MSG_TABLE_SQL @"CREATE TABLE IF NOT EXISTS `msgs` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `msg_id` VARCHAR(64) NOT NULL,`convid` VARCHAR(64) NOT NULL,`object` BLOB,`timestamp` BIGINT NOT NULL, `type` INT NOT NULL, `from` VARCHAT(64), `toClients` BLOB)"

#define CREATE_MSG_UNIQUE_INDEX_SQL @"CREATE UNIQUE INDEX IF NOT EXISTS `msg_index` ON `msgs` (`convid`,`timestamp`,`msg_id`)"

#define INSERT_MSG_SQL @"INSERT INTO `msgs`(`msg_id`, `convid`, `object`, `timestamp`, `type`, `from`, `toClients`) VALUES(?, ?, ?, ?, ?, ?, ?)"

#define QUERY_MSG_SQL @"SELECT * from msgs where convid=? and timestamp<? order by timestamp limit ?"

#define COLUMN_NAME_MSGID     @"msg_id"
#define COLUMN_NAME_CONVID    @"convid"
#define COLUMN_NAME_TIMESTAMP @"timestamp"
#define COLUMN_NAME_OBJECT    @"object"
#define COLUMN_NAME_TYPE      @"type"
#define COLUMN_NAME_FROM      @"from"
#define COLUMN_NAME_TO        @"toClients"

#define FAKE_MSG_ID @"zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz"

@interface SQLiteMessagePersister () {
    FMDatabaseQueue* _dbQueue;
}

@end

@implementation SQLiteMessagePersister

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

+(instancetype)sharedInstance {
    static SQLiteMessagePersister *_persister = nil;
    if (nil == _persister) {
        _persister = [[SQLiteMessagePersister alloc] init];
    }
    return _persister;
}

- (void)open:(AVUser *)user {
    _dbQueue=[FMDatabaseQueue databaseQueueWithPath:[self dbPathWithUserId:user.objectId]];
    [_dbQueue inDatabase:^(FMDatabase *db) {
         db.logsErrors = NO;
        [db executeUpdate:CREATE_MSG_TABLE_SQL];
        [db executeUpdate:CREATE_MSG_UNIQUE_INDEX_SQL];
    }];
}

-(void)close {
    [_dbQueue close];
}

- (void)pushMessage:(Message*)message {
    [_dbQueue inDatabase:^(FMDatabase *db) {
        db.logsErrors = NO;
        NSString *msgId = [message.imMessage messageId];
        if ([msgId length] < 1) {
            msgId = FAKE_MSG_ID;
        }
        NSData* msgRawData=[NSKeyedArchiver archivedDataWithRootObject:message.imMessage];
        NSData* msgClientsData = [NSKeyedArchiver archivedDataWithRootObject:message.clients];
        BOOL result = [db executeUpdate:INSERT_MSG_SQL
                   withArgumentsInArray:@[msgId, message.convId, msgRawData,
                                          [NSNumber numberWithLongLong:message.sentTimestamp],
                                          [NSNumber numberWithInt:message.eventType],
                                          message.byClient, msgClientsData]];
        if (!result) {
            //NSLog(@"failed to insert message to sqlite");
        } else {
            //NSLog(@"cache message. id=%@, convId=%@, ts=%lli", message.imMessage.messageId, message.convId, message.sentTimestamp);
        }
    }];
}

- (void)pullMessagesForConversation:(AVIMConversation*)conversation preceded:(NSString*)lastMessageId timestamp:(int64_t)timestamp limit:(int)limit callback:(ArrayResultBlock)block{
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet* rs = [db executeQuery:QUERY_MSG_SQL
                      withArgumentsInArray:@[conversation.conversationId,@(timestamp), @(limit)]];
        NSMutableArray *result = [NSMutableArray array];
        while ([rs next]) {
            Message *message  = [[Message alloc] init];
            message.convId = [rs stringForColumn:COLUMN_NAME_CONVID];
            message.eventType = [rs intForColumn:COLUMN_NAME_TYPE];
            message.sentTimestamp = [rs longLongIntForColumn:COLUMN_NAME_TIMESTAMP];
            message.byClient = [rs stringForColumn:COLUMN_NAME_FROM];
            NSData *data = [rs dataForColumn:COLUMN_NAME_OBJECT];
            if (data) {
                message.imMessage = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            }
            data = [rs dataForColumn:COLUMN_NAME_TO];
            if (data) {
                message.clients = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            }
            [result addObject:message];
        };
        [rs close];
        if (block) {
            block(result, nil);
        }
    }];
}

- (NSString *)dbPathWithUserId:(NSString*)userId {
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *result = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"msgcache_%@.sql",userId]];
//    [[NSFileManager defaultManager] removeItemAtPath:result error:NULL];
    return result;
}

@end
