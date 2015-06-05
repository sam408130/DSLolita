//
//  DSBaseTableVC.m
//  DSLolita
//
//  Created by 赛 丁 on 15/6/5.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSBaseTableVC.h"

@interface DSBaseTableVC ()

@end

@implementation DSBaseTableVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.edgesForExtendedLayout=UIRectEdgeAll;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

- (CGFloat)getAdapterHeight {
    CGFloat adapterHeight = 0;
    if ([[[UIDevice currentDevice] systemVersion] integerValue] < 7.0) {
        adapterHeight = 44;
    }
    return adapterHeight;
}

-(UITableView*)tableView{
    if(_tableView==nil){
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:self.tableViewStyle];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc{
}

-(NSMutableArray*)dataSource{
    if(_dataSource==nil){
        _dataSource=[NSMutableArray array];
    }
    return _dataSource;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

@end

