//
//  AVUser+Avatar.m
//  FreeChat
//
//  Created by Feng Junwen on 3/6/15.
//  Copyright (c) 2015 Feng Junwen. All rights reserved.
//

#import "AVUser+Avatar.h"

#define kAttrKey_AvatarFile @"avatarFile"

@implementation AVUser (Avatar)

- (NSString*)avatarUrl {
    AVFile *avatarFile = [self objectForKey:kAttrKey_AvatarFile];
    return [avatarFile url];
}

- (void)updateAvatarWithImage:(UIImage*)image callback:(AVBooleanResultBlock)block{
    AVFile *oldFile = [self objectForKey:kAttrKey_AvatarFile];
    AVFile *newFile = [AVFile fileWithData:UIImagePNGRepresentation(image)];
    [newFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!succeeded) {
            if (block) {
                block(succeeded, error);
            };
            return;
        }
        [self setObject:newFile forKey:kAttrKey_AvatarFile];
        [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [oldFile deleteInBackground];
            }
            if (block) {
                block(succeeded, error);
            }
        }];
    }];
}

@end
