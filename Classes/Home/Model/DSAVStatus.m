//
//  AVStatus.m
//  DSLolita
//
//  Created by 赛 丁 on 15/5/27.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSAVStatus.h"

@implementation DSAVStatus

@dynamic creator;
@dynamic statusContent;
@dynamic albumPhotos;
@dynamic comments;
@dynamic digUsers;

+ (NSString *)parseClassName {
    return @"Album";
}


@end
