//
//  DSEmotionTool.h
//  DSLolita
//
//  Created by 赛 丁 on 15/5/28.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DSEmotion;

@interface DSEmotionTool : NSObject



/**
 *  默认表情
 */
+ (NSArray *)defaultEmotions;
/**
 *  emoji表情
 */
+ (NSArray *)emojiEmotions;
/**
 *  浪小花表情
 */
+ (NSArray *)lxhEmotions;
/**
 *  最近表情
 */
+ (NSArray *)recentEmotions;

/**
 *  保存最近使用的表情
 */
+ (void)addRecentEmotion:(DSEmotion *)emotion;
/**
 *  根据表情描述返回表情模型
 */
+ (DSEmotion *)emotionWithDesc:(NSString *)desc;

@end
