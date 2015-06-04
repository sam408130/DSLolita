//
//  UserProfile.h
//  FreeChat
//
//  Created by Feng Junwen on 2/11/15.
//  Copyright (c) 2015 Feng Junwen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constrains.h"

@interface UserProfile : NSObject

@property (nonatomic, copy) NSString *objectId;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avatarUrl;

@end

@protocol UserProfileProvider <NSObject>

- (void)fetchInfos:(NSArray*)userIds callback:(ArrayResultBlock)block;

@end