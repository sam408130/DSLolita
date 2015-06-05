//
//  AVStatus.h
//  DSLolita
//
//  Created by 赛 丁 on 15/5/27.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface DSAVStatus : AVObject<AVSubclassing>

@property (nonatomic , strong) AVUser *creator;
@property (nonatomic , copy) NSString *statusContent;
@property (nonatomic , assign) NSArray *albumPhotos;
@property (nonatomic , assign) NSArray *comments;
@property (nonatomic , assign) NSArray *digUsers;

@end
