//
//  DSStatusRetweetedFrame.m
//  DSLolita
//
//  Created by 赛 丁 on 15/5/26.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSStatusRetweetedFrame.h"
#import "DSUser.h"
#import "DSStatus.h"
#import "DSStatusPhotosView.h"


@implementation DSStatusRetweetedFrame

- (void)setRetweetedStatus:(DSStatus *)retweetedStatus {
    
    _retweetedStatus = retweetedStatus;
    
    // 1.昵称
    //    CGFloat nameX = SWStatusCellInset;
    //    CGFloat nameY = SWStatusCellInset * 0.5;
    //    NSString *name = [NSString stringWithFormat:@"@%@", retweetedStatus.user.name];
    //    CGSize nameSize = [name sizeWithFont:SWStatusRetweetedNameFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    //    self.nameFrame = (CGRect){{nameX, nameY}, nameSize};
    
    // 2.正文
    CGFloat textX = DSStatusCellInset;
    CGFloat textY = DSStatusCellInset * 0.5;
    CGFloat maxW = DSScreenWidth - 2 * textX;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    CGSize textSize = [retweetedStatus.attributedText boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    self.textFrame = (CGRect){{textX, textY}, textSize};
    // 5.配图相册
    CGFloat h = 0;
    
    if (retweetedStatus.pic_urls.count) {
        CGFloat photosX = textX;
        CGFloat photosY = CGRectGetMaxY(self.textFrame) + DSStatusCellInset;
        CGSize photosSize = [DSStatusPhotosView sizeWithPhotosCount:(int)retweetedStatus.pic_urls.count];
        self.photosFrame = (CGRect){{photosX, photosY}, photosSize};
        
        h = CGRectGetMaxY(self.photosFrame) + DSStatusCellInset;
    } else {
        h = CGRectGetMaxY(self.textFrame) + DSStatusCellInset;
    }
    
    
    
    // 自己
    CGFloat x = 0;
    CGFloat y = 0; // 高度 = 原创微博最大的Y值
    CGFloat w = DSScreenWidth;
    self.frame = CGRectMake(x, y, w, h);

    
}

@end
