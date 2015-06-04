//
//  DSMessageViewController.m
//  DSLolita
//
//  Created by 赛 丁 on 15/5/25.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSMessageViewController.h"
#import "ConversationStore.h"
#import "ChatViewController.h"
#import "ConversationUtils.h"
#import "DSMessageCell.h"
#import "DSMessageData.h"


NSString * kConversationCellIdentifier = @"ConversationIdentifier";

@interface DSMessageViewController () <IMEventObserver>

@property (nonatomic , strong) NSArray *AVObjects;

@end

@implementation DSMessageViewController


- (NSMutableArray *)recentConversations{
    if (_recentConversations == nil){
        _recentConversations = [NSMutableArray array];
    }
    return _recentConversations;
}

- (NSArray *)AVObjects {
    
    if (_AVObjects == nil){
        _AVObjects = [[NSArray alloc] init];
    }
    
    return _AVObjects;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    

    self.tableView.backgroundColor = DSGlobleTableViewBackgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    ConversationStore *store = [ConversationStore sharedInstance];
    [store addEventObserver:self forConversation:@"*"];
    
}



- (void)viewDidUnload {
    [super viewDidUnload];
    ConversationStore *store = [ConversationStore sharedInstance];
    [store removeEventObserver:self forConversation:@"*"];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    AVIMClient *imclient = [[ConversationStore sharedInstance] imClient];
    AVIMConversationQuery *query = [imclient conversationQuery];
    [query whereKey:kAVIMKeyMember containedIn:@[[AVUser currentUser].objectId]];
    [query whereKey:AVIMAttr(@"type") equalTo:[NSNumber numberWithInt:kConversationType_OneOne]];
    [query findConversationsWithCallback:^(NSArray *objects , NSError *error){
       
        if (!error){
            
            self.AVObjects = [NSArray arrayWithArray:objects];
            
            
            
        }
    }];

    
    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.recentConversations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DSMessageCell *cell = [DSMessageCell cellWithTableView:tableView];
    AVIMConversation *convsation = self.recentConversations[indexPath.row];
    NSLog(@"%@",convsation.name);
    return cell;
}


@end
