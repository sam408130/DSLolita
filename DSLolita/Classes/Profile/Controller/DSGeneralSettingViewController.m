//
//  DSGeneralSettingViewController.m
//  DSLolita
//
//  Created by 赛 丁 on 15/6/1.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSGeneralSettingViewController.h"
#import "DSCommonGroup.h"
#import "DSCommonItem.h"
#import "DSCommonArrowItem.h"
#import "DSCommonSwitchItem.h"
#import "DSCommonLabelItem.h"


@interface DSGeneralSettingViewController ()

@end

@implementation DSGeneralSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupGroups];
}

//初始化模型数据
- (void)setupGroups{
    
    [self setupGroup0];
    [self setupGroup1];
    [self setupGroup2];
}



- (void)setupGroup0 {
    
    DSCommonGroup *group = [DSCommonGroup group];
    [self.groups addObject:group];
    
    DSCommonLabelItem *readMode = [DSCommonLabelItem itemWithTitle:@"阅读模式"];
    readMode.text = @"有图模式";
    group.items = @[readMode];
}


- (void)setupGroup1
{
    
}

- (void)setupGroup2
{
    
}
@end
