//
//  DSCommonTableViewController.m
//  DSLolita
//
//  Created by 赛 丁 on 15/5/25.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSCommonTableViewController.h"
#import "DSCommonCell.h"
#import "DSCommonItem.h"
#import "DSCommonSwitchItem.h"
#import "DSCommonLabelItem.h"
#import "DSCommonArrowItem.h"
#import "DSCommonGroup.h"



@interface DSCommonTableViewController ()

@property (nonatomic , strong) NSMutableArray *groups;

@end

@implementation DSCommonTableViewController

- (NSMutableArray *)groups{
    if (_groups == nil){
        self.groups = [NSMutableArray array];
    }
    return _groups;
}


//屏蔽tableView的样式

- (id)init{
    
    return [self initWithStyle:UITableViewStyleGrouped];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置tableView属性
    self.tableView.backgroundColor = DSGlobleTableViewBackgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sectionFooterHeight = DSStatusCellMargin;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.contentInset = UIEdgeInsetsMake(DSStatusCellMargin - 35, 0, 0, 0);

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.groups.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    DSCommonGroup *group = self.groups[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DSCommonCell *cell = [DSCommonCell cellWithTableView:tableView];
    DSCommonGroup *group = self.groups[indexPath.section];
    cell.item = group.items[indexPath.row];
    
    //设置cell所处的行号，及所处组的总行数
    [cell setIndexPath:indexPath rowsInSection:(int)group.items.count];
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    DSCommonGroup *group = self.groups[section];
    return group.footer;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
   
    DSCommonGroup *group = self.groups[section];
    return group.header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //1.取出这行对应的item类型
    DSCommonGroup *group = self.groups[indexPath.section];
    DSCommonItem *item = group.items[indexPath.row];
    
    
    //2.判断有无需要跳转的控制器
    if (item.destVcClass){
        UIViewController *destVc = [[item.destVcClass alloc] init];
        destVc.title = item.title;
        [self.navigationController pushViewController:destVc animated:YES];
    }
    
    //3. 判断有无想执行的操作
    if (item.operation) {
        item.operation();
    }
    
}

@end
