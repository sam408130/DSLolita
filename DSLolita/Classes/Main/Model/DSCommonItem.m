//
//  DSCommonItem.m
//  DSLolita
//
//  Created by 赛 丁 on 15/5/25.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSCommonItem.h"

@implementation DSCommonItem


+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon {
    
    DSCommonItem *item = [[self alloc] init];
    item.title = title;
    item.icon = icon;
    return  item;
}

+ (instancetype)itemWithTitle:(NSString *)title {
    return [self itemWithTitle:title icon:nil];
}

@end
