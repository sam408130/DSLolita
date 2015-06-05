//
//  DSEmotionKeyboard.m
//  DSLolita
//
//  Created by 赛 丁 on 15/5/28.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSEmotionKeyboard.h"
#import "DSEmotionListView.h"
#import "DSEmotionToolbar.h"
#import "DSEmotion.h"
#import "DSEmotionTool.h"


@interface DSEmotionKeyboard()<DSEmotionToolbarDelegate>

@property (nonatomic,weak) DSEmotionListView *listView;
@property (nonatomic,weak) DSEmotionToolbar *toolbar;


@end

@implementation DSEmotionKeyboard

+ (instancetype)keyboard {
    
    return [[self alloc] init];
    
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithName:@"emotion_keyboard_background"]];
        
        // 1.添加表情列表
        DSEmotionListView *listView = [[DSEmotionListView alloc] init];
        [self addSubview:listView];
        self.listView = listView;
        
        // 2.添加表情工具条
        DSEmotionToolbar *toolbar = [[DSEmotionToolbar alloc] init];
        toolbar.currentButtonType = [DSEmotionTool recentEmotions].count > 0 ? DSEmotionTypeRecent : DSEmotionTypeDefault;
        toolbar.delegate = self;
        [self addSubview:toolbar];
        self.toolbar = toolbar;
    }
    
    return self;
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    // 1.设置工具条的frame
    self.toolbar.width = self.width;
    self.toolbar.height = 35;
    self.toolbar.y = self.height - self.toolbar.height;
    
    // 2.设置表情列表的frame
    self.listView.width = self.width;
    self.listView.height = self.toolbar.y;
}

- (void)emotionToolbar:(DSEmotionToolbar *)toolbar didSelectedButton:(DSEmotionTYype)emotionType {
    
    switch (emotionType) {
        case DSEmotionTypeDefault:
            self.listView.emotions = [DSEmotionTool defaultEmotions];
            break;
        case DSEmotionTypeEmoji:
            self.listView.emotions = [DSEmotionTool emojiEmotions];
            break;
        case DSEmotionTypeLxh:
            self.listView.emotions = [DSEmotionTool lxhEmotions];
            break;
        case DSEmotionTypeRecent:
            self.listView.emotions = [DSEmotionTool recentEmotions];
            break;
        default:
            break;
    }
}











@end
