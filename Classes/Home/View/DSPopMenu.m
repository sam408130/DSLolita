//
//  DSPopMenu.m
//  DSLolita
//
//  Created by 赛 丁 on 15/5/27.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSPopMenu.h"


@interface DSPopMenu()
/**
 *  容器的大小
 */
@property (nonatomic, strong) UIView *contentView;
/**
 *  最底部的遮盖 ：屏蔽除菜单以外控件的事件
 */
@property (nonatomic, weak) UIButton *cover;
/**
 *  容器 ：容纳具体要显示的内容
 */
@property (nonatomic, weak) UIImageView *container;
@end

@implementation DSPopMenu
#pragma mark - 初始化方法
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /** 添加菜单内部的2个子控件 **/
        // 添加一个遮盖按钮
        UIButton *cover = [[UIButton alloc] init];
        cover.backgroundColor = [UIColor clearColor];
        [cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cover];
        self.cover = cover;
        
        // 添加带箭头的菜单图片
        UIImageView *container = [[UIImageView alloc] init];
        container.userInteractionEnabled = YES;
        container.image = [UIImage resizableImageWithName:@"popover_background"];
        [self addSubview:container];
        self.container = container;
    }
    return self;
}

- (instancetype)initWithContentView:(UIView *)contentView
{
    if (self = [super init]) {
        self.contentView = contentView;
    }
    return self;
}

+ (instancetype)popMenuWithContentView:(UIView *)contentView
{
    return [[self alloc] initWithContentView:contentView];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.cover.frame = self.bounds;
}

#pragma mark - 内部方法
- (void)coverClick
{
    [self dismiss];
}

#pragma mark - 公共方法
- (void)setDimBackground:(BOOL)dimBackground
{
    _dimBackground = dimBackground;
    
    if (dimBackground) {
        self.cover.backgroundColor = [UIColor blackColor];
        self.cover.alpha = 0.3;
    } else {
        self.cover.backgroundColor = [UIColor clearColor];
        self.cover.alpha = 1.0;
    }
}

- (void)setArrowPosition:(DSPopMenuArrowPosition)arrowPosition
{
    _arrowPosition = arrowPosition;
    
    switch (arrowPosition) {
        case DSPopMenuArrowPositionCenter:
            self.container.image = [UIImage resizableImageWithName:@"popover_background"];
            break;
            
        case DSPopMenuArrowPositionLeft:
            self.container.image = [UIImage resizableImageWithName:@"popover_background_left"];
            break;
            
        case DSPopMenuArrowPositionRight:
            self.container.image = [UIImage resizableImageWithName:@"popover_background_right"];
            break;
    }
}

- (void)setBackground:(UIImage *)background
{
    self.container.image = background;
}

- (void)showInRect:(CGRect)rect
{
    // 添加菜单整体到窗口身上
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    [window addSubview:self];
    
    // 设置容器的frame
    self.container.frame = rect;
    [self.container addSubview:self.contentView];
    
    // 设置容器里面内容的frame
    CGFloat topMargin = 12;
    CGFloat leftMargin = 5;
    CGFloat rightMargin = 5;
    CGFloat bottomMargin = 8;
    
    self.contentView.y = topMargin;
    self.contentView.x = leftMargin;
    self.contentView.width = self.container.width - leftMargin - rightMargin;
    self.contentView.height = self.container.height - topMargin - bottomMargin;
}

- (void)dismiss
{
    //将当前对象隐藏
    [self removeFromSuperview];
}
@end
