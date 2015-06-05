//
//  DSPhoto.h
//  DSLolita
//
//  Created by 赛 丁 on 15/5/25.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSPhoto : NSObject

//缩略图
@property (nonatomic , copy) NSString *thumbnail_pic;

//中等尺寸图片地址，没有时返回此字段
@property (nonatomic , copy) NSString *bmiddle_pic;

//原图地址，没有时不返回此字段
@property (nonatomic , copy) NSString *original_pic;

@end
