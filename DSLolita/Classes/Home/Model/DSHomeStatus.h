//
//  DSHomeStatus.h
//  DSLolita
//
//  Created by 赛 丁 on 15/5/27.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSHomeStatus : NSObject

@property (nonatomic , strong) NSMutableArray *statuses;

@property (nonatomic , assign) int total_number;

@property (nonatomic , strong) NSArray *loadedObjectIDs;



@end
