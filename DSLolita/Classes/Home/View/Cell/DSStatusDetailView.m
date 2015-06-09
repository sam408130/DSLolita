//
//  DSStatusDetailView.m
//  DSLolita
//
//  Created by 赛 丁 on 15/5/26.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSStatusDetailView.h"
#import "DSStatusRetweetedView.h"
#import "DSStatusRetweetedFrame.h"
#import "DSStatusOriginalView.h"
#import "DSStatusOriginalFrame.h"
#import "DSStatusDetailFrame.h"


@interface DSStatusDetailView()

@property (nonatomic , weak) DSStatusRetweetedView *retweetedView;
@property (nonatomic , weak) DSStatusOriginalView *originalView;

@end

@implementation DSStatusDetailView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) { // 初始化子控件
        self.image = [UIImage resizableImageWithName:@"timeline_card_top_background"];
        self.highlightedImage = [UIImage resizableImageWithName:@"timeline_card_top_background_highlighted"];
        self.opaque = YES;
        // 1.添加原创微博
        [self setupOriginalView];
        
        // 2.添加转发微博
        [self setupRetweetedView];
        
        //能与用户交互
        self.userInteractionEnabled = YES;
    }
    return self;
}


/**
 *  添加原创微博
 */
- (void)setupOriginalView
{
    DSStatusOriginalView *originalView = [[DSStatusOriginalView alloc] init];
    [self addSubview:originalView];
    self.originalView = originalView;
}

/**
 *  添加转发微博
 */
- (void)setupRetweetedView
{
    DSStatusRetweetedView *retweetedView = [[DSStatusRetweetedView alloc] init];
    [self addSubview:retweetedView];
    self.retweetedView = retweetedView;
}

- (void)setDetailFrame:(DSStatusDetailFrame *)detailFrame
{
    _detailFrame = detailFrame;
    
    self.frame = detailFrame.frame;
    
    // 1.原创微博的frame数据
    self.originalView.originalFrame = detailFrame.originalFrame;
    
    
    // 2.原创转发的frame数据
    self.retweetedView.retweetedFrame = detailFrame.retweetedFrame;
}



@end
