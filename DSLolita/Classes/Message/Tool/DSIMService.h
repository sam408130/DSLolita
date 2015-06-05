//
//  DSIMService.h
//  DSLolita
//
//  Created by 赛 丁 on 15/6/5.
//  Copyright (c) 2015年 samDing. All rights reserved.
//
#import <Foundation/Foundation.h>


@interface DSIMService : NSObject<DSUserDelegate>

+(instancetype)shareInstance;

-(void)goWithUserId:(NSString*)userId fromVC:(UIViewController*)vc;

-(void)goWithConv:(AVIMConversation*)conv fromNav:(UINavigationController*)nav;

@end
