//
//  AVOSCloudCrashReporting.h
//  AVOSCloudCrashReporting
//
//  Created by Qihe Bian on 4/24/15.
//  Copyright (c) 2015 LeanCloud Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 The `AVOSCloudCrashReporting` class is responsible for enabling crash reporting in your application.
 */
@interface AVOSCloudCrashReporting : NSObject

///--------------------------------------
/// @name Crash Reporting
///--------------------------------------

/*!
 @abstract Enables crash reporting for your app.
 
 @warning This must be called before you set Application ID and Client Key on AVOSCloud.
 */
+ (void)enable;

/*!
 @abstract Indicates whether crash reporting is currently enabled.
 
 @returns `YES` if crash reporting is enabled, `NO` - otherwise.
 */
+ (BOOL)isCrashReportingEnabled;

@end