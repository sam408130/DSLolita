//
//  DSAbuseReport.m
//  DSLolita
//
//  Created by 赛 丁 on 15/6/5.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSAbuseReport.h"

@implementation DSAbuseReport

@dynamic reason;
@dynamic author;
@dynamic convid;

+(NSString*)parseClassName{
    return @"AbuseReport";
}

@end