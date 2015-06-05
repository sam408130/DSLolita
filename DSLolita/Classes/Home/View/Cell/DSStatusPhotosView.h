//
//  DSStatusPhotosView.h
//  DSLolita
//
//  Created by 赛 丁 on 15/5/26.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSStatusPhotosView : UIImageView

@property(nonatomic , strong) NSArray *picUrls;

//根据图片个数计算尺寸
+ (CGSize)sizeWithPhotosCount:(int)photosCount;

@end
