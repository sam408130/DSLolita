//
//  DSStatusToolbar.m
//  DSLolita
//
//  Created by 赛 丁 on 15/5/26.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSStatusToolbar.h"
#import "DSStatus.h"


@interface DSStatusToolbar()

@property (nonatomic , strong) NSMutableArray *btns;
@property (nonatomic , strong) NSMutableArray *dividers;



@end



@implementation DSStatusToolbar

- (NSMutableArray *)btns {
    if (_btns == nil) {
        self.btns = [[NSMutableArray alloc] init];
    }
    
    return _btns;
}



- (NSMutableArray *)dividers {
    if (_dividers == nil) {
        self.dividers = [[NSMutableArray alloc] init];
    }
    
    return _dividers;
}



- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.userInteractionEnabled = YES;
        self.image = [UIImage resizableImageWithName:@"timeline_card_bottom_background"];
        
        
        self.repostsBtn = [self setupButtonWithIcon:@"timeline_icon_retweet" title:@"转发"];
        self.commentsBtn = [self setupButtonWithIcon:@"timeline_icon_comment" title:@"评论"];
        self.attitudesBtn = [self setupButtonWithIcon:@"timeline_icon_like_disable" title:@"赞"];
        self.messageBtn = [self setupButtonWithIcon:@"userinfo_me_relationship_indicator_message" title:@"私信"];
        

        
        [self setupDivider];
        [self setupDivider];
        [self setupDivider];
       
    }
    
    return self;
}



- (void)setupDivider {
    UIImageView *divider = [[UIImageView alloc] init];
    divider.image = [UIImage imageWithName:@"timeline_card_bottom_line"];
    divider.contentMode = UIViewContentModeCenter;
    [self addSubview:divider];
    
    [self.dividers addObject:divider];
}


- (UIButton *)setupButtonWithIcon:(NSString *)icon title:(NSString *)title {
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageWithName:icon] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    
    //背景图片
    [btn setBackgroundImage:[UIImage resizableImageWithName:@"common_card_bottom_background_highlighted"] forState:UIControlStateHighlighted];
    btn.adjustsImageWhenHighlighted = NO;
    
    //设置间距
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    [self addSubview:btn];
    
    [self.btns addObject:btn];
    return btn;
}


- (void)layoutSubviews {
    
    // 设置按钮的frame
    int btnCount = (int)self.btns.count;
    CGFloat btnW = self.width / btnCount;
    CGFloat btnH = self.height;
    for (int i = 0; i < btnCount; i++){
        UIButton *btn = self.btns[i];
        btn.width = btnW;
        btn.height = btnH;
        btn.y = 0;
        btn.x = i *btnW;
    }
    
    
    
    int divideCount = (int)self.dividers.count;
    for (int i = 0; i < divideCount; i++){
        UIImageView *divide = self.dividers[i];
        divide.width = 1;
        divide.height = btnH;
        divide.centerX = (i + 1) *btnW;
        divide.centerY = btnH * 0.5;
    }
    
}

- (void)setStatus:(DSStatus *)status {
    
    _status = status;

    
    if ([status.digusers containsObject:[AVUser currentUser]]){
        [self.attitudesBtn setImage:[UIImage imageNamed:@"timeline_icon_like"] forState:UIControlStateNormal];
    }else {
        
        [self.attitudesBtn setImage:[UIImage imageNamed:@"timeline_icon_like_disable"] forState:UIControlStateNormal];
    }
    
    
    [self setupButtonTitle:self.repostsBtn count:status.reposts_count defaultTitle:@"转发"];
    [self setupButtonTitle:self.commentsBtn count:status.comments_count defaultTitle:@"评论"];
    [self setupButtonTitle:self.attitudesBtn count:status.attitudes_count defaultTitle:@"赞"];
    
    
}

- (void)setupButtonTitle:(UIButton *)button count:(int)count defaultTitle:(NSString *)defaultTitle {
    
    if (count >= 10000){
        defaultTitle = [NSString stringWithFormat:@"%.1f万",count / 10000.0];
    }else if (count > 0){
        defaultTitle = [NSString stringWithFormat:@"%d",count];
    }
    
    [button setTitle:defaultTitle forState:UIControlStateNormal];
}






@end
