
//
//  DSHttpTool.m
//  DSLolita
//
//  Created by 赛 丁 on 15/5/25.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSHttpTool.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "DSAVStatus.h"
#import "DSAVComment.h"
#import "DSStatus.h"
#import "DSComment.h"
#import "DSUser.h"
#import "NSDate+Estension.h"
#import "JKAssets.h"
#import <AssetsLibrary/AssetsLibrary.h>


@implementation DSHttpTool

+ (void)monitoringReachabilityStatus:(void (^)(AFNetworkReachabilityStatus))statusBlock {
    
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    //当前网络改变了就会调用
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
        if (status){
            statusBlock(status);
        }
    }];
    //开始监控
    [mgr startMonitoring];
 }



+ (void)showNetworkActivityIndicatior {
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
}


+ (DSHttpTool *)manager {
    static DSHttpTool* feedManager;
    static dispatch_once_t oneceToken;
    dispatch_once(&oneceToken, ^{
        feedManager = [[DSHttpTool alloc] init];
    });
    return feedManager;
}

- (void)createStatusWithText:(NSString *)text error:(NSError *__autoreleasing *)error {
    
    if (text == nil) {
        text = @"";
    }
    NSError *theError;
    AVUser *user = [AVUser currentUser];
    //DSAVStatus *avstatus = [DSAVStatus object];
    AVObject *avstatus = [AVObject objectWithClassName:@"Album"];
    [avstatus setObject:user forKey:@"creator"];
    [avstatus setObject:text forKey:@"albumContent"];
    [avstatus setObject:[NSArray array] forKey:@"comments"];
    [avstatus save:&theError];
    *error = theError;
    
}


- (void)createStatusWithImage:(NSString *)text photos:(NSArray *)photos error:(NSError**)error {
    
    if (text == nil) {
        text = @"";
    }
    
    NSMutableArray *photoFiles = [NSMutableArray array];
    NSError* theError;
    for(UIImage* photo in photos){

        
        AVFile* photoFile=[AVFile fileWithData:UIImagePNGRepresentation(photo)];
        [photoFile save:&theError];
        if(theError==nil){
            [photoFiles addObject:photoFile];
        }else{
            *error=theError;
            for(AVFile* file in photoFiles){
                [file deleteInBackground];
            }
            return;
        }
    }

    AVUser *user = [AVUser currentUser];
    DSAVStatus *avstatus = [DSAVStatus object];
    avstatus.creator = user;
    //avstatus.statusContent = text;
    [avstatus setObject:text forKey:@"albumContent"];
    avstatus.albumPhotos = photoFiles;
    avstatus.comments = [NSArray array];
    [avstatus save:&theError];
    *error = theError;
    


    
}



- (void)findStatusWithBlock:(AVArrayResultBlock)block {
    
    AVQuery *query = [DSAVStatus query];
    
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"albumPhotos"];
    [query includeKey:@"creator"];
    [query includeKey:@"comments.commentUser"];
    [query includeKey:@"comments.toUser"];
    [query setCachePolicy:kAVCachePolicyNetworkElseCache];
     query.limit = 50;
    [query findObjectsInBackgroundWithBlock:block];
}


- (void)findMoreStatusWithBlock:(NSArray *)loadedStatusIDs block:(AVArrayResultBlock)block {
    
    AVQuery *query = [DSAVStatus query];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"albumPhotos"];
    [query includeKey:@"creator"];
    [query includeKey:@"comments.commentUser"];
    [query includeKey:@"comments.toUser"];
    [query whereKey:@"objectId" notContainedIn:loadedStatusIDs];
    [query setCachePolicy:kAVCachePolicyNetworkElseCache];
    query.limit = 50;
    [query findObjectsInBackgroundWithBlock:block];

}

- (NSArray *)getObjectIds:(NSArray *)avObjects{
    NSMutableArray *objectIds = [NSMutableArray array];
    for(AVObject *object in avObjects){
        [objectIds addObject:object.objectId];
    }
    return objectIds;
}



