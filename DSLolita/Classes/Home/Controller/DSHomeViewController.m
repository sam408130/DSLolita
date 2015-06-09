//
//  DSHomeViewController.m
//  DSLolita
//
//  Created by 赛 丁 on 15/5/25.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSHomeViewController.h"
#import "DSTitleButton.h"
#import "DSStatus.h"
#import "MJExtension.h"
#import "DSUser.h"
#import "UIImageView+WebCache.h"
#import "DSLoadMoreFooter.h"
#import "DSStatusFrame.h"
#import "DSStatusCell.h"
#import "DSStatusOriginalView.h"
#import "DSStatusDetailView.h"
#import "DSHomeStatus.h"
#import "DSHttpTool.h"
#import "DSPopMenu.h"
#import "DSCommentViewController.h"
#import "DSComposeViewController.h"
#import "DSIMService.h"


@interface DSHomeViewController () <UIActionSheetDelegate,DSStatusCellDelegate>

@property (nonatomic , strong) NSMutableArray *statusesFrame;
@property (nonatomic , strong) NSMutableArray *loadedObjects;
@property (nonatomic , strong) NSMutableArray *needLoadArr;
@property (nonatomic , weak) DSLoadMoreFooter *footer;
@property (nonatomic , weak) DSTitleButton *titleButton;
@property (nonatomic , strong) DSHttpTool *HttpToolManager;
@property (nonatomic , strong) DSHomeStatus *homeStatus;
@property (nonatomic , strong) NSMutableArray *AVObjects;

@end

@implementation DSHomeViewController



- (NSMutableArray *)statusesFrame {
    
    if (_statusesFrame == nil) {
        _statusesFrame = [NSMutableArray array];
    }
    
    return _statusesFrame;
}

- (NSMutableArray *)needLoadArr {
    
    if (_needLoadArr == nil) {
        _needLoadArr = [NSMutableArray array];
    }
    
    return _needLoadArr;
}

- (NSMutableArray *)loadedObjects{
    if (_loadedObjects == nil){
        _loadedObjects = [NSMutableArray array];
    }
    return _loadedObjects;
}

- (NSMutableArray *)AVObjects {
    
    if (_AVObjects == nil){
        _AVObjects = [NSMutableArray array];
    }
    
    return _AVObjects;
}

- (DSHttpTool *)HttpToolManager {
    if (_HttpToolManager == nil){
        _HttpToolManager = [[DSHttpTool alloc] init];
    }
    return _HttpToolManager;
}


- (void)setupCenterTitle{
    
    //创建导航中间标题按钮
    DSTitleButton *titleButton = [[DSTitleButton alloc] init];
    titleButton.height = DSNavigationItemOfTitleViewHeight;
    
    //设置文字
    [titleButton setTitle:[DSUser readLocalUser].username ? [DSUser readLocalUser].username : @"首页" forState:UIControlStateNormal];
    //设置图标
    UIImage *mainImage = [[UIImage imageWithName:@"main_badge"] scaleImageWithSize:CGSizeMake(10, 10)];
    
    [titleButton setImage:mainImage forState:UIControlStateNormal];
    //设置背景
    [titleButton setBackgroundImage:[UIImage resizableImageWithName:@"navigationbar_filter_background_highlighted"] forState:UIControlStateHighlighted];
    //监听点击
    [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleButton;
    self.titleButton = titleButton;
    
    //获取用户信息
    [self setupUserInfo];
    
}

- (void)setupUserInfo {
    
    AVUser *currentUser = [AVUser currentUser];
    if (currentUser != nil) {
        
        [DSUser save:currentUser];
    }else{
        NSLog(@"获取用户昵称失败");
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    // 1.设置导航栏
    [self setupNavigationItem];
    
    // 2.删除分割线
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    // 3.刷新控件
    [self setupRefresh];
    
    self.tableView.backgroundColor = DSGlobleTableViewBackgroundColor;
    
    // 4.监听更多按钮被点击通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusOriginalViewDidClickedMoreButton:) name:DSStatusOriginalDidMoreNotication object:nil];
    
    // 6. 监听文本链接
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(linkDidSelected:) name:DSLinkDidSelectedNotification object:nil];
    // 7. 普通文本链接
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusNormalTextDidSelected:) name:DSStatusNormalTextDidSelectedNotification object:nil];
    

}


