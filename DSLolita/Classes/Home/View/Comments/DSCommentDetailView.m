//
//  DSCommentDetailView.m
//  DSLolita
//
//  Created by 赛 丁 on 15/6/3.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSCommentDetailView.h"
#import "DSCommentDetailFrame.h"
#import "DSComment.h"
#import "DSUser.h"
#import "UIImageView+WebCache.h"
#import "DSStatusLabel.h"
#import "DSStatusUserHeadView.h"
#import "DSStatusPhotosView.h"

@interface DSCommentDetailView()


// 昵称
@property (nonatomic , weak) UILabel *nameLabel;
// 正文
@property (nonatomic , weak) DSStatusLabel *textLabel;
//时间
@property (nonatomic ,weak) UILabel *timeLabel;
//头像
@property (nonatomic ,weak) DSStatusUserHeadView *iconView;
//配图
@property (nonatomic ,weak) DSStatusPhotosView *photosView;

@end




@implementation DSCommentDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
        self.image = [UIImage resizableImageWithName:@"timeline_card_top_background"];
        self.highlightedImage = [UIImage resizableImageWithName:@"timeline_card_top_background_highlighted"];
        
        // 1.昵称
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = DSStatusOriginalTimeFont;
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

        
        
        // 4.头像
        DSStatusUserHeadView *iconView = [[DSStatusUserHeadView alloc] init];
        [self addSubview:iconView];
        self.iconView = iconView;
        


        
        // 5.配图
        DSStatusPhotosView *photosView = [[DSStatusPhotosView alloc] init];
        [self addSubview:photosView];
        self.photosView = photosView;
        
        // 6.分割线

    }
    
    
    return self;
    
}

- (void)setCommentDetailFrame:(DSCommentDetailFrame *)commentDetailFrame {
    
    _commentDetailFrame = commentDetailFrame;
    self.frame = commentDetailFrame.frame;
    
    //取出数据
    DSComment *commentData = commentDetailFrame.commentData;
    
    //取出用户数据
    DSUser *user = commentData.user;
    
    // 1.昵称
    self.nameLabel.text = user.username;
    self.nameLabel.frame = commentDetailFrame.nameFrame;
    
    //会员
    
    // 2.正文
    self.textLabel.attributedText = commentData.attributedText;
    self.textLabel.frame = commentDetailFrame.textFrame;
    
    // 3.时间
    NSString *time = commentData.created_at;
    self.timeLabel.text = time;
    CGFloat timeX = CGRectGetMinX(self.nameLabel.frame);
    CGFloat timeY = CGRectGetMaxY(self.nameLabel.frame) + DSStatusCellInset * 0.5;
    CGSize timeSize = [time sizeWithFont:DSStatusOriginalTimeFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    self.timeLabel.frame = (CGRect){{timeX, timeY}, timeSize};

    // 4.头像
    self.iconView.frame = commentDetailFrame.iconFrame;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:user.avatarUrl] placeholderImage:[UIImage imageWithName:@"avatar_default_small"]];
    

    // 5.配图
    if (commentData.pic_urls.count){
        self.photosView.frame = commentDetailFrame.photosFrame;
        self.photosView.picUrls = commentData.pic_urls;
        self.photosView.hidden = NO;
        
    }else{
        self.photosView.hidden = YES;
    }

}




@end
