//
//  DSConvDetailMembersSubCell.h
//  DSLolita
//
//  Created by 赛 丁 on 15/6/5.
//  Copyright (c) 2015年 samDing. All rights reserved.
//
#import <UIKit/UIKit.h>

static CGFloat kCDConvDetailMemberSubCellAvatarSize=60;
static CGFloat kCDConvDetailMemberSubCellLabelHeight=20;
static CGFloat kCDConvDetailMemberSubCellSeparator=5;

@interface DSConvDetailMembersSubCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *avatarImageView;

@property (nonatomic,strong) UILabel *usernameLabel;

+(CGFloat)heightForCell;

+(CGFloat)widthForCell;

@end
