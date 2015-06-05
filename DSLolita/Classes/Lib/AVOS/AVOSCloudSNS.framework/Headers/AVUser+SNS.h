//
//  AVUser+SNS.h
//  VZ
//
//  Created by Travis on 13-10-28.
//  Copyright (c) 2013 AVOS. All rights reserved.
//

#ifndef VZ_AVUser_SNS_h
#define VZ_AVUser_SNS_h

#import <AVOSCloud/AVUser.h>
#import <AVOSCloudSNS/AVOSCloudSNS.h>

#if !defined(AVDeprecated)
#  define AVDeprecated(explain) __attribute__((deprecated(explain)))
#endif

extern NSString *const AVOSCloudSNSPlatformWeiBo;
extern NSString *const AVOSCloudSNSPlatformQQ;
extern NSString *const AVOSCloudSNSPlatformWeiXin;

@interface AVUser(SNS)

/**
 *  用SNS数据登录
 *
 *  @discussion 如果登录成功, 会将currentUser设置为登录后返回的AVUser或其子类
 *  @param  authData     SNS平台登录返回的用户验证数据.不同平台数据字段不同
 *      微博平台
 *      {
 *      "uid": "123456789",
 *      "access_token": "2.00vs3XtCI5FevCff4981adb5jj1lXE",
 *      "expiration_in": "36000"
 *      }
 *      QQ平台
 *      {
 *      "openid": "0395BA18A5CD6255E5BA185E7BEBA242",
 *      "access_token": "12345678-SaMpLeTuo3m2avZxh5cjJmIrAfx4ZYyamdofM7IjU",
 *      "expires_in": 1382686496
 *      }
 *      微信平台
 *      {
 *      "openid": "0395BA18A5CD6255E5BA185E7BEBA242",
 *      "access_token": "12345678-SaMpLeTuo3m2avZxh5cjJmIrAfx4ZYyamdofM7IjU",
 *      "expires_in": 1382686496
 *      }
 *  @param  platform     平台，如weibo、qq、weixin
 *  @param  block        完成后回调
 *
 */
+(void)loginWithAuthData:(NSDictionary*)authData platform:(NSString *)platform block:(AVUserResultBlock)block;

/**
 *  给用户绑定SNS验证数据
 *  @discussion 登录成功, 如果此用户为新建用户, 则自动设置为currentUser
 *
 *  @param  authData     SNS平台登录返回的用户验证数据. 不同平台数据字段不同,参考 +[loginWithAuthData:platform:block:]
 *  @param  platform     平台，如weibo、qq、weixin
 *  @param  block        完成后回调
 *
 */
-(void)addAuthData:(NSDictionary*)authData platform:(NSString *)platform block:(AVUserResultBlock)block;

/**
 *  取消SNS绑定
 *  @discussion 此操作同时会注销指定的平台登录
 *  @param  platform    平台，如weibo、qq、weixin
 *  @param  block   完成后回调
 *
 */
-(void)deleteAuthDataForPlatform:(NSString *)platform block:(AVUserResultBlock)block;

/**
 *  用SNS数据登录
 *  
 *  @discussion 如果登录成功, 会将currentUser设置为登录后返回的AVUser或其子类
 *  @param  authData     SNS平台登录返回的用户验证数据. 必需包含字段:`id`,`access_token`,`expires_at`,`platform`
 *  @param  block        完成后回调
 *
 */
+(void)loginWithAuthData:(NSDictionary*)authData block:(AVUserResultBlock)block AVDeprecated("使用+[loginWithAuthData:platform:block:]");

/**
 *  给用户绑定SNS验证数据
 *  @discussion 登录成功, 如果此用户为新建用户, 则自动设置为currentUser
 *
 *  @param  authData     SNS平台登录返回的用户验证数据. 必需包含字段:`id`,`access_token`,`expires_at`,`platform`
 *  @param  block        完成后回调
 *
 */
-(void)addAuthData:(NSDictionary*)authData block:(AVUserResultBlock)block AVDeprecated("使用-[addAuthData:platform:block:]");

/**
 *  取消SNS绑定
 *  @discussion 此操作同时会注销指定的平台登录
 *  @param  type    SNS平台类型
 *  @param  block   完成后回调
 *
 */
-(void)deleteAuthForPlatform:(AVOSCloudSNSType)type block:(AVUserResultBlock)block AVDeprecated("使用-[deleteAuthDataForPlatform:block:]");
@end

#endif
