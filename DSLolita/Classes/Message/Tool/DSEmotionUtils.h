//
//  DSEmotionUtils.h
//  DSLolita
//
//  Created by 赛 丁 on 15/6/5.
//  Copyright (c) 2015年 samDing. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface DSEmotionUtils : NSObject

+(NSArray*)emotionManagers;

+(NSString*)emojiStringFromString:(NSString*)text;

+(NSString*)plainStringFromEmojiString:(NSString*)emojiText;

@end
