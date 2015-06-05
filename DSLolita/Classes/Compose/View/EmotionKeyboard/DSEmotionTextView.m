//
//  DSEmotionTextView.m
//  DSLolita
//
//  Created by 赛 丁 on 15/5/28.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSEmotionTextView.h"
#import "DSEmotion.h"
#import "DSEmotionAttachment.h"

@implementation DSEmotionTextView


- (void)appendEmotion:(DSEmotion *)emotion {
    
    if (emotion.emoji) {
        //emoji表情
        [self insertText:emotion.emoji];
    }else{
        //图片表情
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        
        //创建一个带有图片表情的富文本
        DSEmotionAttachment *attach = [[DSEmotionAttachment alloc] init];
        attach.emotion = emotion;
        attach.bounds = CGRectMake(0, -3, self.font.lineHeight, self.font.lineHeight);
        NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
        
        
        // 记录表情的插入位置
        int insertIndex = (int)self.selectedRange.location;
        
        // 插入表情图片到光标位置
        [attributedText insertAttributedString:attachString atIndex:insertIndex];
        
        // 设置字体
        [attributedText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedText.length)];
        
        // 重新赋值（光标自动回到文字的最后面）
        self.attributedText = attributedText;
        
        // 让光标回到表情后面的位置
        self.selectedRange = NSMakeRange(insertIndex + 1, 0);
        
    }
    
    
}



- (NSString *)realText {
    
    // 1.用来拼接所有文字
    NSMutableString *string = [NSMutableString string];
    
    // 2.遍历富文本里面的内容
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range , BOOL *stop){
        DSEmotionAttachment *attach = attrs[@"NSAttachment"];
        if (attach){//如果是带有附件的富文本
            [string appendString:attach.emotion.chs];
        }else{
            //普通文本，截取rang范围内的普通文本
            NSString *substring = [self.attributedText attributedSubstringFromRange:range].string;
            [string appendString:substring];
        }
    }];
    
    return string;
}

@end
