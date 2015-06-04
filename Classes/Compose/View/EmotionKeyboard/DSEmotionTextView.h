//
//  DSEmotionTextView.h
//  DSLolita
//
//  Created by 赛 丁 on 15/5/28.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSTextView.h"
@class DSEmotion;

@interface DSEmotionTextView : DSTextView


// 拼接表情到最后面

- (void)appendEmotion:(DSEmotion *)emotion;

- (NSString *)realText;

@end
