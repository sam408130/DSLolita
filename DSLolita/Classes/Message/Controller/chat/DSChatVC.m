//
//  DSChatVC.m
//  DSLolita
//
//  Created by 赛 丁 on 15/6/5.
//  Copyright (c) 2015年 samDing. All rights reserved.
//


#import "DSChatVC.h"
#import "DSCache.h"
#import "DSConvDetailVC.h"
#import "AVIMUserInfoMessage.h"

@interface DSChatVC ()

@end

@implementation DSChatVC

-(instancetype)initWithConv:(AVIMConversation *)conv{
    self=[super initWithConv:conv];
    [DSCache setCurConv:conv];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DSGlobleTableViewBackgroundColor;
    UIImage* _peopleImage=[UIImage imageNamed:@"tabbar_profile_highlighted"];
    UIBarButtonItem* item=[[UIBarButtonItem alloc] initWithImage:_peopleImage style:UIBarButtonItemStyleDone target:self action:@selector(goChatGroupDetail:)];
    self.navigationItem.rightBarButtonItem=item;
    
}

-(void)testSendCustomeMessage{
    AVIMUserInfoMessage* userInfoMessage=[AVIMUserInfoMessage messageWithAttributes:@{@"nickname":@"lzw"}];
    [self.conv sendMessage:userInfoMessage callback:^(BOOL succeeded, NSError *error) {
        DLog(@"%@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)goChatGroupDetail:(id)sender {
    DSConvDetailVC* controller=[[DSConvDetailVC alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

@end