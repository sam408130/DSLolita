//
//  DSUtils.m
//  DSLolita
//
//  Created by 赛 丁 on 15/6/5.
//  Copyright (c) 2015年 samDing. All rights reserved.
//


#import "DSUtils.h"
#define DS_VERSION @"version"

@implementation DSUtils

+(UIAlertView*)alert:(NSString*)msg{
    UIAlertView *alertView=[[UIAlertView alloc]
                            initWithTitle:nil message:msg delegate:nil
                            cancelButtonTitle:@"好的" otherButtonTitles:nil];
    [alertView show];
    return alertView;
}

+(BOOL)alertError:(NSError*)error{
    if(error){
        if(error.code==kAVIMErrorConnectionLost){
            [DSUtils alert:@"未能连接聊天服务"];
        }else if([error.domain isEqualToString:NSURLErrorDomain]){
            [DSUtils alert:@"网络连接发生错误"];
        }else{
#ifndef DEBUG
            [DSUtils alert:[NSString stringWithFormat:@"%@",error]];
#else
            NSString* info=error.localizedDescription ;
            [DSUtils alert:info? info: [NSString stringWithFormat:@"%@",error]];
#endif
        }
        return YES;
    }
    return NO;
}

+(BOOL)filterError:(NSError*)error{
    return [self alertError:error]==NO;
}

+(void)filterError:(NSError*)error callback:(dispatch_block_t)callback{
    if(error){
        [DSUtils alertError:error];
    }else{
        if(callback){
            callback();
        }
    }
}

+(void)logError:(NSError*)error callback:(dispatch_block_t)callback{
    if(error){
        NSLog(@"%@",[error localizedDescription]);
    }else{
        callback();
    }
}

+(NSMutableArray*)setToArray:(NSMutableSet*)set{
    return [[NSMutableArray alloc] initWithArray:[set allObjects]];
}

+(NSString*)md5OfString:(NSString*)s{
    const char *ptr = [s UTF8String];
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(ptr, strlen(ptr), md5Buffer);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}


+ (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(UIImage *)roundImage:(UIImage *) image toSize:(CGSize)size radius: (float) radius;
{
    CGRect rect=CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [[UIBezierPath bezierPathWithRoundedRect:rect
                                cornerRadius:radius] addClip];
    [image drawInRect:rect];
    UIImage* rounded = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return rounded;
}

+(void)pickImageFromPhotoLibraryAtController:(UIViewController*)controller{
    UIImagePickerControllerSourceType srcType=UIImagePickerControllerSourceTypePhotoLibrary;
    NSArray* mediaTypes=[UIImagePickerController availableMediaTypesForSourceType:srcType];
    if([UIImagePickerController isSourceTypeAvailable:srcType] && [mediaTypes count]>0){
        UIImagePickerController* ctrler=[[UIImagePickerController alloc] init];
        ctrler.mediaTypes=mediaTypes;
        ctrler.delegate=(id)controller;
        ctrler.allowsEditing=YES;
        ctrler.sourceType=srcType;
        [controller presentViewController:ctrler animated:YES completion:nil];
    }else{
        [DSUtils alert:@"no image picker available"];
    }
}

+(UIImage*)imageWithColor:(UIColor *)color{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(UIColor*)randomColor{
    CGFloat hue=arc4random()%256/256.0;
    CGFloat saturation=arc4random()%128/256.0+0.5;
    CGFloat brightness=arc4random()%128/256.0+0.5;
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

+(NSArray*)reverseArray:(NSArray*)originArray{
    NSMutableArray* array=[NSMutableArray arrayWithCapacity:[originArray count]];
    NSEnumerator* enumerator=[originArray reverseObjectEnumerator];
    for(id element in enumerator){
        [array addObject:element];
    }
    return array;
}

+(void)runInMainQueue:(void (^)())queue{
    dispatch_async(dispatch_get_main_queue(), queue);
}

+(void)runInGlobalQueue:(void (^)())queue{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), queue);
}

+(void)runAfterSecs:(float)secs block:(void (^)())block{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs*NSEC_PER_SEC), dispatch_get_main_queue(), block);
}

+(void)postNotification:(NSString*)name{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
}

#pragma mark - view util

+(UIActivityIndicatorView*)showIndicatorAtView:(UIView*)hookView{
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = CGPointMake(hookView.frame.size.width * 0.5, hookView.frame.size.height * 0.5-50);
    [hookView addSubview:indicator];
    [hookView bringSubviewToFront:indicator];
    indicator.hidden=NO;
    [indicator startAnimating];
    return indicator;
}

+(void)showNetworkIndicator{
    UIApplication* app=[UIApplication sharedApplication];
    app.networkActivityIndicatorVisible=YES;
}

+(void)hideNetworkIndicator{
    UIApplication* app=[UIApplication sharedApplication];
    app.networkActivityIndicatorVisible=NO;
}

+(void)hideNetworkIndicatorAndAlertError:(NSError*)error{
    [self hideNetworkIndicator];
    [DSUtils alertError:error];
}

+(void)setCellMarginsZero:(UITableViewCell*)cell{
    if([cell respondsToSelector:@selector(layoutMargins)]){
        cell.layoutMargins=UIEdgeInsetsZero;
    }
}

+(void)setTableViewMarginsZero:(UITableView*)view{
    if(SYSTEM_VERSION<8){
        if ([view respondsToSelector:@selector(setSeparatorInset:)]) {
            [view setSeparatorInset:UIEdgeInsetsZero];
        }
    }else{
        if ([view respondsToSelector:@selector(layoutMargins)]) {
            view.layoutMargins = UIEdgeInsetsZero;
        }
    }
}

+(void)stopRefreshControl:(UIRefreshControl*)refreshControl{
    if(refreshControl!=nil && [[refreshControl class] isSubclassOfClass:[UIRefreshControl class]]){
        [refreshControl endRefreshing];
    }
}

#pragma mark - AVUtil


+(NSString*)uuid{
    NSString *chars=@"abcdefghijklmnopgrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    assert(chars.length==62);
    int len=chars.length;
    NSMutableString* result=[[NSMutableString alloc] init];
    for(int i=0;i<24;i++){
        int p=arc4random_uniform(len);
        NSRange range=NSMakeRange(p, 1);
        [result appendString:[chars substringWithRange:range]];
    }
    return result;
}

+ (void)downloadWithUrl:(NSString *)url toPath:(NSString *)path {
    NSData* data=[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    NSError* error;
    [data writeToFile:path options:NSDataWritingAtomic error:&error];
    if(error==nil){
        NSLog(@"writeSucceed");
    }else{
        NSLog(@"error when download file");
    }
}

#pragma mark - time

+(int64_t)int64OfStr:(NSString*)str{
    return [str longLongValue];
}

+(NSString*)strOfInt64:(int64_t)num{
    return [[NSNumber numberWithLongLong:num] stringValue];
}

#pragma mark - upgrade

+(NSString*)currentVersion{
    NSString* versionStr=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return versionStr;
}

+(void)upgradeWithBlock:(DSUpgradeBlock)callback{
    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
    NSString* version=[defaults objectForKey:DS_VERSION];
    NSString* curVersion=[[self class] currentVersion];
    BOOL upgrade=[version compare:curVersion options:NSNumericSearch]==NSOrderedAscending;
    callback(upgrade,version,curVersion);
    [defaults setObject:curVersion forKey:DS_VERSION];
}

@end
