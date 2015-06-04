//
//  DSBadgeView.m
//  DSLolita
//
//  Created by 赛 丁 on 15/5/25.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSBadgeView.h"

@implementation DSBadgeView

- (id)initWithFrame:(CGRect)frame{
    self  = [super initWithFrame:frame];
    if(self) {
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        [self setBackgroundImage:[UIImage resizableImageWithName:@"main_badge"] forState:UIControlStateNormal];
        self.height = self.currentBackgroundImage.size.height;
    }
    return self;
}


- (void)setBadgeValue:(NSString *)badgeValue {
    _badgeValue = [badgeValue copy];
    
    [self setTitle:badgeValue forState:UIControlStateNormal];
    
    CGSize titleSize = [badgeValue sizeWithFont:self.titleLabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat bgW = self.currentBackgroundImage.size.width;
    if (titleSize.width < bgW) {
        self.width = bgW;
    }else{
        self.width = titleSize.width + 10;
    }
}

@end
