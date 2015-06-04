//
//  DSStatusToolbar.h
//  DSLolita
//
//  Created by 赛 丁 on 15/5/26.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DSStatus;


@interface DSStatusToolbar : UIImageView

@property (nonatomic , strong) DSStatus *status;

@property (nonatomic , weak) UIButton *repostsBtn;
@property (nonatomic , weak) UIButton *commentsBtn;
@property (nonatomic , weak) UIButton *attitudesBtn;
@property (nonatomic , weak) UIButton *messageBtn;

@end
