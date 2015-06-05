//
//  DSUserService.m
//  DSLolita
//
//  Created by 赛 丁 on 15/6/5.
//  Copyright (c) 2015年 samDing. All rights reserved.
//


#import "DSUserService.h"
#import "DSUtils.h"
#import "DSCache.h"
#import "DSAbuseReport.h"


static UIImage* defaultAvatar;

@implementation DSUserService

+(void)findFriendsWithBlock:(AVArrayResultBlock)block{
    AVUser* user=[AVUser currentUser];
    AVQuery* q=[user followeeQuery];
    q.cachePolicy=kAVCachePolicyNetworkElseCache;
    [q findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error==nil){
            [DSCache registerUsers:objects];
        }
        block(objects,error);
    }];
}

+(void)isMyFriend:(AVUser*)user block:(AVBooleanResultBlock)block{
    AVUser* currentUser=[AVUser currentUser];
    AVQuery*q=[currentUser followeeQuery];
    [q whereKey:@"followee" equalTo:user];
    [q findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error){
            block(NO,error);
        }else{
            if(objects.count>0){
                block(YES,nil);
            }else{
                block(NO,error);
            }
        }
    }];
};


+(NSString*)getPeerIdOfUser:(AVUser*)user{
    return user.objectId;
}

// should exclude friends
+(void)findUsersByPartname:(NSString *)partName withBlock:(AVArrayResultBlock)block{
    AVQuery *q=[AVUser query];
    [q setCachePolicy:kAVCachePolicyNetworkElseCache];
    [q whereKey:@"username" containsString:partName];
    AVUser *curUser=[AVUser currentUser];
    [q whereKey:@"objectId" notEqualTo:curUser.objectId];
    [q orderByDescending:@"updatedAt"];
    [q findObjectsInBackgroundWithBlock:block];
}

+(void)findUsersByIds:(NSArray*)userIds callback:(AVArrayResultBlock)callback{
    if([userIds count]>0){
        AVQuery *q=[AVUser query];
        [q setCachePolicy:kAVCachePolicyNetworkElseCache];
        [q whereKey:@"objectId" containedIn:userIds];
        [q findObjectsInBackgroundWithBlock:callback];
    }else{
        callback([[NSArray alloc] init],nil);
    }
}

+(void)displayAvatarOfUser:(AVUser*)user avatarView:(UIImageView*)avatarView{
    [self getAvatarImageOfUser:user block:^(UIImage *image) {
        [avatarView setImage:image];
    }];
}

+(void)displayBigAvatarOfUser:(AVUser*)user avatarView:(UIImageView*)avatarView{
    CGFloat avatarWidth=60;
    CGSize avatarSize=CGSizeMake(avatarWidth, avatarWidth);
    UIGraphicsBeginImageContextWithOptions(avatarSize, NO, 0.0);
    UIImage *blank=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    avatarView.image=blank;
    [DSUserService getAvatarImageOfUser:user block:^(UIImage *image) {
        UIImage *resizedImage=[DSUtils resizeImage:image toSize:avatarSize];
        avatarView.image=resizedImage;
    }];
}

+(void)getAvatarImageOfUser:(AVUser*)user block:(void (^)(UIImage* image))block{
    AVFile* avatar=[user objectForKey:@"avatar"];
    if(avatar){
        [avatar getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if(error==nil){
                block([UIImage imageWithData:data]);
            }else{
                block([self defaultAvatarOfUser:user]);
            }
        }];
    }else{
        block([self defaultAvatarOfUser:user]);
    }
}

+(UIImage*)defaultAvatarOfUser:(AVUser*)user{
    return [UIImage imageWithHashString:user.objectId displayString:[[user.username substringWithRange:NSMakeRange(0, 1)] capitalizedString]];
}

+(void)saveAvatar:(UIImage*)image callback:(AVBooleanResultBlock)callback{
    NSData* data=UIImagePNGRepresentation(image);
    AVFile* file=[AVFile fileWithData:data];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error){
            callback(succeeded,error);
        }else{
            AVUser* user=[AVUser currentUser];
            [user setObject:file forKey:@"avatar"];
            [user setFetchWhenSave:YES];
            [user saveInBackgroundWithBlock:callback];
        }
    }];
}

