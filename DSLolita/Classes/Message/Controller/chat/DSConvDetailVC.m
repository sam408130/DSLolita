//
//  DSConvDetailVC.m
//  DSLolita
//
//  Created by 赛 丁 on 15/6/5.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSConvDetailVC.h"
//#import "DSAddMemberVC.h"
#import "DSUserInfoVC.h"
#import "DSConvNameVC.h"
#import "DSConvDetailMembersCell.h"
//#import "DSConvReportAbuseVC.h"
#import "DSCache.h"

static NSString *kCDConvDetailVCTitleKey=@"title";
static NSString *kCDConvDetailVCDisclosureKey=@"disclosure";
static NSString *kCDConvDetailVCDetailKey=@"detail";
static NSString *kCDConvDetailVCSelectorKey=@"selecotr";

static CGFloat kCDConvDetailVCHorizontalPadding=10;

static NSString *switchCellIdentifier=@"switch";

@interface DSConvDetailVC ()<UIGestureRecognizerDelegate,UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,DSConvDetailMembersHeaderViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic,strong) DSConvDetailMembersCell *membersCell;

@property DSIM* im;

@property BOOL own;

@property DSConvType type;

@property DSStorage* storage;

@property DSNotify* notify;

@property (nonatomic,strong) AVUser *longPressedMember;

@property (nonatomic,strong) NSArray* members;

@property (nonatomic,strong) NSArray *dataSource;

@property (nonatomic,strong) UITableViewCell *switchCell;

@end

@implementation DSConvDetailVC

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)init
{
    self = [super init];
    if (self) {
        _im=[DSIM sharedInstance];
        _notify=[DSNotify sharedInstance];
        _storage=[DSStorage sharedInstance];
        _type=self.conv.type;
        self.tableViewStyle=UITableViewStyleGrouped;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.clearsSelectionOnViewWillAppear = NO;
    
    self.view.backgroundColor=DSGlobleTableViewBackgroundColor;
    [_notify addConvObserver:self selector:@selector(refresh)];
    [self setupDatasource];
    [self refresh];
}

-(void)setupDatasource{
    NSDictionary *dict1=@{kCDConvDetailVCTitleKey:@"清空聊天记录",
                          kCDConvDetailVCSelectorKey:NSStringFromSelector(@selector(deleteMsgs))};
    NSDictionary *dict2=@{kCDConvDetailVCTitleKey:@"举报",
                          kCDConvDetailVCDisclosureKey:@YES,
                          kCDConvDetailVCSelectorKey:NSStringFromSelector(@selector(goReportAbuse))};
    NSDictionary *dict3=@{kCDConvDetailVCTitleKey:@"消息免打扰"};
    if(_type==DSConvTypeGroup){
        self.dataSource = @[@{kCDConvDetailVCTitleKey:@"群聊名称",
                              kCDConvDetailVCDisclosureKey:@YES,
                              kCDConvDetailVCDetailKey:self.conv.displayName,
                              kCDConvDetailVCSelectorKey:NSStringFromSelector(@selector(goChangeName))},
                            dict3,dict1,dict2,
                            @{kCDConvDetailVCTitleKey:@"删除并退出",
                              kCDConvDetailVCSelectorKey:NSStringFromSelector(@selector(quitConv))}];
    }else{
        self.dataSource=@[dict3,dict1,dict2];
    }
}

-(DSConvDetailMembersCell*)membersCell{
    if(_membersCell==nil){
        _membersCell=[[DSConvDetailMembersCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[DSConvDetailMembersCell reuseIdentifier]];
        _membersCell.membersCellDelegate=self;
    }
    return _membersCell;
}

-(UITableViewCell*)switchCell{
    if(_switchCell==nil){
        _switchCell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:switchCellIdentifier];
        UISwitch *theSwitch=[[UISwitch alloc] initWithFrame:CGRectZero];
        CGRect frame=theSwitch.frame;
        frame.origin=CGPointMake(CGRectGetWidth(self.view.frame)-CGRectGetWidth(theSwitch.frame)-kCDConvDetailVCHorizontalPadding, (44-CGRectGetHeight(theSwitch.frame))/2);
        theSwitch.frame=frame;
        [theSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        [theSwitch setOn:self.conv.muted];
        [_switchCell addSubview:theSwitch];
    }
    return _switchCell;
}

-(AVIMConversation*)conv{
    return [DSCache getCurConv];
}

-(void)refresh{
    AVIMConversation* conv=[self conv];
    NSSet* userIds=[NSSet setWithArray:conv.members];
    WEAKSELF
    NSString* curUserId=[AVUser currentUser].objectId;
    _own=[conv.creator isEqualToString:curUserId];
    [self setupBarButton];
    self.title=[NSString stringWithFormat:@"详情(%ld人)",(long)self.conv.members.count];
    [DSCache cacheUsersWithIds:userIds callback:^(BOOL succeeded, NSError *error) {
        [DSUtils filterError:error callback:^{
            NSMutableArray *memberUsers=[NSMutableArray array];
            for(NSString* userId in userIds){
                [memberUsers addObject:[DSCache lookupUser:userId]];
            }
            weakSelf.members=memberUsers;
            weakSelf.membersCell.members=memberUsers;
            [weakSelf.tableView reloadData];
        }];
    }];
}

-(void)setupBarButton{
    UIBarButtonItem* addMember=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addMember)];
    self.navigationItem.rightBarButtonItem=addMember;
}

