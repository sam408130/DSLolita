//
//  DSEmotionView.m
//  DSLolita
//
//  Created by 赛 丁 on 15/5/28.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSEmotionView.h"
#import "DSEmotion.h"


@implementation DSEmotionView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

- (void)setEmotion:(DSEmotion *)emotion {
    
    _emotion = emotion;
    
    if (emotion.code) {
        
        self.titleLabel.font = [UIFont systemFontOfSize:32];
        [self setTitle:emotion.emoji forState:UIControlStateNormal];
        [self setImage:nil forState:UIControlStateNormal];
        
    }else{
        [self setImage:[UIImage imageWithName:emotion.png] forState:UIControlStateNormal];
        [self setTitle:nil forState:UIControlStateNormal];
    }
}

@end
