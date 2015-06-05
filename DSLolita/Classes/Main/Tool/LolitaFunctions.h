//
//  LolitaFunctions.h
//  Lolita
//
//  Created by 赛 丁 on 15/5/18.
//  Copyright (c) 2015年 赛 丁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>




typedef NS_ENUM(NSUInteger, FollowType) {
    TypeFollow,
    TypeFollowing,
    TypeFollowed
};


@interface LolitaFunctions : NSObject{
    CGRect screenRect;
}

#pragma mark - Share Instance
+ (id)sharedObject;



#pragma mark - App Methods

-(UIColor *)colorWithR:(int)red g:(int)green b:(int)blue alpha:(float)alpha;
-(UIImageView *)leftViewForTextFieldWithImage:(NSString *)imageName;
-(BOOL)validateEmail:(NSString *)email;
-(UIView *)showLoadingViewWithText:(NSString *)strMessage inView:(UIView *)view;
-(void)hideLoadingView:(UIView *)loadingView;

-(NSString *)setTimeElapsedForDate:(NSDate *)starDate;


#pragma mark - Resizing image

-(UIImage *)resizeImageWithImage:(UIImage *)image toSize:(CGSize)newSize;

@end
