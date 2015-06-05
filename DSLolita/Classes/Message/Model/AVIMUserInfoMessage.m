//
//  AVIMUserInfoMessage.m
//  DSLolita
//
//  Created by 赛 丁 on 15/6/5.
//  Copyright (c) 2015年 samDing. All rights reserved.
//
#import "AVIMUserInfoMessage.h"

@implementation AVIMUserInfoMessage

+(void)load{
    [self registerSubclass];
}

- (instancetype)init {
    if ((self = [super init])) {
        self.mediaType = [[self class] classMediaType];
    }
    return self;
}

+ (AVIMMessageMediaType)classMediaType{
    return kAVIMMessageMediaTypeUserInfo;
}

+ (instancetype)messageWithAttributes:(NSDictionary *)attributes {
    AVIMUserInfoMessage *message = [[self alloc] init];
    message.text=@"";
    message.attributes = attributes;
    return message;
}

@end
