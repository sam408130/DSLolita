//
//  DSStatusFrame.h
//  DSLolita
//
//  Created by 赛 丁 on 15/5/26.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DSStatus;
@class DSStatusDetailFrame;


@interface DSStatusFrame : NSObject

//Feed模型
@property (nonatomic , strong) DSStatus *status;

//Feed detail frame
@property (nonatomic , strong) DSStatusDetailFrame *statusDetailFrame;

//工具条frame
@property (nonatomic , assign) CGRect statusToolbarFrame;

//cell高度
@property (nonatomic , assign) CGFloat cellHeight;


//cell frame
@property (nonatomic , assign) CGRect frame;



@end


