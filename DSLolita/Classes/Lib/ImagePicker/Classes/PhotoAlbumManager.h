//
//  PhotoAlbumManager.h
//  JKImagePicker
//
//  Created by Jecky on 15/1/16.
//  Copyright (c) 2015年 Jecky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef void(^SaveImageCompletion)(ALAsset *asset, NSError* error);

@interface PhotoAlbumManager : NSObject

+ (PhotoAlbumManager *)sharedManager;

-(void)saveImage:(UIImage*)image toAlbum:(NSString*)albumName completionBlock:(SaveImageCompletion)completionBlock;
-(void)addAssetURL:(NSURL*)assetURL toAlbum:(NSString*)albumName completionBlock:(SaveImageCompletion)completionBlock;
@end
