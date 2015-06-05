//
//  DSCommentViewController.m
//  DSLolita
//
//  Created by 赛 丁 on 15/6/3.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSCommentViewController.h"
#import "DSAVComment.h"
#import "DSComment.h"
#import "DSHttpTool.h"
#import "MJExtension.h"
#import "DSUser.h"
#import "UIImageView+WebCache.h"
#import "DSLoadMoreFooter.h"
#import "DSCommentCellFrame.h"
#import "DSCommentCell.h"
#import "DSStatusToolbar.h"
#import "DSComposeViewController.h"
#import "DSNavigationController.h"


@interface DSCommentViewController ()

@property (nonatomic , strong) DSHttpTool *HttpToolManager;
@property (nonatomic , strong) NSMutableArray *commentsFrame;

@end

@implementation DSCommentViewController


- (DSHttpTool *)HttpToolManager {
    if (_HttpToolManager == nil){
        _HttpToolManager = [[DSHttpTool alloc] init];
    }
    return _HttpToolManager;
}

- (NSMutableArray *)commentsFrame {
    if(_commentsFrame == nil){
        _commentsFrame = [NSMutableArray array];
    }
    return _commentsFrame;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupNavigationItem];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.backgroundColor = DSGlobleTableViewBackgroundColor;
    
    
}



- (void)setupNavigationItem {
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem BarButtonItemWithBackgroudImageName:@"timeline_icon_add_friends" highBackgroudImageName:@"timeline_icon_add_friends" target:self action:@selector(jumpToPost)];

}


- (void)refresh {
    
    AVQuery *query = [AVQuery queryWithClassName:@"Album"];
    [query includeKey:@"comments"]; //Pointer查询要包含类中的key
    AVObject *object = [query getObjectWithId:self.object.objectId];
    NSArray *comments = [object objectForKey:@"comments"];
    
    //按发送时间排序
    NSMutableArray *tempbox = [NSMutableArray array];
    for (AVObject *c in comments){
        [tempbox insertObject:c atIndex:0];
    }
    self.comments = tempbox;
    

}



-(void)runInMainQueue:(void (^)())queue{
    dispatch_async(dispatch_get_main_queue(), queue);
}

-(void)runInGlobalQueue:(void (^)())queue{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), queue);
}

- (void)jumpToPost {
    
    DSComposeViewController *compose = [[DSComposeViewController alloc] init];
    compose.source = @"comment";
    compose.object = self.object;
    compose.commentVc = self;
    DSNavigationController *nav = [[DSNavigationController alloc] initWithRootViewController:compose];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    
}

- (NSArray *)commentFramesWithStatuses:(NSArray *)comments {
    
    NSMutableArray *frames = [NSMutableArray array];
    for (DSComment *comment in comments) {
        DSCommentCellFrame *frame = [[DSCommentCellFrame alloc] init];
        frame.commentData = comment;
        [frames addObject:frame];
        
    }
    return frames;
}

-(void)setComments:(NSArray *)comments {
    
    NSLog(@"new comments set");
    
    _comments = comments;
    
    NSArray *commentData = [self.HttpToolManager showCommentFromAVObject:comments];
    
    NSArray *newFrames = [self commentFramesWithStatuses:commentData];
    
    
    [self.commentsFrame removeAllObjects];
    NSRange range = NSMakeRange(0, newFrames.count);
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.commentsFrame insertObjects:newFrames atIndexes:indexSet];
    [self.tableView reloadData];
    
}




#pragma mark - tableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.commentsFrame.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DSCommentCell *cell = [DSCommentCell cellWithTableView:tableView];
    cell.commentFrame = self.commentsFrame[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DSCommentCellFrame *cellFrame = self.commentsFrame[indexPath.row];
    return cellFrame.cellHeight;
}





@end
