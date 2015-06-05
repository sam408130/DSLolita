//
//  DSIMService.m
//  DSLolita
//
//  Created by 赛 丁 on 15/6/5.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSIMService.h"
#import "DSCache.h"
#import "DSUtils.h"
#import "DSUserService.h"
//#import "DSConvDetailVC.h"
#import "DSUser.h"
#import "DSChatVC.h"
#import "DSIM.h"

@interface DSIMService ()

@property (nonatomic,strong) DSIM* im;

@end

@implementation DSIMService

+(instancetype)shareInstance{
    static DSIMService* imService;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imService=[[DSIMService alloc] init];
    });
    return imService;
}

-(instancetype)init{
    self=[super init];
    if(self){
        self.im=[DSIM sharedInstance];
    }
    return self;
}

#pragma mark - user delegate

-(void)cacheUserByIds:(NSSet *)userIds block:(AVBooleanResultBlock)block{
    [DSCache cacheUsersWithIds:userIds callback:block];
}

-(id<DSUserModel>)getUserById:(NSString *)userId{
    DSUser* user=[[DSUser alloc] init];
    AVUser* avUser=[DSCache lookupUser:userId];
    if(user==nil){
        [NSException raise:@"user is nil" format:nil];
    }
    user.userId=userId;
    user.username=avUser.username;
    AVFile* avatarFile=[avUser objectForKey:@"avatar"];
    user.avatarUrl=avatarFile.url;
    return user;
}

-(void)goWithConv:(AVIMConversation*)conv fromNav:(UINavigationController*)nav{
    DSChatVC* chatVC=[[DSChatVC alloc] initWithConv:conv];
    chatVC.hidesBottomBarWhenPushed=YES;
    [nav pushViewController:chatVC animated:YES];
}

-(void)goWithUserId:(NSString*)userId fromVC:(UIViewController*)vc {
    DSIM* im=[DSIM sharedInstance];
    [im fetchConvWithOtherId:userId callback:^(AVIMConversation *conversation, NSError *error) {
        if(error){
            DLog(@"%@",error);
        }else{
            [self goWithConv:conversation fromNav:vc.navigationController];
        }
    }];
}

@end