- (void)setupButtonTitle:(UIButton *)button count:(int)count image:(NSString *)imagename defaultTitle:(NSString *)defaultTitle {
    
    if (count >= 10000){
        defaultTitle = [NSString stringWithFormat:@"%.1f万",count / 10000.0];
    }else if (count > 0){
        defaultTitle = [NSString stringWithFormat:@"%d",count];
    }
    [button setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
    
    [button setTitle:defaultTitle forState:UIControlStateNormal];
}


- (void)digOrCancelDigOfStatus:(DSStatus *)clickedStatus sender:(UIButton *)sender block:(AVBooleanResultBlock)block {
    
    AVQuery *query = [AVQuery queryWithClassName:@"Album"];
    AVObject *status = [query getObjectWithId:clickedStatus.idstr];
    
    AVUser *user = [AVUser currentUser];
    NSMutableArray *digUsers = [status objectForKey:@"digUsers"];
    
    if ( [digUsers containsObject:user]){
        [status removeObject:user forKey:@"digUsers"];
        [self setupButtonTitle:sender count:clickedStatus.attitudes_count - 1 image:@"timeline_icon_like_disable" defaultTitle:@"赞"];
        
    }else{
        [status addObject:user forKey:@"digUsers"];
        [self setupButtonTitle:sender count:clickedStatus.attitudes_count + 1 image:@"timeline_icon_like" defaultTitle:@"赞"];
    }
    
    [status saveInBackgroundWithBlock:block];
}


- (void)commentToUser:(AVObject *)status content:(NSString *)content block:(AVBooleanResultBlock)block {
    

    AVObject *comment = [AVObject objectWithClassName:@"Comment"];
    [comment setObject:content forKey:@"commentContent"];
    AVUser *user = [AVUser currentUser];
    [comment setObject:user forKey:@"commentUser"];
    [comment setObject:status forKey:@"album"];
    [comment setObject:[status objectForKey:@"creator"] forKey:@"toUser"];
    [comment setObject:user.username forKey:@"commentUsername"];
    AVFile *avatarfile = [user objectForKey:@"avatar"];
    [comment setObject:avatarfile.url forKey:@"avatarUrl"];
    [comment saveInBackgroundWithBlock:^(BOOL succeeded , NSError *error){
        if (error) {
            block(NO,error);
        }else{
            [status addObject:comment forKey:@"comments"];
            [status saveInBackgroundWithBlock:block];
        }
    }];
}

- (DSHomeStatus *)showHomestatusFromAVObjects:(NSArray *)objects {
    
    DSHomeStatus *homestatus = [[DSHomeStatus alloc] init];
    NSMutableArray *tempStatuses = [NSMutableArray array];
    NSMutableArray *tempLoadedIDs = [NSMutableArray array];
    homestatus.total_number = (int)objects.count;
    
    for (AVObject *object in objects) {
        
        DSStatus *status = [[DSStatus alloc] init];
        
        AVUser *creator = [object objectForKey:@"creator"];
        
        DSUser *feeduser = [[DSUser alloc] init];
        feeduser.username = creator.username;
        feeduser.userId = creator.objectId;
        AVFile *avatarFile = [creator objectForKey:@"avatar"];
        feeduser.avatarUrl = avatarFile.url;
        
        status.user = feeduser;

        NSString *text = [object objectForKey:@"albumContent"];
        if(text){
            status.attributedText = [[NSAttributedString alloc] initWithString:text];
        }else{
            status.attributedText = [[NSAttributedString alloc] initWithString:@""];
        }
        //status.attributedText = [[NSAttributedString alloc] initWithString:text];
        
        status.attitudes_count = (int)((NSArray *)[object objectForKey:@"digUsers"]).count;
        
        status.digusers = [object objectForKey:@"digUsers"];
        
        //status.reposts_count = (int)[object objectForKey:@"repostCount"];
        
        //AVObject *retweetedstatue = [object objectForKey:@"retweetedStatus"];
        
        //status.retweeted_status = [DSStatus transfer:retweetedstatue];
        
        status.comments_count = (int)((NSArray *)[object objectForKey:@"comments"]).count;;
        
        //status.source = [object objectForKey:@"source"];
        
        status.idstr = object.objectId;
        
        status.comments = [object objectForKey:@"comments"];
        
        NSArray *picFiles = [object objectForKey:@"albumPhotos"];
        
        NSMutableArray *picUrls = [NSMutableArray array];
        
        for (AVFile *file in picFiles) {
            
            [picUrls addObject:file.url];
            
        }
        status.pic_urls = picUrls;
        
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"EEE MMM dd HH24:mm:ss Z yyyy";
        NSDate *createDate = object.createdAt;
        if (createDate.isThisYear) {
            if (createDate.isToday) { // 今天
                NSDateComponents *cmps = [createDate deltaWithNow];
                if (cmps.hour >= 1) { // 至少是1小时前发的
                    status.created_at =  [NSString stringWithFormat:@"%ld小时前", (long)cmps.hour];
                } else if (cmps.minute >= 1) { // 1~59分钟之前发的
                    status.created_at = [NSString stringWithFormat:@"%ld分钟前", (long)cmps.minute];
                } else { // 1分钟内发的
                    status.created_at = @"刚刚";
                }
            } else if (createDate.isYesterday) { // 昨天
                fmt.dateFormat = @"昨天 HH:mm";
                status.created_at = [fmt stringFromDate:createDate];
            } else { // 至少是前天
                fmt.dateFormat = @"MM-dd HH:mm";
                status.created_at = [fmt stringFromDate:createDate];
            }
        } else { // 非今年
            fmt.dateFormat = @"yyyy-MM-dd";
            status.created_at = [fmt stringFromDate:createDate];
        }

     
        [tempStatuses addObject:status];
        [tempLoadedIDs addObject:status.idstr];
        
    }
    
    homestatus.statuses = [tempStatuses mutableCopy];
    homestatus.loadedObjectIDs = [tempLoadedIDs mutableCopy];
    return homestatus;
}


- (NSArray *)showCommentFromAVObject:(NSArray *)objects{
    
    NSMutableArray *box = [NSMutableArray array];
    
    for (AVObject *object in objects){
        
        //AVObject *object = [[AVQuery queryWithClassName:@"Comment"] getObjectWithId:obj.objectId];
        
        DSComment *comment = [[DSComment alloc] init];
        
        comment.idstr = object.objectId;
        
        comment.attributedText = [[NSAttributedString alloc] initWithString:[object objectForKey:@"commentContent"]];
        
        AVObject *creator = [object objectForKey:@"commentUser"];
        DSUser *commentUser = [[DSUser alloc] init];
        
        commentUser.userId = creator.objectId;
        commentUser.username = [object objectForKey:@"commentUsername"];
        commentUser.avatarUrl = [object objectForKey:@"avatarUrl"];
        comment.user = commentUser;
        
        comment.status = [object objectForKey:@"album"];
        
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"EEE MMM dd HH24:mm:ss Z yyyy";
        NSDate *createDate = object.createdAt;
        if (createDate.isThisYear) {
            if (createDate.isToday) { // 今天
                NSDateComponents *cmps = [createDate deltaWithNow];
                if (cmps.hour >= 1) { // 至少是1小时前发的
                    comment.created_at =  [NSString stringWithFormat:@"%ld小时前", (long)cmps.hour];
                } else if (cmps.minute >= 1) { // 1~59分钟之前发的
                    comment.created_at = [NSString stringWithFormat:@"%ld分钟前", (long)cmps.minute];
                } else { // 1分钟内发的
                    comment.created_at = @"刚刚";
                }
            } else if (createDate.isYesterday) { // 昨天
                fmt.dateFormat = @"昨天 HH:mm";
                comment.created_at = [fmt stringFromDate:createDate];
            } else { // 至少是前天
                fmt.dateFormat = @"MM-dd HH:mm";
                comment.created_at = [fmt stringFromDate:createDate];
            }
        } else { // 非今年
            fmt.dateFormat = @"yyyy-MM-dd";
            comment.created_at = [fmt stringFromDate:createDate];
        }
        
        [box insertObject:comment atIndex:0];
        
    }
    
    NSArray *comments = [[NSArray alloc] init];
    comments = [NSArray arrayWithArray:box];
    
    return comments;
    
    
    
}

@end
