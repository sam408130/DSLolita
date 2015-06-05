//
//  DSRoom.h
//  DSLolita
//
//  Created by 赛 丁 on 15/6/5.
//  Copyright (c) 2015年 samDing. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface DSRoom : NSObject

@property NSString* convid;

@property AVIMConversation* conv;

@property AVIMTypedMessage* lastMsg;

@property NSInteger unreadCount;

@end

