//
//  DSCommentCellFrame.m
//  DSLolita
//
//  Created by 赛 丁 on 15/6/3.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSCommentCellFrame.h"
#import "DSCommentDetailFrame.h"
#import "DSComment.h"

@implementation DSCommentCellFrame


- (void)setCommentData:(DSComment *)commentData {
    
    _commentData = commentData;
    
    [self setupDetailFrame];
    
    self.cellHeight = CGRectGetMaxY(self.commentDetailFrame.frame);
}


- (void)setupDetailFrame {
    
    DSCommentDetailFrame *detailFrame = [[DSCommentDetailFrame alloc] init];
    detailFrame.commentData = self.commentData;
    self.commentDetailFrame = detailFrame;
}

@end
