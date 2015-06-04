//
//  DSPopMenu.h
//  DSLolita
//
//  Created by 赛 丁 on 15/5/27.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    DSPopMenuArrowPositionCenter = 0,
    DSPopMenuArrowPositionLeft = 1,
    DSPopMenuArrowPositionRight = 2
} DSPopMenuArrowPosition;

@class DSPopMenu;



@interface DSPopMenu : UIView

@property (nonatomic, assign, getter = isDimBackground) BOOL dimBackground;

@property (nonatomic, assign) DSPopMenuArrowPosition arrowPosition;

/**
 *  初始化方法
 */
- (instancetype)initWithContentView:(UIView *)contentView;
+ (instancetype)popMenuWithContentView:(UIView *)contentView;

/**
 *  设置菜单的背景图片
 */
- (void)setBackground:(UIImage *)background;

/**
 *  显示菜单
 */
- (void)showInRect:(CGRect)rect;

/**
 *  关闭菜单
 */
- (void)dismiss;
@end