-(void)quitConv{
    [self.conv quitWithCallback:^(BOOL succeeded, NSError *error) {
        if([DSUtils filterError:error]){
            [_storage deleteRoomByConvid:self.conv.conversationId];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

-(void)longPressUser:(UILongPressGestureRecognizer*)gestureRecognizer{
    if(gestureRecognizer.state!=UIGestureRecognizerStateBegan){
        return;
    }
    CGPoint p=[gestureRecognizer locationInView:self.collectionView];
    NSIndexPath* indexPath=[self.collectionView indexPathForItemAtPoint:p];
    if(indexPath==nil){
        DLog(@"can't not find index path");
    }else{
        if(_own){
            AVIMConversation* conv=[self conv];
            NSString* userId=[conv.members objectAtIndex:indexPath.row];
            if([userId isEqualToString:conv.creator]==NO){
                UIAlertView * alert=[[UIAlertView alloc]
                                     initWithTitle:nil message:@"确定要踢走该成员吗？"  delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                alert.tag=indexPath.row;
                [alert show];
            }
        }
    }
}

-(void)dealloc{
    [_notify removeConvObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)addMember{
//    DSAddMemberVC *controller=[[DSAddMemberVC alloc] init];;
//    controller.groupDetailVC=self;
//    UINavigationController* nav=[[UINavigationController alloc] initWithRootViewController:controller];
//    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma mark - tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 	2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0){
        return 1;
    }else{
        return self.dataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        DSConvDetailMembersCell* membersCell=[tableView dequeueReusableCellWithIdentifier:[DSConvDetailMembersCell reuseIdentifier]];
        if(membersCell==nil){
            membersCell=self.membersCell;
        }
        return membersCell;
    }else{
        UITableViewCell *cell;
        if((self.type==DSConvTypeGroup && indexPath.row==1)
           || (self.type==DSConvTypeSingle && indexPath.row==0)){
            cell=[tableView dequeueReusableCellWithIdentifier:switchCellIdentifier];
            if(cell==nil){
                cell=self.switchCell;
            }
        }else{
            static NSString *identifier=@"Cell";
            cell=[tableView dequeueReusableCellWithIdentifier:identifier];
            if(cell==nil){
                cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            }
        }
        
        NSDictionary *data=self.dataSource[indexPath.row];
        NSString *title=[data objectForKey:kCDConvDetailVCTitleKey];
        cell.textLabel.text=title;
        NSString *detail=[data objectForKey:kCDConvDetailVCDetailKey];
        if(detail){
            cell.detailTextLabel.text=self.conv.displayName;
        }else{
            cell.detailTextLabel.text=nil;
        }
        BOOL disclosure=[[data objectForKey:kCDConvDetailVCDisclosureKey] boolValue];
        if(disclosure){
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        return [DSConvDetailMembersCell heightForMembers:self.members];
    }else{
        return 44;
    }
}

-(void)deleteMsgs{
    [_storage deleteMsgsByConvid:self.conv.conversationId];
    [DSUtils alert:@"已清空"];
}

-(void)goChangeName{
    DSConvNameVC* vc=[[DSConvNameVC alloc] init];
    vc.detailVC=self;
    vc.conv=self.conv;
    UINavigationController* nav=[[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section==0){
        return;
    }
    NSString *selectorName=[[self.dataSource objectAtIndex:indexPath.row] objectForKey:kCDConvDetailVCSelectorKey];
    if(selectorName){
        [self performSelector:NSSelectorFromString(selectorName) withObject:nil afterDelay:0];
    }
}

-(void)didLongPressMember:(AVUser *)member{
    if(_own){
        AVIMConversation* conv=[self conv];
        if([member.objectId isEqualToString:conv.creator]==NO){
            UIAlertView * alert=[[UIAlertView alloc]
                                 initWithTitle:nil message:@"确定要踢走该成员吗？"  delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            self.longPressedMember=member;
            [alert show];
        }
    }
}


- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        WEAKSELF
        [self.conv removeMembersWithClientIds:@[self.longPressedMember.objectId] callback:^(BOOL succeeded, NSError *error) {
            weakSelf.longPressedMember=nil;
            if([DSUtils filterError:error]){
                [DSCache refreshCurConv:^(BOOL succeeded, NSError *error) {
                    if([DSUtils filterError:error]){
                    }
                }];
            }
        }];
    }
}

-(void)didSelectMember:(AVUser *)member{
    NSString* curUserId=[AVUser currentUser].objectId;
    if([curUserId isEqualToString:member.objectId]==YES){
        return ;
    }
    DSUserInfoVC* userInfoVC=[[DSUserInfoVC alloc] initWithUser:member];
    [self.navigationController pushViewController:userInfoVC animated:YES];
}

-(void)goReportAbuse{
//    DSConvReportAbuseVC *reportAbuseVC=[[DSConvReportAbuseVC alloc] initWithConvid:self.conv.conversationId];
//    [self.navigationController pushViewController:reportAbuseVC animated:YES];
}

#pragma mark - Swtich
-(void)switchValueChanged:(UISwitch*)theSwitch{
    if([theSwitch isOn]){
        [self.conv muteWithCallback:^(BOOL succeeded, NSError *error) {
            if([DSUtils filterError:error]){
                
            }
        }];
    }else{
        [self.conv unmuteWithCallback:^(BOOL succeeded, NSError *error) {
            if([DSUtils filterError:error]){
                
            }
        }];
    }
}

@end
