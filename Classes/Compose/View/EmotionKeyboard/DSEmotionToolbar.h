//
//  DSEmotionToolbar.h
//  DSLolita
//
//  Created by 赛 丁 on 15/5/28.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DSEmotionToolbar;

typedef enum {
    DSEmotionTypeRecent = 1,
    DSEmotionTypeDefault ,
    DSEmotionTypeEmoji,
    DSEmotionTypeLxh
}DSEmotionTYype;
@protocol DSEmotionToolbarDelegate <NSObject>

@optional
-(void)emotionToolbar:(DSEmotionToolbar *)toolbar didSelectedButton:(DSEmotionTYype)emotionType;

@end

@interface DSEmotionToolbar : UIView

@property (nonatomic , assign) DSEmotionTYype currentButtonType;
@property (nonatomic , weak) id<DSEmotionToolbarDelegate>delegate;

@end
