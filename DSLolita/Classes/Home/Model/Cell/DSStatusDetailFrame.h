//
//  DSStatusDetailFrame.h
//  DSLolita
//
//  Created by 赛 丁 on 15/5/26.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DSStatus,DSStatusOriginalFrame,DSStatusRetweetedFrame;


@interface DSStatusDetailFrame : NSObject

// 1.自己的frame
@property (nonatomic , assign) CGRect frame;

// 2.数据
@property (nonatomic , strong) DSStatus *status;

// 3.转发Feed frame
@property (nonatomic ,strong) DSStatusRetweetedFrame *retweetedFrame;

// 4.原始Feed frame
@property (nonatomic , strong) DSStatusOriginalFrame *originalFrame;



@end
