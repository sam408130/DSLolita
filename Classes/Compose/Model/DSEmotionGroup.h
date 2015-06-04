//
//  DSEmotionGroup.h
//  DSLolita
//
//  Created by 赛 丁 on 15/5/28.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSEmotionGroup : NSObject

// 表情分组身份
@property (nonatomic , copy) NSString *emotion_group_identifier;

// 表情类型
@property (nonatomic , copy) NSString *emotion_group_type;

// 表情
@property (nonatomic , strong) NSArray *emotion_group_emotions;

@end
