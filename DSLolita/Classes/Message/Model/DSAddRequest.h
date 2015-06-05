//
//  DSAddRequest.h
//  DSLolita
//
//  Created by 赛 丁 on 15/6/5.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger{
    DSAddRequestStatusWait=0,
    DSAddRequestStatusDone
}DSAddRequestStatus;

#define kAddRequestFromUser @"fromUser"
#define kAddRequestToUser @"toUser"
#define kAddRequestStatus @"status"

@interface DSAddRequest : AVObject<AVSubclassing>

@property AVUser *fromUser;
@property AVUser *toUser;
@property int status;

@end