//
//  DSStatusDetailFrame.m
//  DSLolita
//
//  Created by 赛 丁 on 15/5/26.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSStatusDetailFrame.h"
#import "DSStatusOriginalFrame.h"
#import "DSStatusRetweetedFrame.h"
#import "DSStatus.h"



@implementation DSStatusDetailFrame

- (void)setStatus:(DSStatus *)status {
    
    _status = status;
    
    // 1.计算原始Feed的frame
    DSStatusOriginalFrame *originalFrame = [[DSStatusOriginalFrame alloc] init];
    originalFrame.status = status;
    self.originalFrame = originalFrame;
    
    
    // 2.计算转发Feed的frame
    CGFloat h = 0;
    if (status.retweeted_status) {
        DSStatusRetweetedFrame *retweetedFrame = [[DSStatusRetweetedFrame alloc] init];
        retweetedFrame.retweetedStatus = status.retweeted_status;
        
        
        CGRect f = retweetedFrame.frame;
        f.origin.y = CGRectGetMaxY(retweetedFrame.frame);
        retweetedFrame.frame = f;
        
        self.retweetedFrame = retweetedFrame;
        
        h = CGRectGetMaxY(retweetedFrame.frame);
    }else{
        h = CGRectGetMaxY(originalFrame.frame);
    }
    
    
    // 自己的frame
    CGFloat x = 0;
    CGFloat y = DSStatusCellMargin;
    CGFloat w = DSScreenWidth;
    self.frame = CGRectMake(x, y, w, h);
    
    
    
    
}


@end
