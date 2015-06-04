//
//  DSCommentViewController.h
//  DSLolita
//
//  Created by 赛 丁 on 15/6/3.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DSCommentViewController : UITableViewController

@property (nonatomic ,strong) NSArray *comments;
@property (nonatomic , strong) AVObject *object;

- (void)refresh;
@end
