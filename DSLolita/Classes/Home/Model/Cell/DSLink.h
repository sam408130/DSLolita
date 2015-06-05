//
//  DSLink.h
//  DSLolita
//
//  Created by 赛 丁 on 15/5/26.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSLink : UIView

//匹配的文本
@property (nonatomic , copy) NSString *text;

//匹配的文字范围
@property (nonatomic , assign) NSRange range;

//选中的范围
@property (nonatomic , strong) NSArray *rects;

@end
