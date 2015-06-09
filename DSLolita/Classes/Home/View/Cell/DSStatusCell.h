//
//  DSStatusCell.h
//  DSLolita
//
//  Created by 赛 丁 on 15/5/26.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DSStatusFrame;
@class DSStatusDetailView;




@protocol DSStatusCellDelegate <NSObject>

- (void)didCommentButtonClicked:(UIButton *)button indexPath:(NSIndexPath *)indexpath;
- (void)didLikeButtonClicked:(UIButton *)button indexPath:(NSIndexPath *)indexpath;
- (void)didMessageButtonClicked:(UIButton *)button indexPath:(NSIndexPath *)indexpath;
- (void)didShareButtonClicked:(UIButton *)button indexPath:(NSIndexPath *)indexpath;

@end

@interface DSStatusCell : UITableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tablView;

@property (nonatomic , strong) DSStatusFrame *statusFrame;

@property (nonatomic , weak) DSStatusDetailView *detailView;

@property (nonatomic , strong) id<DSStatusCellDelegate>delegate;

@property (nonatomic , strong) NSIndexPath *indexpath;

@end
