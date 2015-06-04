//
//  DSStatusRetweetedFrame.h
//  DSLolita
//
//  Created by 赛 丁 on 15/5/26.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DSStatus;


@interface DSStatusRetweetedFrame : NSObject
/** 昵称 */
//@property (nonatomic, assign) CGRect nameFrame;
/** 正文 */
@property (nonatomic, assign) CGRect textFrame;
/** 转发微博模型 */
@property (nonatomic, strong) DSStatus *retweetedStatus;
/** 相册的frame */
@property (nonatomic, assign) CGRect photosFrame;
/** 自己的frame */
@property (nonatomic, assign) CGRect frame;

@end
