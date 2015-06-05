//
//  DSCommonCell.h
//  DSLolita
//
//  Created by 赛 丁 on 15/5/25.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DSCommonItem;


@interface DSCommonCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setIndexPath:(NSIndexPath *)indexPath rowsInSection:(int)rows;


//cell对应的item数据
@property (nonatomic , strong) DSCommonItem *item;


@end
