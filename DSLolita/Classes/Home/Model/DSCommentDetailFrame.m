//
//  DSCommentDetailFrame.m
//  DSLolita
//
//  Created by 赛 丁 on 15/6/3.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSCommentDetailFrame.h"
#import "DSComment.h"
#import "DSStatusPhotosView.h"
#import "DSUser.h"

@implementation DSCommentDetailFrame

- (void)setCommentData:(DSComment *)commentData {
    
    _commentData = commentData;
    
    
    // 1.头像
    CGFloat iconX = DSStatusCellInset;
    CGFloat iconY = DSStatusCellInset;
    CGFloat iconW = 35;
    CGFloat iconH = 35;
    
    self.iconFrame = CGRectMake(iconX, iconY, iconW, iconH);
    
    // 2.昵称
    CGFloat nameX = CGRectGetMaxX(self.iconFrame) + DSStatusCellInset;
    CGFloat nameY = iconY;
    CGSize nameSize = [commentData.user.username sizeWithFont:DSStatusOriginalNameFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    self.nameFrame = (CGRect){ {nameX , nameY} , nameSize };
    
    // 3.正文
    CGFloat textX = nameX;
    CGFloat textY = CGRectGetMaxY(self.iconFrame) + DSStatusCellInset ;
    CGFloat maxW = DSScreenWidth - 2 *textX;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    
    CGSize textSize = [commentData.attributedText boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    self.textFrame = (CGRect){{textX , textY} , textSize };
    
    // 4.配图相册
    CGFloat h = 0;
    if (commentData.pic_urls.count) {
        CGFloat photosX = textX;
        CGFloat photosY = CGRectGetMaxY(self.textFrame) + DSStatusCellInset;
        CGSize photosSize = [DSStatusPhotosView sizeWithPhotosCount:(int)commentData.pic_urls.count];
        self.photosFrame = (CGRect){{photosX, photosY}, photosSize};
        h = CGRectGetMaxY(self.photosFrame) + DSStatusCellInset;
    }else{
        h = CGRectGetMaxY(self.textFrame) + DSStatusCellInset;
    }
    
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = DSScreenWidth;
    self.frame = CGRectMake(x, y, w, h);
    
}



@end
