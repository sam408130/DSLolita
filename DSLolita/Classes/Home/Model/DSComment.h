//
//  DSComment.h
//  DSLolita
//
//  Created by 赛 丁 on 15/5/27.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DSUser;


@interface DSComment : NSObject


//commetn id
@property (nonatomic , copy) NSString *idstr;

//评论内容
@property (nonatomic , copy) NSString *commentContent;

//评论发布人
@property (nonatomic , strong) DSUser *user;

//关联的status
@property (nonatomic , strong) AVObject *status;

//touser
@property (nonatomic , strong) DSUser *toUser;

//穿件时间
@property (nonatomic , copy) NSString *created_at;


//信息中富文本内容
@property (nonatomic , copy) NSAttributedString *attributedText;

//配图
@property (nonatomic , strong) NSArray *pic_urls;

@end
