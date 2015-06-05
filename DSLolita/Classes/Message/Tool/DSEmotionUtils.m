//
//  DSEmotionUtils.m
//  DSLolita
//
//  Created by 赛 丁 on 15/6/5.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSEmotionUtils.h"
#import "XHEmotionManager.h"
#import "Emoji.h"
#import "NSString+Emojize.h"

#define DSSupportEmojis \
@[@":smile:" ,\
@":laughing:",\
@":blush:",\
@":smiley:",\
@":relaxed:",\
@":smirk:",\
@":heart_eyes:",\
@":kissing_heart:",\
@":kissing_closed_eyes:",\
@":flushed:",\
@":relieved:",\
@":satisfied:",\
@":grin:",\
@":wink:",\
@":stuck_out_tongue_winking_eye:",\
@":stuck_out_tongue_closed_eyes:",\
@":grinning:",\
@":kissing:",\
@":kissing_smiling_eyes:",\
@":stuck_out_tongue:",\
@":sleeping:",\
@":worried:",\
@":frowning:",\
@":anguished:",\
@":open_mouth:",\
@":grimacing:",\
@":confused:",\
@":hushed:",\
@":expressionless:",\
@":unamused:",\
@":sweat_smile:",\
@":sweat:",\
@":disappointed_relieved:",\
@":weary:",\
@":pensive:",\
@":disappointed:",\
@":confounded:",\
@":fearful:",\
@":cold_sweat:",\
@":persevere:",\
@":cry:",\
@":sob:",\
@":joy:",\
@":astonished:",\
@":scream:",\
@":tired_face:",\
@":angry:",\
@":rage:",\
@":triumph:",\
@":sleepy:",\
@":yum:",\
@":mask:",\
@":sunglasses:",\
@":dizzy_face:",\
@":neutral_face:",\
@":no_mouth:",\
@":innocent:",\
@":thumbsup:",\
@":thumbsdown:",\
@":clap:",\
@":point_right:",\
@":point_left:" \
];

@implementation DSEmotionUtils

+ (UIImage *)imageFromString:(NSString *)string attributes:(NSDictionary *)attributes size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [string drawInRect:CGRectMake(0, 0, size.width, size.height) withAttributes:attributes];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(NSArray*)emotionManagers{
    NSDictionary* codeToEmoji=[NSString emojiAliases];
    NSArray* emotionCodes=DSSupportEmojis;
    NSMutableArray *emotionManagers = [NSMutableArray array];
    for (NSInteger i = 0; i < 1; i ++) {
        XHEmotionManager *emotionManager = [[XHEmotionManager alloc] init];
        emotionManager.emotionName = nil;
        NSMutableArray *emotions = [NSMutableArray array];
        for (NSInteger j = 0; j < emotionCodes.count; j ++) {
            XHEmotion* xhEmotion=[[XHEmotion alloc] init];
            NSString* code=emotionCodes[j];
            CGFloat emojiSize=30;
            xhEmotion.emotionConverPhoto=[self imageFromString:codeToEmoji[code] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:25]} size:CGSizeMake(emojiSize, emojiSize)];
            xhEmotion.emotionPath=code;
            [emotions addObject:xhEmotion];
        }
        emotionManager.emotions = emotions;
        [emotionManagers addObject:emotionManager];
    }
    return emotionManagers;
}

+(NSString*)emojiStringFromString:(NSString*)text{
    return [self convertString:text toEmoji:YES];
}

+(NSString*)plainStringFromEmojiString:(NSString*)emojiText{
    return [self convertString:emojiText toEmoji:NO];
}

+(NSString*)convertString:(NSString*)text toEmoji:(BOOL)toEmoji{
    NSMutableString* emojiText=[[NSMutableString alloc] initWithString:text];
    for(NSString* code in [[NSString emojiAliases] allKeys]){
        NSString* emoji=[NSString emojiAliases][code];
        if(toEmoji){
            [emojiText replaceOccurrencesOfString:code withString:emoji options:NSLiteralSearch range:NSMakeRange(0,emojiText.length)];
        }else{
            [emojiText replaceOccurrencesOfString:emoji withString:code options:NSLiteralSearch range:NSMakeRange(0,emojiText.length)];
        }
    }
    return emojiText;
}

@end
