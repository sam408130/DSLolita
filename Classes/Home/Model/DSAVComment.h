//
//  DSAVComment.h
//  DSLolita
//
//  Created by 赛 丁 on 15/5/27.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
@class DSAVStatus;

#define KEY_ALBUM @"status"
#define KEY_COMMENT_USER @"commentUser"
#define KEY_COMMENT_USERNAME @"commentUsername"
#define KEY_COMMENT_CONTENT @"commentContent"
#define KEY_TO_USER @"toUser"

@interface DSAVComment : AVObject<AVSubclassing>

@property (nonatomic,strong) AVObject *status;//关联分享
@property (nonatomic,strong) NSString  *commentUsername;
@property (nonatomic,strong) AVUser *commentUser;//评论用户
@property (nonatomic,strong) NSString *commentContent;//评论内容
@property (nonatomic,strong) AVUser *toUser;//关联用户
@property (nonatomic,strong) NSString *avatarUrl;

@end
