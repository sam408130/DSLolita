//
//  AppDelegate.m
//  DSLolita
//
//  Created by 赛 丁 on 15/5/25.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "AppDelegate.h"
#import "DSControllerTool.h"
#import "LoginViewController.h"
#import "DSHttpTool.h"
#import "DSAVStatus.h"
#import "DSMessageCommon.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //启动成功以后不隐藏状态栏
    application.statusBarHidden = NO;
    [DSAVStatus registerSubclass];

    [AVOSCloud setApplicationId:ApplicationID clientKey:ClientKey];
    [OpenShare connectQQWithAppId:@"1103194207"];
    [OpenShare connectWeiboWithAppKey:@"402180334"];
    [OpenShare connectWeixinWithAppId:@"wxd930ea5d5a258f4f"];
    [OpenShare connectRenrenWithAppId:@"228525" AndAppKey:@"1dd8cba4215d4d4ab96a49d3058c1d7f"];
    
    //1.创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    
    //2.显示窗口成为主窗口
    [self.window makeKeyAndVisible];
    
    //3.设置窗口的根控制器
    AVUser *currentUser = [AVUser currentUser];
    if (currentUser != nil){
        [DSControllerTool chooseRootViewController];
        NSLog(@"已登录");
        
        
    }else{
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.window.rootViewController = (LoginViewController *)[main instantiateInitialViewController];
    }
    
    //4.监控网络
    [DSHttpTool monitoringReachabilityStatus:^(AFNetworkReachabilityStatus status){
       
        switch (status) {
            case AFNetworkReachabilityStatusUnknown://未知网络
            case AFNetworkReachabilityStatusNotReachable://没有网络
                [MBProgressHUD showError:@"网络异常，请检查网络设置！"];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN://手机自带网络
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                break;

        }
        
    }];
    //5.增加网络状态激活按钮
    [DSHttpTool showNetworkActivityIndicatior];
    
    //6.对于大于ios8.1的系统需要注册用户协议通知才能实现applicationIconBadgeNumber

#if __IPHONE_8_1
    if (iOS8){
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }else{
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound];
    }
    
#else
    UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
    [application registerForRemoteNotificationTypes:myTypes];
#endif

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSInteger num = application.applicationIconBadgeNumber;
    if (num != 0){
        AVInstallation *currentInstallation = [AVInstallation currentInstallation];
        [currentInstallation setBadge:0];
        [currentInstallation saveEventually:^(BOOL succeeded , NSError *error){
            NSLog(@"%@",error? error :@"succeed");
        }];
        application.applicationIconBadgeNumber = 0;
    }
    [application cancelAllLocalNotifications];


}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
    if(currentInstallation.deviceToken==nil){
        //first time register
        [currentInstallation setDeviceTokenFromData:deviceToken];
        [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            DLog(@"%@",error);
        }];
    }else{
        DLog(@"have registered");
    }
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    if (application.applicationState == UIApplicationStateActive) {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.userInfo = userInfo;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.alertBody = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        localNotification.fireDate = [NSDate date];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    } else {
        [AVAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
    DLog(@"receiveRemoteNotification");
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    if ([OpenShare handleOpenURL:url]){
        return  YES;
    }
    
    return  NO;
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "sam.ding.DSLolita" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DSLolita" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DSLolita.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
