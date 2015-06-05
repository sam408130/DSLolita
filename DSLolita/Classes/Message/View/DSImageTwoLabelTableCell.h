//
//  DSImageTwoLabelTableCell.h
//  DSLolita
//
//  Created by 赛 丁 on 15/6/5.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSBadgeView.h"

@interface DSImageTwoLabelTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (strong, nonatomic) JSBadgeView *unreadBadge;
@property (nonatomic) NSInteger unreadCount;

@end
