//
//  AVIMUserInfoMessage.h
//  DSLolita
//
//  Created by 赛 丁 on 15/6/5.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kAVIMMessageMediaTypeUserInfo 1

@interface AVIMUserInfoMessage : AVIMTypedMessage<AVIMTypedMessageSubclassing>

+ (instancetype)messageWithAttributes:(NSDictionary *)attributes;

@end