//跳转到正文，可以是评论界面
- (void)statusNormalTextDidSelected:(NSNotification *)notification {
    NSLog(@"跳转cell：到正文");
    UIViewController *newVc = [[UIViewController alloc] init];
    newVc.view.backgroundColor = [UIColor redColor];
    newVc.title = @"正文";
    [self.navigationController pushViewController:newVc animated:YES];
    
}

- (void)linkDidSelected:(NSNotification *)notification {
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)setupNavigationItem {
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem BarButtonItemWithBackgroudImageName:@"navigationbar_friendsearch" highBackgroudImageName:@"navigationbar_friendsearch_highlighted" target:self action:@selector(friendsearch)];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem BarButtonItemWithBackgroudImageName:@"navigationbar_pop" highBackgroudImageName:@"navigationbar_pop_highlighted" target:self action:@selector(pop)];
    
    [self setupCenterTitle];
}

- (void)setupRefresh {
    
    // 1.添加下拉刷新
    UIRefreshControl *refreshController = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:refreshController];
    
    // 2.监听状态
    [refreshController addTarget:self action:@selector(refreshControlStateChange:) forControlEvents:UIControlEventValueChanged];
    
    // 3.让刷新控件自动进入刷新状态
    [refreshController beginRefreshing];
    
    // 4.加载数据
    [self refreshControlStateChange:refreshController];
    
    // 5.添加上拉加载更多控件
    DSLoadMoreFooter *footer = [DSLoadMoreFooter footer];
    self.tableView.tableFooterView = footer;
    self.footer = footer;
}

/**
 *  当下拉刷新控件进入刷新状态（转圈圈）的时候会自动调用
 */
- (void) refreshControlStateChange:(UIRefreshControl *)refreshControl
{
    
    [self loadNewStatuses:refreshControl];

    
    
}

- (NSArray *)statusFramesWithStatuses:(NSArray *)statuses {
    
    NSMutableArray *frames = [NSMutableArray array];
    for (DSStatus *status in statuses) {
        DSStatusFrame *frame = [[DSStatusFrame alloc] init];
        frame.status = status;
        [frames addObject:frame];
        
    }
    return frames;
}



#pragma mark - 加载数据
/**
 *  加载最新的数据
 */
- (void)loadNewStatuses:(UIRefreshControl *)refreshControl{
    
    typeof(self) __weak weakSelf= self;
    
    [self.HttpToolManager findStatusWithBlock:^(NSArray *objects , NSError *error){
        
        NSLog(@"%d loaded" , (int)objects.count);
        if (!error){
            int currentFeeds = 0;
            
            if (self.homeStatus.statuses){
                
                currentFeeds = (int)self.homeStatus.statuses.count;
            }
            
            self.homeStatus = [weakSelf.HttpToolManager showHomestatusFromAVObjects:objects];


            //获得新数据的frame数组
            NSArray *newFrames = (NSArray *)[weakSelf statusFramesWithStatuses:self.homeStatus.statuses];
            
            // 将新数据插入到旧数据的最前面
            NSRange range = NSMakeRange(0, newFrames.count);
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            [weakSelf.statusesFrame removeAllObjects];
            [weakSelf.statusesFrame insertObjects:newFrames atIndexes:indexSet];
            [weakSelf.loadedObjects removeAllObjects];
            [weakSelf.loadedObjects insertObjects:self.homeStatus.loadedObjectIDs atIndexes:indexSet];
            
            [weakSelf.AVObjects removeAllObjects];
            [weakSelf.AVObjects insertObjects:objects atIndexes:indexSet];
            // 重新刷新表格
            [weakSelf.tableView reloadData];
            
            // 让刷新控件停止刷新
            [refreshControl endRefreshing];
            
            //提示用户刷新的Feed个数
            int newF = (int)newFrames.count - currentFeeds;
            [weakSelf showNewStatusesCount:newF];
            
            // 首页图标数据清零
            [UIApplication sharedApplication].applicationIconBadgeNumber -= weakSelf.tabBarItem.badgeValue.intValue;
            weakSelf.tabBarItem.badgeValue = nil;

            
        }else{
            NSLog(@"请求失败,请检查网络");
            
        }
 
        
    }];
    
}


