//
//  LolitaFunctions.m
//  Lolita
//
//  Created by 赛 丁 on 15/5/18.
//  Copyright (c) 2015年 赛 丁. All rights reserved.
//

#import "LolitaFunctions.h"

@implementation LolitaFunctions

#pragma mark - shared Instance
+ (id)sharedObject {
    static LolitaFunctions *sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [[self alloc] init];
    });
    return sharedObject;
}

#pragma mark - Init Method

- (id)init {
    self = [super init];
    if (self) {
        screenRect = [UIScreen mainScreen].bounds;
    }
    return self;
}

- (CGRect)screenRect {
    return [UIScreen mainScreen].bounds;
}


#pragma mark - App Methods

- (UIColor *)colorWithR:(int)red g:(int)green b:(int)blue alpha:(float)alpha{
    return [UIColor colorWithRed:red/255.0f
                           green:green/255.0f
                            blue:blue/255.0f
                           alpha:alpha];
}

- (UIImageView *)leftViewForTextFieldWithImage:(NSString *)imageName{
    UIImage *imageForLeftMode = [UIImage imageNamed:imageName];
    UIImageView *imgViewLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    [imgViewLeft setImage:imageForLeftMode];
    [imgViewLeft setContentMode:UIViewContentModeCenter];
    
    return imgViewLeft;
    
}


- (BOOL)validateEmail:(NSString *)email {
    
    NSString *emailRegEx=@"[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest=[NSPredicate predicateWithFormat:@"SELF MATCHES  %@",emailRegEx];
    return [emailTest evaluateWithObject:email];
    
    
}


- (UIView *)showLoadingViewWithText:(NSString *)strMessage inView:(UIView *)view{
    
    if (!strMessage || !strMessage.length){
        strMessage = @"加载中";
    }
    
    CGSize scrSize = screenRect.size;
    UIView *viewBackGround = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scrSize.width, scrSize.height)];
    [viewBackGround setBackgroundColor:[UIColor clearColor]];
    [viewBackGround setTag:100];
    
    UIView *viewWhite = [[UIView alloc] initWithFrame:CGRectMake(90, 100, 120, 100)];
    [viewWhite setTag:200];
    [viewWhite setCenter:CGPointMake(scrSize.width/2, scrSize.height/2)];
    [viewWhite setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.9f]];
    [viewBackGround addSubview:viewWhite];
    
    [viewWhite.layer setCornerRadius:6.0f];
    [viewWhite.layer setBorderColor:[self colorWithR:49 g:190 b:218 alpha:0.5f].CGColor];
    [viewWhite.layer setBorderWidth:1.0f];
    
    //[GMDCircleLoader setOnView:viewWhite withTitle:strMessage animated:YES];
    [MBProgressHUD showMessage:strMessage toView:viewWhite];
    viewWhite = nil;
    [view addSubview:viewBackGround];
    
    return viewBackGround;
    
}



- (void)hideLoadingView:(UIView *)loadingView {
    
    UIView *viewWhite = [loadingView viewWithTag:200];
    //[GMDCircleLoader hideFromView:viewWhite animated:YES];
    [MBProgressHUD hideHUDForView:viewWhite animated:YES];
    [[loadingView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [loadingView removeFromSuperview];
    loadingView = nil;
}

- (NSString *)setTimeElapsedForDate:(NSDate *)startDate {
    
    NSInteger timeToDisplay = 0;
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSUInteger unitFlags = NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    
    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:startDate
                                                  toDate:[NSDate date] options:0];
    timeToDisplay = [components second];
    
    NSString *strSpecifier = @"s";
    
    if ([components minute]) {
        timeToDisplay = [components minute];
        strSpecifier = @"m";
    }
    if ([components hour]) {
        timeToDisplay = [components hour];
        strSpecifier = @"h";
    }
    if ([components day]) {
        timeToDisplay = [components day];
        strSpecifier = @"d";
    }
    if ([components month]) {
        timeToDisplay = [components month];
        strSpecifier = @"m";
    }
    if ([components year]) {
        timeToDisplay = [components year];
        strSpecifier = @"y";
    }
    
    NSString *strTimeElapsed = [NSString stringWithFormat:@"%ld%@", (long)timeToDisplay, strSpecifier];
    return strTimeElapsed;
}

#pragma mark - Resizing image

- (UIImage *)resizeImageWithImage:(UIImage *)image toSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



@end
