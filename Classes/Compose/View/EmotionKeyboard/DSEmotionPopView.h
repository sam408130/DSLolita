//
//  DSEmotionPopView.h
//  DSLolita
//
//  Created by 赛 丁 on 15/5/28.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DSEmotionView;


@interface DSEmotionPopView : UIView

+ (instancetype)popView;

// 显示表情弹出控件，emotionVIEW从哪个表情上面弹出

- (void)showFromEmotionView:(DSEmotionView *)fromEmotionView;

// 隐藏
- (void)dismiss;



@end
