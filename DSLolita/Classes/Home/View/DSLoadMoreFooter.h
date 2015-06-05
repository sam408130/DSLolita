//
//  DSLoadMoreFooter.h
//  DSLolita
//
//  Created by 赛 丁 on 15/5/26.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSLoadMoreFooter : UIView

+ (instancetype)footer;

- (void)beginRefreshing;
- (void)endRefreshing;

@property (nonatomic ,assign,getter=isRefreshing) BOOL refreshing;
@end
