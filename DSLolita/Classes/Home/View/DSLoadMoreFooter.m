//
//  DSLoadMoreFooter.m
//  DSLolita
//
//  Created by 赛 丁 on 15/5/26.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSLoadMoreFooter.h"


@interface DSLoadMoreFooter()

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;


@end

@implementation DSLoadMoreFooter

+ (instancetype)footer {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"DSLoadMoreFooter" owner:nil options:nil] lastObject];
}

- (void)beginRefreshing {
    
    self.statusLabel.text = @"正在拼命加载数据...";
    
    [self.loadingView startAnimating];
    self.refreshing = YES;
}

-(void)endRefreshing {
    
    self.statusLabel.text = @"没有更多数据了";
    [self.loadingView stopAnimating];
    self.refreshing = NO;
}


@end