/**
 *  提示用户最新的微博数量
 *
 *  @param count 最新的微博数量
 */
- (void)showNewStatusesCount:(int)count
{
    // 1.创建一个UILabel
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:12];
    
    // 2.显示文字
    if (count) {
        label.text = [NSString stringWithFormat:@"共有%d条新的数据", count];
    } else {
        label.text = @"没有最新的数据";
    }
    
    // 3.设置背景
    label.backgroundColor = DSCommonColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    
    // 4.设置frame
    label.width = self.view.width;
    label.height = 35;
    label.x = 0;
    label.y = DSNavigationHeight - label.height;
    
    // 5.添加到导航控制器的view
    //    [self.navigationController.view addSubview:label];
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    
    // 6.动画
    CGFloat duration = 0.75;
    //    label.alpha = 0.0;
    [UIView animateWithDuration:duration animations:^{
        // 往下移动一个label的高度
        label.transform = CGAffineTransformMakeTranslation(0, label.height);
        //        label.alpha = 1.0;
    } completion:^(BOOL finished) { // 向下移动完毕
        
        // 延迟delay秒后，再执行动画
        CGFloat delay = 1.0;
        
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            // 恢复到原来的位置
            label.transform = CGAffineTransformIdentity;
            //            label.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            
            // 删除控件
            [label removeFromSuperview];
        }];
    }];
}



- (void)loadMoreStatuses {
    
    
    [self.HttpToolManager findMoreStatusWithBlock:self.loadedObjects block:^(NSArray *objects , NSError *error){
  
        if (!error){
            DSHomeStatus *tempHomeStatus = [self.HttpToolManager showHomestatusFromAVObjects:objects];
            [self.homeStatus.statuses addObjectsFromArray:tempHomeStatus.statuses];
            NSArray *newFrames = [self statusFramesWithStatuses:tempHomeStatus.statuses];
            [self.footer endRefreshing];
            // 将新数据插入到旧数据的最后面
            [self.statusesFrame addObjectsFromArray:newFrames];
            [self.loadedObjects addObjectsFromArray:tempHomeStatus.loadedObjectIDs];
            [self.AVObjects addObjectsFromArray:objects];
            NSLog(@"增加数据中");
            // 重新刷新表格
            [self.tableView reloadData];
            
        }else{
            NSLog(@"请求失败");
            [self.footer endRefreshing];
        }
        
    }];

}



/**
 *  点击标题点击
 */
- (void)titleClick:(UIButton *)titleButton
{
    
    
    // 弹出菜单
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    
    DSPopMenu *menu = [[DSPopMenu alloc] initWithContentView:button];
    menu.arrowPosition = DSPopMenuArrowPositionCenter;
    
    [menu showInRect:CGRectMake((self.view.frame.size.width-217)/2.0,CGRectGetMaxY([self.navigationController navigationBar].frame)-DSPopMenuMarginTop, 217, 400)];
    
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    self.footer.hidden = self.statusesFrame.count == 0 ;
    return self.statusesFrame.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DSStatusCell *cell = [DSStatusCell cellWithTableView:tableView];
    cell.statusFrame = self.statusesFrame[indexPath.row];
    NSLog(@"number %d cell loaded",indexPath.row);
    cell.delegate = self;
    cell.indexpath = indexPath;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DSStatusFrame *statusFrame = self.statusesFrame[indexPath.row];
    return statusFrame.cellHeight;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *newVc = [[UIViewController alloc] init];
    newVc.view.backgroundColor = [UIColor redColor];
    newVc.title = @"新控制器";
    [self.navigationController pushViewController:newVc animated:YES];
}



