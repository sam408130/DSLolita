//
//  DSConvDetailMembersCell.h
//  DSLolita
//
//  Created by 赛 丁 on 15/6/5.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import <UIKit/UIKit.h>


static CGFloat kCDConvDetailMembersCellLineSpacing=10;
static CGFloat kCDConvDetailMembersCellInterItemSpacing=20;

@protocol DSConvDetailMembersHeaderViewDelegate <NSObject>

-(void)didSelectMember:(AVUser*)member;

-(void)didLongPressMember:(AVUser*)member;

@end

@interface DSConvDetailMembersCell : UITableViewCell

@property (nonatomic,strong) NSArray* members;

@property (nonatomic,strong) id<DSConvDetailMembersHeaderViewDelegate> membersCellDelegate;

+(CGFloat)heightForMembers:(NSArray*)members;

+(NSString*)reuseIdentifier;

@end