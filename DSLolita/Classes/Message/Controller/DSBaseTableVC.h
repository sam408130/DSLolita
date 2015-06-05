//
//  DSBaseTableVC.h
//  DSLolita
//
//  Created by 赛 丁 on 15/6/5.
//  Copyright (c) 2015年 samDing. All rights reserved.
//


#import "DSBaseVC.h"

@interface DSBaseTableVC : DSBaseVC <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UITableView* tableView;

@property (nonatomic,assign) UITableViewStyle tableViewStyle;

@property (nonatomic,strong) NSMutableArray* dataSource;

@end