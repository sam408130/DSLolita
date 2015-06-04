//
//  DSCommentCellFrame.h
//  DSLolita
//
//  Created by 赛 丁 on 15/6/3.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DSComment;
@class DSCommentDetailFrame;

@interface DSCommentCellFrame : NSObject


@property (nonatomic , strong) DSComment *commentData;

@property (nonatomic , strong) DSCommentDetailFrame *commentDetailFrame;

@property (nonatomic , assign) CGFloat cellHeight;


@end
