//
//  DSConvDetailMembersSubCell.m
//  DSLolita
//
//  Created by 赛 丁 on 15/6/5.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSConvDetailMembersSubCell.h"

@interface DSConvDetailMembersSubCell ()

@end

@implementation DSConvDetailMembersSubCell

+(CGFloat)heightForCell{
    return kCDConvDetailMemberSubCellAvatarSize+kCDConvDetailMemberSubCellSeparator+kCDConvDetailMemberSubCellLabelHeight;
}

+(CGFloat)widthForCell{
    return kCDConvDetailMemberSubCellAvatarSize;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.avatarImageView];
        [self addSubview:self.usernameLabel];
    }
    return self;
}

-(UIImageView*)avatarImageView{
    if(_avatarImageView==nil){
        _avatarImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kCDConvDetailMemberSubCellAvatarSize, kCDConvDetailMemberSubCellAvatarSize)];
    }
    return _avatarImageView;
}

-(UILabel*)usernameLabel{
    if(_usernameLabel==nil){
        _usernameLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_avatarImageView.frame)+kCDConvDetailMemberSubCellSeparator, CGRectGetWidth(_avatarImageView.frame), kCDConvDetailMemberSubCellLabelHeight)];
        _usernameLabel.textAlignment=NSTextAlignmentCenter;
        _usernameLabel.font=[UIFont systemFontOfSize:12];
    }
    return _usernameLabel;
}

@end
