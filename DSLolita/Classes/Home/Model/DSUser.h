//
//  DSUser.h
//  DSLolita
//
//  Created by 赛 丁 on 15/5/25.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DSUser;
@interface DSUser : NSObject

//用户名字
@property (nonatomic , copy) NSString *username;

//用户id
@property (nonatomic , copy) NSString *userId;

//用户头像
@property (nonatomic , copy) NSString *avatarUrl;

//用户等级
@property (nonatomic , assign) int mbrank;

//性别
@property (nonatomic , copy) NSString *gender;




+ (void)save:(AVUser *)user;
+ (DSUser *)readLocalUser;
+ (DSUser *)transfer:(AVUser *)user;

@end
