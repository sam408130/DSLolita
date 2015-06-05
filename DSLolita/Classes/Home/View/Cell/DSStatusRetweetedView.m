//
//  DSStatusRetweetedView.m
//  DSLolita
//
//  Created by 赛 丁 on 15/5/26.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSStatusRetweetedView.h"
#import "DSStatusRetweetedFrame.h"
#import "DSStatus.h"
#import "DSStatusPhotosView.h"
#import "DSStatusLabel.h"


@interface DSStatusRetweetedView()

@property (nonatomic ,strong) DSStatusLabel *textLabel;

@property (nonatomic , strong) DSStatusPhotosView *photosView;

@end




@implementation DSStatusRetweetedView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
        self.image = [UIImage resizableImageWithName:@"timeline_retweet_background"];
        
        
        DSStatusLabel *textLabel = [[DSStatusLabel alloc] init];
        //textLabel.textColor = SWColor(129, 129, 129);
        [self addSubview:textLabel];
        self.textLabel = textLabel;
        // 3.配图相册
        DSStatusPhotosView *photosView = [[DSStatusPhotosView alloc] init];
        [self addSubview:photosView];
        self.photosView = photosView;
    }
    return self;
}



- (void)setRetweetedFrame:(DSStatusRetweetedFrame *)retweetedFrame
{
    self.frame = retweetedFrame.frame;
    // 取出微博数据
    DSStatus *retweetedStatus = retweetedFrame.retweetedStatus;
    // 取出用户数据
    //    SWUser *user = retweetedStatus.user;
    //1.设置昵称的frame
    //    self.nameLabel.text = [NSString stringWithFormat:@"@%@",user.name];
    //    self.nameLabel.frame = retweetedFrame.nameFrame;
    //2.设置转发正文的内容和frame
    self.textLabel.attributedText = retweetedStatus.attributedText;
    self.textLabel.frame = retweetedFrame.textFrame;
    // 3.配图相册
    if (retweetedStatus.pic_urls.count) { // 有配图
        self.photosView.frame = retweetedFrame.photosFrame;
        self.photosView.picUrls = retweetedStatus.pic_urls;
        self.photosView.hidden = NO;
    } else {
        self.photosView.hidden = YES;
    }
    
}


@end
