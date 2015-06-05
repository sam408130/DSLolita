//
//  DSUserInfoVC.m
//  DSLolita
//
//  Created by 赛 丁 on 15/6/5.
//  Copyright (c) 2015年 samDing. All rights reserved.
//
#import "DSBaseTableVC.h"
#import "DSUserInfoVC.h"
#import "DSCache.h"
#import "DSUserService.h"
#import "DSUtils.h"
#import "DSIMService.h"

@interface DSUserInfoVC ()

@property (nonatomic,assign) BOOL isFriend;

@property (strong,nonatomic) AVUser *user;

@end

@implementation DSUserInfoVC

-(instancetype)initWithUser:(AVUser*)user{
    self=[super init];
    if(self){
        _isFriend=NO;
        _user=user;
        self.tableViewStyle=UITableViewStyleGrouped;
    };
    return self;
}

#pragma lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"详情";
    [self refresh];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    if(indexPath.section==1){
        if(self.isFriend){
            cell.textLabel.text=@"开始聊天";
        }else{
            cell.textLabel.text=@"添加好友";
        }
        cell.textLabel.textAlignment=NSTextAlignmentCenter;
    }else{
        cell.textLabel.text=self.user.username;
        cell.textLabel.textAlignment=NSTextAlignmentLeft;
        [DSUserService displayBigAvatarOfUser:self.user avatarView:cell.imageView];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        return 88;
    }else{
        return 44;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section==1){
        if(self.isFriend){
            [[DSIMService shareInstance] goWithUserId:self.user.objectId fromVC:self];
        }else{
            [DSUtils showNetworkIndicator];
            [DSUserService tryCreateAddRequestWithToUser:_user callback:^(BOOL succeeded, NSError *error) {
                [DSUtils hideNetworkIndicator];
                if([DSUtils filterError:error]){
                    [DSUtils alert:@"请求成功"];
                }
            }];
        }
    }
}

-(void)refresh{
    WEAKSELF
    [DSUserService isMyFriend:_user block:^(BOOL isFriend, NSError *error) {
        if([DSUtils filterError:error]){
            weakSelf.isFriend=isFriend;
            [weakSelf.tableView reloadData];
        }
    }];
}

@end
