//
//  AVIMConversation+Custon.h
//  DSLolita
//
//  Created by 赛 丁 on 15/6/5.
//  Copyright (c) 2015年 samDing. All rights reserved.
//


#import "DSIMConfig.h"

#define CONV_TYPE @"type"
#define CONV_ATTR_TYPE_KEY @"attr.type"
#define CONV_MEMBERS_KEY @"m"

typedef enum : NSUInteger {
    DSConvTypeSingle = 0,
    DSConvTypeGroup,
} DSConvType;

@interface AVIMConversation(Custom)

-(DSConvType)type;

-(NSString*)otherId;

-(NSString*)displayName;

+(NSString*)nameOfUserIds:(NSArray*)userIds;

-(NSString*)title;

-(UIImage*)icon;


@end
