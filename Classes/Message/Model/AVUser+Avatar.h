//
//  AVUser+Avatar.h
//  FreeChat
//
//  Created by Feng Junwen on 3/6/15.
//  Copyright (c) 2015 Feng Junwen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVOSCloud/AVOSCloud.h"

@interface AVUser (Avatar)

- (NSString*)avatarUrl;
- (void)updateAvatarWithImage:(UIImage*)image callback:(AVBooleanResultBlock)block;

@end
