//
//  DSStatusFrame.m
//  DSLolita
//
//  Created by 赛 丁 on 15/5/26.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSStatusFrame.h"
#import "DSStatusDetailFrame.h"
#import "DSStatus.h"


@implementation DSStatusFrame

- (void)setStatus:(DSStatus *)status {
    
    _status = status;
    
    [self setupStatusDetailFrame];
    
    [self setupStatusToolbarFrame];
    
    self.cellHeight = CGRectGetMaxY(self.statusToolbarFrame);
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = DSScreenWidth;
    CGFloat h = CGRectGetMaxY(self.statusToolbarFrame);
    self.frame = CGRectMake(x,y, w, h);
}

//计算feed整体frame

- (void)setupStatusDetailFrame {
    
    DSStatusDetailFrame *detailFrame = [[DSStatusDetailFrame alloc] init];
    detailFrame.status = self.status;
    self.statusDetailFrame = detailFrame;
}

//计算工具条整体frame
- (void)setupStatusToolbarFrame {
    
    CGFloat toolbarX = 0;
    CGFloat toolbarY = CGRectGetMaxY(self.statusDetailFrame.frame);
    CGFloat toolbarW = DSScreenWidth;
    CGFloat toolbarH = DSStatusToolbarWidth;
    
    self.statusToolbarFrame = CGRectMake(toolbarX, toolbarY, toolbarW, toolbarH);
}


@end
