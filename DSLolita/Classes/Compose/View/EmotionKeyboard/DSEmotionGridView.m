//
//  DSEmotionGridView.m
//  DSLolita
//
//  Created by 赛 丁 on 15/5/28.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSEmotionGridView.h"
#import "DSEmotion.h"
#import "DSEmotionView.h"
#import "DSEmotionPopView.h"
#import "DSEmotionTool.h"


@interface DSEmotionGridView()

@property (nonatomic , weak) UIButton *deleteButton;
@property (nonatomic , strong) NSMutableArray *emotionViews;
@property (nonatomic , strong) DSEmotionPopView *popView;

@end

@implementation DSEmotionGridView

- (DSEmotionPopView *)popView {
    if (!_popView){
        self.popView = [DSEmotionPopView popView];
    }
    return _popView;
}



-(NSMutableArray *)emotionViews {
    if (!_emotionViews){
        return [NSMutableArray array];
    }
    return _emotionViews;
}

-(instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        //添加删除按钮
        UIButton *deleteButton = [[UIButton alloc] init];
        [deleteButton setImage:[UIImage imageWithName:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [deleteButton setImage:[UIImage imageWithName:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        [deleteButton addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:deleteButton];
        self.deleteButton = deleteButton;
        
        // 给自己添加一个长按手势识别器
        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] init];
        [recognizer addTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:recognizer];
    }
    
    return self;
}


// 根据触摸点返回对应的表情控件

- (DSEmotionView *)emotionViewWithPoint:(CGPoint)point {
    
    __block DSEmotionView *foundEmotionView = nil;
    // 遍历所有的表情控件，并判断当前手势的位置是否再该表情的左边中
    [self.emotionViews enumerateObjectsUsingBlock:^(DSEmotionView *emotionView , NSUInteger idx , BOOL *stop){
        if (CGRectContainsPoint(emotionView.frame, point) && (emotionView.hidden == NO)){
            
            foundEmotionView = emotionView;
            *stop = YES;
        }
    }];
    
    return foundEmotionView;
}


// 出发长按手势

- (void)longPress:(UILongPressGestureRecognizer *)recognizer {
    
    // 1.捕获触摸点
    CGPoint point = [recognizer locationInView:recognizer.view];
    
    // 2.检测触摸点在哪个表情上
    DSEmotionView *emotionView = [self emotionViewWithPoint:point];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        //手松开了
        [self.popView dismiss];
        [self selecteEmotion:emotionView.emotion];
    }else {
        //手没松开
        [self.popView showFromEmotionView:emotionView];
    }
}


- (void)setEmotions:(NSArray *)emotions {
    
    //懒加载数据
    _emotions = emotions;
    //添加新的表情
    int count = (int)emotions.count;
    int currentEmotionViewCount = (int)self.emotionViews.count;
    for(int i = 0; i<count; i++){
        DSEmotionView *emotionView = nil;
        if(i >= currentEmotionViewCount){//emotionView不够用
            emotionView = [[DSEmotionView alloc] init];
            [emotionView addTarget:self action:@selector(emotionClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:emotionView];
        }else{
            emotionView = self.emotionViews[i];
        }
        
        //传递模型数据
        emotionView.emotion = emotions[i];
        emotionView.hidden = NO;
    }
    
    //隐藏多余的emotionview
    for (int i = count; i < currentEmotionViewCount; i++) {
        UIButton *emotionView = self.emotionViews[i];
        emotionView.hidden = YES;
    }

}


// 监听表情点击

- (void)emotionClick:(DSEmotionView *)emotionView {
    //懒加载数据
    [self.popView showFromEmotionView:emotionView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       
        [self.popView dismiss];
        
        //选中表情
        [self selecteEmotion:emotionView.emotion];
    });
}

- (void)selecteEmotion:(DSEmotion *)emotion {
    
    if (emotion == nil) return;
    
    //先添加使用的表情，在发通知
    //保存使用记录
    [DSEmotionTool addRecentEmotion:emotion];
    //发出一个选中表情的同志
    [[NSNotificationCenter defaultCenter] postNotificationName:DSEmotionDidSelectedNotification object:nil userInfo:@{DSSelectedEmotion:emotion}];
}

// 点击删除表情
- (void)deleteClick {
    
    //发出一个删除表情的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:DSEmotionDidDeletedNotification object:nil userInfo:nil];
}




- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat leftInset = 15;
    CGFloat topInset = 15;
    
    // 1.排列所有表情
    int count = (int)self.emotionViews.count;
    CGFloat emotionViewW = (self.width - 2 *leftInset) / DSEmotionMaxCols;
    CGFloat emotionViewH = (self.height - topInset) / DSEmotionMaxRows;
    for (int i = 0 ;i < count; i++){
        UIButton *emotionView = self.emotionViews[i];
        emotionView.x = leftInset + (i % DSEmotionMaxCols) * emotionViewW;
        emotionView.y = topInset + (i / DSEmotionMaxCols) * emotionViewH;
        emotionView.width = emotionViewW;
        emotionView.height = emotionViewH;
    }
    
    // 2.删除按钮
    self.deleteButton.width = emotionViewW;
    self.deleteButton.height = emotionViewH;
    self.deleteButton.x = self.width - self.deleteButton.width;
    self.deleteButton.y = self.height - self.deleteButton.height;
}







@end
