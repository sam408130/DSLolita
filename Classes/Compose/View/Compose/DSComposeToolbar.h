//
//  DSComposeToolbar.h
//  DSLolita
//
//  Created by 赛 丁 on 15/5/28.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    
    DSComposeToolbarButtonTypeCamera,//照相机
    DSComposeToolbarButtonTypePicture, //相册
    DSComposeToolbarButtonTypeMention, //提到@
    DSComposeToolbarButtonTypeTrend,//话题
    DSComposeToolbarButtonTypeEmotion //表情
}DSComposeToolbarButtonType;

@class DSComposeToolbar;

@protocol DSComposeToolbarDelegate <NSObject>

@optional

- (void)composeTool:(DSComposeToolbar *)toolbar didClickedButton:(DSComposeToolbarButtonType)buttonType;

@end




@interface DSComposeToolbar : UIView

@property (nonatomic ,weak) id<DSComposeToolbarDelegate>delegate;

@property (nonatomic ,assign ,getter=isShowEmotionButton) BOOL showEmotionButton;

@end
