//
//  DSNotify.m
//  DSLolita
//
//  Created by 赛 丁 on 15/6/5.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSNotify.h"

@interface DSNotify (){
    
}

@property NSNotificationCenter* center;

@end

static DSNotify* _notify;

@implementation DSNotify

+(instancetype)sharedInstance{
    if(_notify==nil){
        _notify=[[DSNotify alloc] init];
    }
    return _notify;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _center=[NSNotificationCenter defaultCenter];
    }
    return self;
}

#pragma mark - conv

-(void)addConvObserver:(id)target selector:(SEL)selector{
    [_center addObserver:target selector:selector name:NOTIFICATION_CONV_UPDATED object:nil];
}

-(void)removeConvObserver:(id)target{
    [_center removeObserver:target name:NOTIFICATION_CONV_UPDATED object:nil];
}

-(void)postConvNotify{
    [_center postNotificationName:NOTIFICATION_CONV_UPDATED object:nil];
}

#pragma mark - message


-(void)addMsgObserver:(id)target selector:(SEL)selector{
    [_center addObserver:target selector:selector name:NOTIFICATION_MESSAGE_UPDATED object:nil];
}

-(void)removeMsgObserver:(id)target{
    [_center removeObserver:target name:NOTIFICATION_MESSAGE_UPDATED object:nil];
}

-(void)postMsgNotify:(AVIMTypedMessage*)msg{
    [_center postNotificationName:NOTIFICATION_MESSAGE_UPDATED object:msg];
}

-(void)addSessionObserver:(id)target selector:(SEL)selector{
    [_center addObserver:target selector:selector name:NOTIFICATION_SESSION_UPDATED object:nil];
}

-(void)removeSessionObserver:(id)target{
    [_center removeObserver:target name:NOTIFICATION_SESSION_UPDATED object:nil];
}

-(void)postSessionNotify{
    [_center postNotificationName:NOTIFICATION_SESSION_UPDATED object:nil];
}

@end
