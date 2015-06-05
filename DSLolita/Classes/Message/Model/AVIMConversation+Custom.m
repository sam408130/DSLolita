//
//  AVIMConversation+Custon.m
//  DSLolita
//
//  Created by 赛 丁 on 15/6/5.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "AVIMConversation+Custom.h"
#import "DSIM.h"
#import "UIImage+Icon.h"

@implementation AVIMConversation(Custom)

-(DSConvType)type{
    return [[self.attributes objectForKey:CONV_TYPE] intValue];
}

+(NSString*)nameOfUserIds:(NSArray*)userIds{
    NSMutableArray* names=[NSMutableArray array];
    for(int i=0;i<userIds.count;i++){
        id<DSUserModel> user=[[DSIMConfig config].userDelegate getUserById:[userIds objectAtIndex:i]];
        [names addObject:user.username];
    }
    return [names componentsJoinedByString:@","];
}

-(NSString*)displayName{
    if([self type]==DSConvTypeSingle){
        NSString* otherId=[self otherId];
        id<DSUserModel> other=[[DSIMConfig config].userDelegate getUserById:otherId];
        return other.username;
    }else{
        return self.name;
    }
}

-(NSString*)otherId{
    NSArray* members=self.members;
//    if(members.count!=2){
//        [NSException raise:@"invalid conv" format:nil];
//    }
     DSIM* im=[DSIM sharedInstance];
//    if([members containsObject:im.selfId]==NO){
//        [NSException raise:@"invalid conv" format:nil];
//    }
    NSString* otherId;
    if([members[0] isEqualToString:im.selfId]){
        otherId=members[1];
    }else{
        otherId=members[0];
    }
    return otherId;
}

-(NSString*)title{
    if(self.type==DSConvTypeSingle){
        return self.displayName;
    }else{
        return [NSString stringWithFormat:@"%@(%ld)",self.displayName,(long)self.members.count];
    }
}

-(UIImage*)icon{
    return [UIImage imageWithHashString:self.conversationId displayString:[[self.name substringWithRange:NSMakeRange(0, 1)] capitalizedString]];
}

@end
