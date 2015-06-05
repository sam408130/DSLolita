//
//  DSSessionStateView.h
//  DSLolita
//
//  Created by 赛 丁 on 15/6/5.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSIM.h"
#import "DSNotify.h"

static CGFloat kCDSessionStateViewHight=44;

@class DSSessionStateView;


@protocol DSSessionStateProtocal <NSObject>

@optional

-(void)onSessionBrokenWithStateView:(DSSessionStateView*)view;

-(void)onSessionFineWithStateView:(DSSessionStateView*)view;

@end

@interface DSSessionStateView : UIView

@property(nonatomic)UITableView* tableView;

@property id<DSSessionStateProtocal> delegate;

-(instancetype)initWithWidth:(CGFloat)width;

-(void)observeSessionUpdate;

@end