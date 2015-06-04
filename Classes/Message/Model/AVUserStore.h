//
//  AVUserStore.h
//  FreeChat
//
//  Created by Feng Junwen on 2/11/15.
//  Copyright (c) 2015 Feng Junwen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserProfile.h"

@interface AVUserStore : NSObject <UserProfileProvider>

+(instancetype)sharedInstance;

- (void)fetchInfos:(NSArray*)userIds callback:(ArrayResultBlock)block;
- (UserProfile*)getUserProfile:(NSString*)userId;

@end
