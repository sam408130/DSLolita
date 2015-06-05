//
//  DSIMConfig.m
//  DSLolita
//
//  Created by 赛 丁 on 15/6/5.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSIMConfig.h"

@implementation DSIMConfig

+(DSIMConfig*)config{
    static DSIMConfig* imConfig;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imConfig=[[DSIMConfig alloc] init];
    });
    return imConfig;
}

@end
