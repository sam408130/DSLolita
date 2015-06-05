//
//  DSCommentCell.h
//  DSLolita
//
//  Created by 赛 丁 on 15/6/3.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DSCommentCellFrame;
@class DSCommentDetailView;

@interface DSCommentCell : UITableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic , strong) DSCommentCellFrame *commentFrame;
@property (nonatomic , weak) DSCommentDetailView *commentDetailView;
@property (nonatomic , strong) NSIndexPath *indexpath;


@end
