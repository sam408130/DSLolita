//
//  DSEmotion.h
//  DSLolita
//
//  Created by 赛 丁 on 15/5/28.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSEmotion : NSObject<NSCoding>

//表情文字描述
@property (nonatomic ,  copy) NSString *chs;

//表情的文字t描述
@property (nonatomic , copy) NSString *cht;

//表情的png文件名
@property (nonatomic , copy) NSString *png;

//emoji表情的编码
@property (nonatomic ,copy) NSString *code;

//emoji 表情的字符
@property (nonatomic , copy) NSString *emoji;

@end
