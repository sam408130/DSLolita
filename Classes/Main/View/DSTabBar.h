//
//  DSTabBar.h
//  DSLolita
//
//  Created by 赛 丁 on 15/5/25.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DSTabBar;

@protocol DSTabBarDelegate <NSObject>

@optional
- (void)tabBarDidClickedPlusButton:(DSTabBar *)tabBar;

@end



@interface DSTabBar : UITabBar

@property (nonatomic , weak) id<DSTabBarDelegate> tabBarDelegate;

@end
