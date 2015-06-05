//
//  DSEmotionTool.m
//  DSLolita
//
//  Created by 赛 丁 on 15/5/28.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#define DSRecentFilepath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"recent_emotions.arch"]


#import "DSEmotionTool.h"
#import "DSEmotion.h"
#import "DSEmotionGroup.h"
#import "MJExtension.h"



@implementation DSEmotionTool

// 默认表情
static NSArray *_defaultEmotions;

// emoji表情
static NSArray *_emojiEmotion;

// 浪小花表情
static NSArray *_lxhEmotions;

// 最近表情
static NSMutableArray *_recentEmotions;


+ (NSArray *)defaultEmotions
{
    if (!_defaultEmotions) {
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"default.plist" ofType:nil];
        _defaultEmotions = [DSEmotionGroup objectWithFile:plist].emotion_group_emotions;
    }
    return _defaultEmotions;
}

+ (NSArray *)emojiEmotions
{
    if (!_emojiEmotion) {
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"emoji.plist" ofType:nil];
        _emojiEmotion = [DSEmotionGroup objectWithFile:plist].emotion_group_emotions;
        
    }
    return _emojiEmotion;
}

+ (NSArray *)lxhEmotions
{
    if (!_lxhEmotions) {
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"lxh.plist" ofType:nil];
        _lxhEmotions = [DSEmotionGroup objectWithFile:plist].emotion_group_emotions;
        
    }
    return _lxhEmotions;
}

+ (NSArray *)recentEmotions
{
    if (!_recentEmotions) {
        // 去沙盒中加载最近使用的表情数据
        _recentEmotions = [NSKeyedUnarchiver unarchiveObjectWithFile:DSRecentFilepath];
        if (!_recentEmotions) { // 沙盒中没有任何数据
            _recentEmotions = [NSMutableArray array];
        }
    }
    return _recentEmotions;
}

// Emotion -- 戴口罩 -- Emoji的plist里面加载的表情
+ (void)addRecentEmotion:(DSEmotion *)emotion
{
    // 加载最近的表情数据
    [self recentEmotions];
    
    // 删除之前的表情
    [_recentEmotions removeObject:emotion];
    
    // 添加最新的表情
    [_recentEmotions insertObject:emotion atIndex:0];
    
    // 存储到沙盒中
    [NSKeyedArchiver archiveRootObject:_recentEmotions toFile:DSRecentFilepath];
}

+ (DSEmotion *)emotionWithDesc:(NSString *)desc
{
    if (!desc) return nil;
    
    __block DSEmotion *foundEmotion = nil;
    
    // 从默认表情中找
    [[self defaultEmotions] enumerateObjectsUsingBlock:^(DSEmotion *emotion, NSUInteger idx, BOOL *stop) {
        if ([desc isEqualToString:emotion.chs] || [desc isEqualToString:emotion.cht]) {
            foundEmotion = emotion;
            *stop = YES;
        }
    }];
    if (foundEmotion) return foundEmotion;
    
    // 从浪小花表情中查找
    [[self lxhEmotions] enumerateObjectsUsingBlock:^(DSEmotion *emotion, NSUInteger idx, BOOL *stop) {
        if ([desc isEqualToString:emotion.chs] || [desc isEqualToString:emotion.cht]) {
            foundEmotion = emotion;
            *stop = YES;
        }
    }];
    
    return foundEmotion;
}

@end
