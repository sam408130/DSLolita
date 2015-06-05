//
//  DSUser.m
//  DSLolita
//
//  Created by 赛 丁 on 15/5/25.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSUser.h"

#define DSUserFilepath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.arch"]

@implementation DSUser





+ (void)save:(AVUser *)user {
    
    
    DSUser *curUser = [[DSUser alloc] init];
    
    if (user != nil) {
        
        curUser.username = user.username;
        
        curUser.avatarUrl = ((AVFile *)[user objectForKey:@"avatar"]).url;
        
        curUser.userId = user.objectId;
        
    }
    
    
    //[NSKeyedArchiver archiveRootObject:curUser toFile:DSUserFilepath];
    
}

+ (DSUser *)readLocalUser {
    
    DSUser *account = [NSKeyedUnarchiver unarchiveObjectWithFile:DSUserFilepath];
    
    return account;
}


+ (DSUser *)transfer:(AVUser *)user {
    
    DSUser *curUser = [[DSUser alloc] init];
    
    if (user != nil) {
        
        curUser.username = user.username;
        
        curUser.avatarUrl = ((AVFile *)[user objectForKey:@"avatar"]).url;
        
        curUser.userId = user.objectId;
        
    }
    
    return curUser;
    
}

@end
