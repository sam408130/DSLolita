//
//  DSHttpTool.h
//  DSLolita
//
//  Created by 赛 丁 on 15/5/25.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "DSHomeStatus.h"
#import "DSAVStatus.h"
#import "DSStatus.h"


@interface DSHttpTool : NSObject

//监控网络状态
+ (void)monitoringReachabilityStatus:(void (^)(AFNetworkReachabilityStatus)) statusBlock;

//是否展示网络激活指示器
+ (void)showNetworkActivityIndicatior;


-(void)createStatusWithImage:(NSString*)text photos:(NSArray*)photos error:(NSError**)error;

-(void)createStatusWithText:(NSString*)text error:(NSError**)error;

-(void)findStatusWithBlock:(AVArrayResultBlock)block;

-(void)findMoreStatusWithBlock:(NSArray *)loadedStatusIDs block:(AVArrayResultBlock)block;

-(void)commentToUser:(AVObject*)status content:(NSString*)content block:(AVBooleanResultBlock)block;

- (void)digOrCancelDigOfStatus:(DSStatus *)status sender:(UIButton *)sender block:(AVBooleanResultBlock)block;

-(DSHomeStatus *)showHomestatusFromAVObjects:(NSArray *)objects;
- (NSArray *)showCommentFromAVObject:(NSArray *)object;

@end
