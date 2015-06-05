//
//  DSEmotionAttachment.m
//  DSLolita
//
//  Created by 赛 丁 on 15/5/28.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSEmotionAttachment.h"
#import "DSEmotion.h"
@implementation DSEmotionAttachment

- (void)setEmotion:(DSEmotion *)emotion {
    _emotion = emotion;
    
    self.image = [UIImage imageWithName:emotion.png];
    
}

@end
