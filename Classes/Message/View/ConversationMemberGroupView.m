//
//  ConversationMemberGroupView.m
//  FreeChat
//
//  Created by Feng Junwen on 2/11/15.
//  Copyright (c) 2015 Feng Junwen. All rights reserved.
//

#import "ConversationMemberGroupView.h"

#define kAvatar_Width  (50)
#define kAvatar_Height (50)
#define kUsername_Label_Height (15)

#define kCell_Height (90)

@interface ConversationMemberGroupView () {
    ;
}

@property (nonatomic, strong) UIImageView *userAvatar1;
@property (nonatomic, strong) UIImageView *userAvatar2;
@property (nonatomic, strong) UIImageView *userAvatar3;
@property (nonatomic, strong) UIImageView *userAvatar4;

@property (nonatomic, strong) UILabel *username1;
@property (nonatomic, strong) UILabel *username2;
@property (nonatomic, strong) UILabel *username3;
@property (nonatomic, strong) UILabel *username4;

@end

@implementation ConversationMemberGroupView

@synthesize userAvatar1, userAvatar2, userAvatar3, userAvatar4, username1, username2, username3, username4;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    // Initialization code
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGSize frameSize = self.contentView.frame.size;
        CGFloat widthDelta = (frameSize.width - kAvatar_Width * 4) / 5;
        userAvatar1 = [[UIImageView alloc] initWithFrame:CGRectMake(widthDelta, 10, kAvatar_Width, kAvatar_Height)];
        [userAvatar1 setImage:[UIImage imageNamed:@"add_member"]];
        username1 = [[UILabel alloc] initWithFrame:CGRectMake(widthDelta, 65, kAvatar_Width, kUsername_Label_Height)];
        [username1 setTextAlignment:NSTextAlignmentCenter];
        [username1 setFont:[UIFont systemFontOfSize:16.0f]];
        [self.contentView addSubview:userAvatar1];
        [self.contentView addSubview:username1];
        
        userAvatar2 = [[UIImageView alloc] initWithFrame:CGRectMake(widthDelta * 2 + kAvatar_Width, 10, kAvatar_Width, kAvatar_Height)];
        [userAvatar2 setImage:[UIImage imageNamed:@"add_member"]];
        username2 = [[UILabel alloc] initWithFrame:CGRectMake(widthDelta * 2 + kAvatar_Width, 65, kAvatar_Width, kUsername_Label_Height)];
        [username2 setTextAlignment:NSTextAlignmentCenter];
        [username2 setFont:[UIFont systemFontOfSize:16.0f]];
        [self.contentView addSubview:userAvatar2];
        [self.contentView addSubview:username2];
        
        userAvatar3 = [[UIImageView alloc] initWithFrame:CGRectMake(widthDelta * 3 + kAvatar_Width *2, 10, kAvatar_Width, kAvatar_Height)];
        [userAvatar3 setImage:[UIImage imageNamed:@"add_member"]];
        username3 = [[UILabel alloc] initWithFrame:CGRectMake(widthDelta * 3 + kAvatar_Width * 2, 65, kAvatar_Width, kUsername_Label_Height)];
        [username3 setTextAlignment:NSTextAlignmentCenter];
        [username3 setFont:[UIFont systemFontOfSize:16.0f]];
        [self.contentView addSubview:userAvatar3];
        [self.contentView addSubview:username3];

        userAvatar4 = [[UIImageView alloc] initWithFrame:CGRectMake(widthDelta * 4 + kAvatar_Width * 3, 10, kAvatar_Width, kAvatar_Height)];
        [userAvatar4 setImage:[UIImage imageNamed:@"add_member"]];
        username4 = [[UILabel alloc] initWithFrame:CGRectMake(widthDelta * 4 + kAvatar_Width * 3, 65, kAvatar_Width, kUsername_Label_Height)];
        [username4 setTextAlignment:NSTextAlignmentCenter];
        [username4 setFont:[UIFont systemFontOfSize:16.0f]];
        [self.contentView addSubview:userAvatar4];
        [self.contentView addSubview:username4];
    }
    return self;
}

- (NSArray*)avatarArray {
    return @[userAvatar1, userAvatar2, userAvatar3, userAvatar4];
}

- (NSArray*)usernameArray {
    return @[username1, username2, username3, username4];
}

+ (CGFloat)cellHeight {
    return kCell_Height;
}

@end
