//
//  DSEmotionToolbar.m
//  DSLolita
//
//  Created by 赛 丁 on 15/5/28.
//  Copyright (c) 2015年 samDing. All rights reserved.
//
#define DSEmotionToolbarButtonMaxCount 4
#import "DSEmotionToolbar.h"


@interface DSEmotionToolbar()

@property (nonatomic , weak) UIButton *selectedButton;

@end

@implementation DSEmotionToolbar


- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        // 1.添加4个按钮
        [self setupButton:@"最近" tag:DSEmotionTypeRecent];
        [self setupButton:@"默认" tag:DSEmotionTypeDefault];
        [self setupButton:@"Emoji" tag:DSEmotionTypeEmoji];
        [self setupButton:@"浪小花" tag:DSEmotionTypeLxh];
        // 2.监听表情选中的通知:为了重新刷新数据
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelected:) name:DSEmotionDidSelectedNotification object:nil];
    }
    return self;
}



//添加按钮
- (UIButton *)setupButton:(NSString *)title tag:(DSEmotionTYype)tag {
    
    UIButton *button = [[UIButton alloc] init];
    button.tag = tag;
    
    //文字
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    
    //添加按钮
    [self addSubview:button];
    
    //设置背景图片
    int count = (int)self.subviews.count;
    if (count == 1) { // 第一个按钮
        [button setBackgroundImage:[UIImage resizableImageWithName:@"compose_emotion_table_left_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage resizableImageWithName:@"compose_emotion_table_left_selected"] forState:UIControlStateSelected];
    } else if (count == DSEmotionToolbarButtonMaxCount) { // 最后一个按钮
        [button setBackgroundImage:[UIImage resizableImageWithName:@"compose_emotion_table_right_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage resizableImageWithName:@"compose_emotion_table_right_selected"] forState:UIControlStateSelected];
    } else { // 中间按钮
        [button setBackgroundImage:[UIImage resizableImageWithName:@"compose_emotion_table_mid_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage resizableImageWithName:@"compose_emotion_table_mid_selected"] forState:UIControlStateSelected];
    }
    
    return button;
}


// 监听按钮点击
- (void)buttonClick:(UIButton *)button {
    
    // 1.控制按钮状态（selectedbutton为上一次点击的按钮，可能为空
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
    
    // 2.通知代理
    if([self.delegate respondsToSelector:@selector(emotionToolbar:didSelectedButton:)]){
        [self.delegate emotionToolbar:self didSelectedButton:(int)button.tag];
    }
}


- (void)setDelegate:(id<DSEmotionToolbarDelegate>)delegate {
    
    _delegate = delegate;
    //获得默认按钮，或者当前
    UIButton *currentButton = (UIButton *)[self viewWithTag:_currentButtonType];
    //默认选中 ‘默认’按钮 ， 后者当前按钮
    [self buttonClick:currentButton];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置工具条按钮的frame
    CGFloat buttonW = self.width / DSEmotionToolbarButtonMaxCount;
    CGFloat buttonH = self.height;
    for (int i = 0; i<DSEmotionToolbarButtonMaxCount; i++) {
        UIButton *button = self.subviews[i];
        button.width = buttonW;
        button.height = buttonH;
        button.x = i * buttonW;
    }
}
/**
 *  表情选中
 */
- (void)emotionDidSelected:(NSNotification *)note
{
    if (self.selectedButton.tag == DSEmotionTypeRecent) {
        [self buttonClick:self.selectedButton];
    }
}




@end
