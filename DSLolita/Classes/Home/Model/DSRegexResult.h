//
//  DSRegexResult.h
//  DSLolita
//
//  Created by 赛 丁 on 15/5/26.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSRegexResult : NSObject


//匹配到的字符串
@property (nonatomic , copy) NSString *string;

//匹配到的范围
@property (nonatomic , assign) NSRange range;

//这个结果是否为表亲
@property (nonatomic , assign ,getter=isEmotion) BOOL emotion;

@end
