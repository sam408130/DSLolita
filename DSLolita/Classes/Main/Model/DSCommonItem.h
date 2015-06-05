//
//  DSCommonItem.h
//  DSLolita
//
//  Created by 赛 丁 on 15/5/25.
//  Copyright (c) 2015年 samDing. All rights reserved.
//



@interface DSCommonItem : NSObject

//图标
@property (nonatomic , copy) NSString *icon;

//标题
@property (nonatomic , copy) NSString *title;

//子标题
@property (nonatomic , copy) NSString *subtitle;

//右边显示的数字标记
@property (nonatomic , copy) NSString *badgeValue;

//点击这行cell,需要跳转到哪个控制器
@property (nonatomic , assign) Class destVcClass;

@property (nonatomic , copy) void (^operation)();



+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon;
+ (instancetype)itemWithTitle:(NSString *)title;


@end
