//
//  DSAddRequest.m
//  DSLolita
//
//  Created by 赛 丁 on 15/6/5.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSAddRequest.h"

@implementation DSAddRequest

@dynamic fromUser;
@dynamic toUser;
@dynamic status;

+(NSString *)parseClassName{
    return @"AddRequest";
}


@end
