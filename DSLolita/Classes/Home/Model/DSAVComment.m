//
//  DSAVComment.m
//  DSLolita
//
//  Created by 赛 丁 on 15/5/27.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSAVComment.h"


@implementation DSAVComment

@dynamic status;
@dynamic commentContent;
@dynamic commentUsername;
@dynamic commentUser;
@dynamic toUser;

+(NSString*)parseClassName{
    return @"Comment";
}


@end
