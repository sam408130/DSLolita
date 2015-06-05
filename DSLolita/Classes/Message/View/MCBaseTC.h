//
//  MCBaseTC.h
//  DSLolita
//
//  Created by 赛 丁 on 15/6/5.
//  Copyright (c) 2015年 samDing. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "MCBaseVC.h"

@interface MCBaseTC : MCBaseVC<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView* tableView;

@property (nonatomic,assign) UITableViewStyle tableViewStyle;

@property (nonatomic,strong) NSMutableArray* dataSource;

@end