+(void)addFriend:(AVUser*)user callback:(AVBooleanResultBlock)callback{
    AVUser* curUser=[AVUser currentUser];
    [curUser follow:user.objectId andCallback:callback];
}

+(void)removeFriend:(AVUser*)user callback:(AVBooleanResultBlock)callback{
    AVUser* curUser=[AVUser currentUser];
    [curUser unfollow:user.objectId andCallback:callback];
}

#pragma mark - AddRequest

+(void)findAddRequestsWithBlock:(AVArrayResultBlock)block{
    AVUser* curUser=[AVUser currentUser];
    AVQuery *q=[DSAddRequest query];
    [q includeKey:kAddRequestFromUser];
    [q whereKey:kAddRequestToUser equalTo:curUser];
    [q orderByDescending:@"createdAt"];
    [q findObjectsInBackgroundWithBlock:block];
}

+(void)countAddRequestsWithBlock:(AVIntegerResultBlock)block{
    AVQuery  *q=[DSAddRequest query];
    AVUser* user=[AVUser currentUser];
    [q whereKey:@"toUser" equalTo:user];
    [q setCachePolicy:kAVCachePolicyNetworkElseCache];
    [q countObjectsInBackgroundWithBlock:block];
}

+(void)agreeAddRequest:(DSAddRequest*)addRequest callback:(AVBooleanResultBlock)callback{
    [DSUserService addFriend:addRequest.fromUser callback:^(BOOL succeeded, NSError *error) {
        if(error){
            if(error.code!=kAVErrorDuplicateValue){
                callback(NO,error);
            }else{
                addRequest.status=DSAddRequestStatusDone;
                [addRequest saveInBackgroundWithBlock:callback];
            }
        }else{
            addRequest.status=DSAddRequestStatusDone;
            [addRequest saveInBackgroundWithBlock:callback];
        }
    }];
}

+(void)haveWaitAddRequestWithToUser:(AVUser*)toUser callback:(AVBooleanResultBlock)callback{
    AVUser* user=[AVUser currentUser];
    AVQuery* q=[DSAddRequest query];
    [q whereKey:kAddRequestFromUser equalTo:user];
    [q whereKey:kAddRequestToUser equalTo:toUser];
    [q whereKey:kAddRequestStatus equalTo:@(DSAddRequestStatusWait)];
    [q countObjectsInBackgroundWithBlock:^(NSInteger number, NSError *error) {
        if(error){
            if(error.code==kAVErrorObjectNotFound){
                callback(NO,nil);
            }else{
                callback(NO,error);
            }
        }else{
            if(number>0){
                callback(YES,error);
            }else{
                callback(NO,error);
            }
        }
    }];
}

+(void)tryCreateAddRequestWithToUser:(AVUser*)user callback:(AVBooleanResultBlock)callback{
    [self haveWaitAddRequestWithToUser:user callback:^(BOOL succeeded, NSError *error) {
        if(error){
            callback(NO,error);
        }else{
            if(succeeded){
                callback(YES,[NSError errorWithDomain:@"Add Request" code:0 userInfo:@{NSLocalizedDescriptionKey:@"已经请求过了"}]);
            }else{
                AVUser* curUser=[AVUser currentUser];
                DSAddRequest* addRequest=[[DSAddRequest alloc] init];
                addRequest.fromUser=curUser;
                addRequest.toUser=user;
                addRequest.status=DSAddRequestStatusWait;
                [addRequest saveInBackgroundWithBlock:callback];
            }
        }
    }];
}

#pragma mark - report abuse
+(void)reportAbuseWithReason:(NSString*)reason convid:(NSString*)convid block:(AVBooleanResultBlock)block{
    DSAbuseReport *report=[[DSAbuseReport alloc] init];
    report.reason=reason;
    report.convid=convid;
    report.author=[AVUser currentUser];
    [report saveInBackgroundWithBlock:block];
}

@end
