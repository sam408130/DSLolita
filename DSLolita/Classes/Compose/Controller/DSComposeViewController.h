//
//  DSComposeViewController.h
//  DSLolita
//
//  Created by 赛 丁 on 15/5/25.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSHomeViewController.h"
@class DSCommentViewController;
@interface DSComposeViewController : UIViewController

@property (nonatomic , strong) DSHomeViewController *homeVc;
@property (nonatomic , assign) NSString *source;
@property (nonatomic , strong) AVObject *object;
@property (nonatomic , strong) DSCommentViewController* commentVc;

@end
