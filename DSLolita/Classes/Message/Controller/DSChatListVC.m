//
//  DSChatListVC.m
//  DSLolita
//
//  Created by 赛 丁 on 15/6/5.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSChatListVC.h"
#import "DSSessionStateView.h"
#import "DSStorage.h"
#import "DSImageTwoLabelTableCell.h"
#import "UIView+XHRemoteImage.h"

@interface DSChatListVC ()<DSSessionStateProtocal>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) DSSessionStateView* networkStateView;

@property (nonatomic,strong) UIRefreshControl* refreshControl;

@property (nonatomic,strong) NSMutableArray* rooms;

@property (nonatomic,strong) DSNotify* notify;

@property (nonatomic,strong) DSIM* im;

@property (nonatomic,strong) DSStorage* storage;

@property (nonatomic,strong) DSIMConfig* imConfig;

@end

static NSMutableArray* cacheConvs;

@implementation DSChatListVC

static NSString *cellIdentifier = @"ContactCell";

- (instancetype)init {
    if ((self = [super init])) {
        _rooms=[[NSMutableArray alloc] init];
        _im=[DSIM sharedInstance];
        _storage=[DSStorage sharedInstance];
        _notify=[DSNotify sharedInstance];
        _imConfig=[DSIMConfig config];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString* nibName=NSStringFromClass([DSImageTwoLabelTableCell class]);
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.backgroundColor = DSGlobleTableViewBackgroundColor;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:cellIdentifier];
    
    [self.tableView addSubview:self.refreshControl];
    
    _networkStateView=[[DSSessionStateView alloc] initWithWidth:self.tableView.frame.size.width];
    [_networkStateView setDelegate:self];
    [_networkStateView observeSessionUpdate];
    
    [_notify addMsgObserver:self selector:@selector(refresh)];
    [_notify addSessionObserver:self selector:@selector(sessionChanged)];
}

-(UIRefreshControl*)refreshControl{
    if(_refreshControl==nil){
        _refreshControl=[[UIRefreshControl alloc] init];
        [_refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self runAfterSecs:0.5 block:^{
        [self refresh:nil];
    }];
}

-(void)sessionChanged{
}

-(void)refresh{
    [self refresh:nil];
}

-(void)stopRefreshControl:(UIRefreshControl*)refreshControl{
    if(refreshControl!=nil && [[refreshControl class] isSubclassOfClass:[UIRefreshControl class]]){
        [refreshControl endRefreshing];
    }
}

-(void)refresh:(UIRefreshControl*)refreshControl{
    if([_im isOpened]==NO){
        [self stopRefreshControl:refreshControl];
        //return;
    }
    NSMutableArray* rooms=[[_storage getRooms] mutableCopy];
    [self showNetworkIndicator];
    [self.im cacheAndFillRooms:rooms callback:^(BOOL succeeded, NSError *error) {
        [self hideNetworkIndicator];
        [self stopRefreshControl:refreshControl];
        if([self filterError:error]){
            _rooms=rooms;
            [self.tableView reloadData];
            NSInteger totalUnreadCount=0;
            for(DSRoom* room in _rooms){
                totalUnreadCount+=room.unreadCount;
            }
            if([self.chatListDelegate respondsToSelector:@selector(setBadgeWithTotalUnreadCount:)]){
                [self.chatListDelegate setBadgeWithTotalUnreadCount:totalUnreadCount];
            }
        }
    }];
}

- (void)dealloc{
    [_notify removeMsgObserver:self];
    [_notify removeSessionObserver:self];
}

#pragma table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_rooms count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DSImageTwoLabelTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    DSRoom* room = [_rooms objectAtIndex:indexPath.row];
    if(room.conv.type==DSConvTypeSingle){
        id<DSUserModel> user= [self.imConfig.userDelegate getUserById:room.conv.otherId];
        cell.topLabel.text=user.username;
        [cell.myImageView setImageWithURL:[NSURL URLWithString:user.avatarUrl]];
    }else{
        [cell.myImageView setImage:room.conv.icon];
        cell.topLabel.text=room.conv.displayName;
    }
    cell.bottomLabel.text=[self.im getMsgTitle:room.lastMsg];
    cell.unreadCount=room.unreadCount;
    if(room.lastMsg){
        NSDateFormatter* dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
        NSString* timeString=[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:room.lastMsg.sendTimestamp/1000]];
        cell.rightLabel.text=timeString;
    }else{
        cell.rightLabel.text=@"";
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle==UITableViewCellEditingStyleDelete){
        DSRoom* room = [_rooms objectAtIndex:indexPath.row];
        [_storage deleteRoomByConvid:room.conv.conversationId];
        [self refresh];
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return true;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DSRoom *room = [_rooms objectAtIndex:indexPath.row];
    if([self.chatListDelegate respondsToSelector:@selector(viewController:didSelectConv:)]){
        [self.chatListDelegate viewController:self didSelectConv:room.conv];
    }
}

#pragma mark -- DSSessionDelegateMethods

-(void)onSessionBrokenWithStateView:(DSSessionStateView *)view{
    self.tableView.tableHeaderView=view;
}

-(void)onSessionFineWithStateView:(DSSessionStateView *)view{
    self.tableView.tableHeaderView=nil;
}

@end
