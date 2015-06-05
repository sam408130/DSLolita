//
//  DSCommonGroup.h
//  DSLolita
//
//  Created by 赛 丁 on 15/5/25.
//  Copyright (c) 2015年 samDing. All rights reserved.
//



@interface DSCommonGroup : NSObject

//group header
@property (nonatomic , copy) NSString *header;

//group footer
@property (nonatomic , copy) NSString *footer;

//这组的所有行模型（数组中存放的都是HMCommonItem模型）
@property (nonatomic , strong) NSArray *items;


+ (instancetype)group;


@end
