//
//  DSStatusOriginalView.m
//  DSLolita
//
//  Created by 赛 丁 on 15/5/26.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSStatusOriginalView.h"
#import "DSStatusOriginalFrame.h"
#import "DSStatus.h"
#import "DSUser.h"
#import "UIImageView+WebCache.h"
#import "DSStatusPhotosView.h"
#import "DSStatusLabel.h"
#import "DSStatusUserHeadView.h"

@interface DSStatusOriginalView()

// 昵称
@property (nonatomic , weak) UILabel *nameLabel;
// 正文
@property (nonatomic , weak) DSStatusLabel *textLabel;
//来源
@property (nonatomic , weak) UILabel *sourceLabel;
//时间
@property (nonatomic ,weak) UILabel *timeLabel;
//头像
@property (nonatomic ,weak) DSStatusUserHeadView *iconView;
//会员图标
@property (nonatomic , weak) UIImageView *vipView;
//更多图标
@property (nonatomic , weak) UIButton *moreBtn;
//配图
@property (nonatomic ,weak) DSStatusPhotosView *photosView;


@end





@implementation DSStatusOriginalView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
        self.opaque = YES;
        // 1.昵称
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = DSStatusOriginalNameFont;
        //nameLabel.text = self.originalFrame.status.user.name;
        [self addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        // 2.正文
        DSStatusLabel *textLabel = [[DSStatusLabel alloc] init];
        [self addSubview:textLabel];
        self.textLabel = textLabel;
        
        
        // 3.时间
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.textColor = DSColor(242, 153, 92);
        timeLabel.font = DSStatusOriginalTimeFont;
        [self addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        // 4.来源
        UILabel *sourceLabel = [[UILabel alloc] init];
        sourceLabel.textColor = DSColor(113, 113, 113);
        sourceLabel.font = DSStatusOriginalSourceFont;
        [self addSubview:sourceLabel];
        self.sourceLabel = sourceLabel;
    
    
        // 5.头像
        DSStatusUserHeadView *iconView = [[DSStatusUserHeadView alloc] init];
        [self addSubview:iconView];
        self.iconView = iconView;
        
        // 6.会员图标
        UIImageView *vipView = [[UIImageView alloc] init];
        vipView.contentMode = UIViewContentModeCenter;
        [self addSubview:vipView];
        self.vipView = vipView;
    
    
        // 7.显示更多按钮
        UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [moreBtn setImage:[UIImage imageNamed:@"timeline_icon_more"] forState:UIControlStateNormal];
        [moreBtn setImage:[UIImage imageNamed:@"timeline_icon_more_highlighted"] forState:UIControlStateHighlighted];
        [moreBtn addTarget:self action:@selector(moreBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
        self.moreBtn = moreBtn;
        moreBtn.adjustsImageWhenDisabled = NO;
        [self addSubview:moreBtn];
        
        
        // 8.配图
        DSStatusPhotosView *photosView = [[DSStatusPhotosView alloc] init];
        [self addSubview:photosView];
        self.photosView = photosView;
    }
    
    
    return self;
    
}




- (void)setOriginalFrame:(DSStatusOriginalFrame *)originalFrame {
    
    _originalFrame = originalFrame;
    
    self.frame = originalFrame.frame;
    
    //取出数据
    DSStatus *status = originalFrame.status;
    
    //取出用户数据
    DSUser *user = status.user;
    
    // 1.昵称
    self.nameLabel.text = user.username;
    self.nameLabel.frame = originalFrame.nameFrame;
    
    //会员
    
    // 2.正文
    self.textLabel.attributedText = status.attributedText;
    self.textLabel.frame = originalFrame.textFrame;
    
    // 3.时间
    NSString *time = status.created_at;
    self.timeLabel.text = time;
    CGFloat timeX = CGRectGetMinX(self.nameLabel.frame);
    CGFloat timeY = CGRectGetMaxY(self.nameLabel.frame) + DSStatusCellInset * 0.5;
    CGSize timeSize = [time sizeWithFont:DSStatusOriginalTimeFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    self.timeLabel.frame = (CGRect){{timeX, timeY}, timeSize};
    
    
    // 4.来源
    self.sourceLabel.text = status.source;
    CGFloat sourceX = CGRectGetMaxX(self.timeLabel.frame) + DSStatusCellInset;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [status.source sizeWithFont:DSStatusOriginalSourceFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    self.sourceLabel.frame = (CGRect){{sourceX, sourceY}, sourceSize};
    
    // 5.头像
    self.iconView.frame = originalFrame.iconFrame;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:user.avatarUrl] placeholderImage:[UIImage imageWithName:@"avatar_default_small"]];
    
    // 6.更多按钮
    self.moreBtn.frame = originalFrame.moreFrame;
    
    // 7.配图
    if (status.pic_urls.count){
        self.photosView.frame = originalFrame.photosFrame;
        self.photosView.picUrls = status.pic_urls;
        self.photosView.hidden = NO;
    
    }else{
        self.photosView.hidden = YES;
    }


}



- (void)moreBtnOnClick{
    //利用通知发送更多按钮被点击：挣对于多层次需要传递数据
    [[NSNotificationCenter defaultCenter] postNotificationName:DSStatusOriginalDidMoreNotication object:nil];
}











@end
