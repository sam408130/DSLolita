//
//  DSCommentTextCell.h
//  DSLolita
//
//  Created by 赛 丁 on 15/6/3.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DSCommentTextCellDelegate <NSObject>

- (void)sendButtonDidPressed:(UIButton *)button;

@end

@interface DSCommentTextCell : UITableViewCell

@property (nonatomic , strong) NSString *cellType;
@property (nonatomic , strong) id<DSCommentTextCellDelegate>delegate;

@end
