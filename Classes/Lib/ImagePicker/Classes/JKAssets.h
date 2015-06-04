//
//  JKAssets.h
//  JKImagePicker
//
//  Created by Jecky on 15/1/13.
//  Copyright (c) 2015年 Jecky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface JKAssets : NSObject<NSCoding>

@property (nonatomic, strong) NSString  *groupPropertyID;
@property (nonatomic, strong) NSURL     *groupPropertyURL;
@property (nonatomic, strong) NSURL     *assetPropertyURL;
@property (nonatomic, strong) UIImage   *photo;

@end
