//
//  DSAbuseReport.h
//  DSLolita
//
//  Created by 赛 丁 on 15/6/5.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSAbuseReport : AVObject<AVSubclassing>

@property (nonatomic,strong) NSString *reason;

@property (nonatomic,strong) NSString *convid;

@property (nonatomic,strong) AVUser *author;

@end