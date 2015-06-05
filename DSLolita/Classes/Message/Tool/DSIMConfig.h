//
//  DSIMConfig.h
//  DSLolita
//
//  Created by 赛 丁 on 15/6/5.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloudIM/AVOSCloudIM.h>
#import "DSUserModel.h"

@protocol DSUserDelegate <NSObject>

@required

//同步方法
-(id<DSUserModel>) getUserById:(NSString*)userId;

//对于每条消息，都会调用这个方法来缓存发送者的用户信息，以便 getUserById 直接返回用户信息
-(void)cacheUserByIds:(NSSet*)userIds block:(AVBooleanResultBlock)block;

@end

@interface DSIMConfig : NSObject

@property (nonatomic,strong) id<DSUserDelegate> userDelegate;

+(DSIMConfig*)config;

@end
