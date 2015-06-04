//
//  DSTabBar.m
//  DSLolita
//
//  Created by 赛 丁 on 15/5/25.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSTabBar.h"

@interface DSTabBar()

@property (nonatomic ,weak) UIButton *plusButton;


@end



@implementation DSTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        if (!iOS7) {
            self.backgroundImage = [UIImage imageWithName:@"tabbar_backgroud"];
        }
        self.backgroundColor = [UIColor whiteColor];
        self.selectionIndicatorImage = [UIImage imageWithName:@"navigationbar_button_background"];
    
        [self setupPlusButton];
    }
    
    return  self;
}


- (void)setupPlusButton {
    UIButton *plusButton = [[UIButton alloc] init];
    // 设置背景
    [plusButton setBackgroundImage:[UIImage imageWithName:@"tabbar_compose_button"] forState:UIControlStateNormal];
    [plusButton setBackgroundImage:[UIImage imageWithName:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
    // 设置图标
    [plusButton setImage:[UIImage imageWithName:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
    [plusButton setImage:[UIImage imageWithName:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
    [plusButton addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
    // 添加
    [self addSubview:plusButton];
    self.plusButton = plusButton;
}

- (void)plusClick {
    //通知代理
    if ([self.tabBarDelegate respondsToSelector:@selector(tabBarDidClickedPlusButton:)]){
        [self.tabBarDelegate tabBarDidClickedPlusButton:self];
    }
}


//布局子控件

- (void)layoutSubviews {
    [super layoutSubviews];
    //设置plusButton的frame
    [self setupPlusButtonFrame];
    //设置所有tabbarButton的frame
    [self setupAllTabBarButtonsFrame];
}

- (void)setupPlusButtonFrame {
    self.plusButton.size = self.plusButton.currentBackgroundImage.size;
    self.plusButton.center = CGPointMake(self.width * 0.5, self.height * 0.5);
}

- (void)setupAllTabBarButtonsFrame {
    
    int index = 0;
    //遍历所有button
    for (UIView *tabBarButton in self.subviews){
        if (![tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) continue;
        [self setupTabBarButtonFrame:tabBarButton atIndex:index];
        
        index++;
    }
}




- (void)setupTabBarButtonFrame:(UIView *)tabBarButton atIndex:(int)index
{
    // 计算button的尺寸
    CGFloat buttonW = self.width / (self.items.count + 1);
    CGFloat buttonH = self.height;
    
    tabBarButton.width = buttonW;
    tabBarButton.height = buttonH;
    if (index >= 2) {
        tabBarButton.x = buttonW * (index + 1);
    } else {
        tabBarButton.x = buttonW * index;
    }
    tabBarButton.y = 0;
}









@end