- (void)didLikeButtonClicked:(UIButton *)button indexPath:(NSIndexPath *)indexpath {
    
    DSStatus *status = [self.homeStatus.statuses objectAtIndex:indexpath.row];

    
    [self.HttpToolManager digOrCancelDigOfStatus:status sender:button block:^(BOOL succeeded , NSError *error){
        
        if (succeeded){
            
            
        }
    }];
    
}


- (void)didCommentButtonClicked:(UIButton *)button indexPath:(NSIndexPath *)indexpath {
    
    DSStatus *status = self.homeStatus.statuses[indexpath.row];

    DSCommentViewController *vc = [[DSCommentViewController alloc] init];
    vc.comments = status.comments;
    vc.object = self.AVObjects[indexpath.row];
    [self.navigationController pushViewController:vc animated:YES];

    
    
}


- (void)didMessageButtonClicked:(UIButton *)button indexPath:(NSIndexPath *)indexpath {
    
    DSStatus *statue = self.homeStatus.statuses[indexpath.row];
    [[DSIMService shareInstance] goWithUserId:statue.user.userId fromVC:self];
    
}


- (void)didShareButtonClicked:(UIButton *)button indexPath:(NSIndexPath *)indexpath {
    
    OSMessage *msg = [[OSMessage alloc] init];
    msg.title = @"hellow msg.title";
    [OpenShare shareToWeixinTimeline:msg Success:^(OSMessage *message){
        NSLog(@"微信分享到朋友圈成功:\n%@",message);
    }Fail:^(OSMessage *message, NSError *error){
        NSLog(@"微信分享到朋友圈失败:\n%@\%@n",error,message);
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.statusesFrame.count == 0  || self.footer.isRefreshing) return;
    
    // 1.差距
    CGFloat delta = scrollView.contentSize.height - scrollView.contentOffset.y;
    // 刚好能砍到整个footer的高度
    CGFloat seeFootH = self.view.height - self.tabBarController.tabBar.height;
    
    // 2.如果能看到整个footer
    if (delta <= (seeFootH - 0)) {
        // 进入上拉刷新状态
        [self.footer beginRefreshing];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC) ),dispatch_get_main_queue(), ^{
           
            [self loadMoreStatuses];
        });
    }
}






//按需加载 - 如果目标行与当前行相差超过指定行数，只在目标滚动范围的前后指定3行加载。
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    NSIndexPath *ip = [self.tableView indexPathForRowAtPoint:CGPointMake(0, targetContentOffset->y)];
    NSIndexPath *cip = [[self.tableView indexPathsForVisibleRows] firstObject];
    NSInteger skipCount = 8;
    if (labs(cip.row-ip.row)>skipCount) {
        NSArray *temp = [self.tableView indexPathsForRowsInRect:CGRectMake(0, targetContentOffset->y, self.tableView.width, self.tableView.height)];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:temp];
        if (velocity.y<0) {
            NSIndexPath *indexPath = [temp lastObject];
            if (indexPath.row+3<self.homeStatus.statuses.count) {
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:0]];
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row+2 inSection:0]];
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row+3 inSection:0]];
            }
        } else {
            NSIndexPath *indexPath = [temp firstObject];
            if (indexPath.row>3) {
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row-3 inSection:0]];
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row-2 inSection:0]];
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row-1 inSection:0]];
            }
        }
        [_needLoadArr addObjectsFromArray:arr];
    }
}






- (void)pop
{
    NSLog(@"--扫一扫--");
}
- (void)friendsearch
{
    NSLog(@"--好友搜索--");
}

- (void)statusOriginalViewDidClickedMoreButton:(NSNotification *)notification
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"举报",@"屏蔽",@"取消关注",@"收藏", nil];
    [sheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"---点击按钮");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
