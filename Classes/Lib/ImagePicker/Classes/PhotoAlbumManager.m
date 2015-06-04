//
//  PhotoAlbumManager.m
//  JKImagePicker
//
//  Created by Jecky on 15/1/16.
//  Copyright (c) 2015年 Jecky. All rights reserved.
//

#import "PhotoAlbumManager.h"

#import "PhotoAlbumManager.h"

@interface PhotoAlbumManager()

@property (nonatomic, strong) ALAssetsLibrary   *assetsLibrary;
@end

@implementation PhotoAlbumManager

+ (PhotoAlbumManager *)sharedManager;
{
    static PhotoAlbumManager   *photoAlbumManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        photoAlbumManager = [[PhotoAlbumManager alloc] init];
    });
    
    return photoAlbumManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)saveImage:(UIImage*)image toAlbum:(NSString*)albumName completionBlock:(SaveImageCompletion)completionBlock
{
    __weak PhotoAlbumManager *weakSelf = self;
    [self.assetsLibrary writeImageToSavedPhotosAlbum:image.CGImage
                                         orientation:(ALAssetOrientation)image.imageOrientation
                                     completionBlock:^(NSURL *assetURL, NSError *error) {
                                         //error handling
                                         if (error!=nil) {
                                             completionBlock(nil, error);
                                             return;
                                         }
                                         //add the asset to the custom photo album
                                         PhotoAlbumManager  *strongSelf = weakSelf;
                                         [strongSelf addAssetURL:assetURL
                                                         toAlbum:albumName
                                                 completionBlock:completionBlock];
                                         
                                     }];
    
}

-(void)addAssetURL:(NSURL*)assetURL toAlbum:(NSString*)albumName completionBlock:(SaveImageCompletion)completionBlock
{
    __weak PhotoAlbumManager *weakSelf = self;
    __block BOOL albumWasFound = NO;
    
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                      usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                          PhotoAlbumManager  *strongSelf = weakSelf;
                                          //compare the names of the albums
                                          if ([albumName compare: [group valueForProperty:ALAssetsGroupPropertyName]]==NSOrderedSame) {
                                              
                                              //target album is found
                                              albumWasFound = YES;
                                              
                                              //get a hold of the photo's asset instance
                                              [strongSelf.assetsLibrary assetForURL: assetURL
                                                                        resultBlock:^(ALAsset *asset) {
                                                                            //add photo to the target album
                                                                            [group addAsset: asset];
                                                                            //run the completion block
                                                                            completionBlock(asset,nil);
                                                                            
                                                                        } failureBlock:^(NSError *error) {
                                                                            completionBlock(nil,error);
                                                                        }];
                                              
                                              //album was found, bail out of the method
                                              *stop = YES;
                                              return;
                                          }
                                          
                                          if (group==nil && albumWasFound==NO) {
                                              //photo albums are over, target album does not exist, thus create it
                                              //create new assets album
                                              
                                              __weak ALAssetsLibrary *weakLibray = strongSelf.assetsLibrary;
                                              
                                              [strongSelf.assetsLibrary addAssetsGroupAlbumWithName:albumName
                                                                                        resultBlock:^(ALAssetsGroup *group) {
                                                                                            //get the photo's instance
                                                                                            [weakLibray assetForURL:assetURL
                                                                                                        resultBlock:^(ALAsset *asset) {
                                                                                                            //add photo to the newly created album
                                                                                                            [group addAsset: asset];
                                                                                                            
                                                                                                            //call the completion block
                                                                                                            completionBlock(asset,nil);
                                                                                                        } failureBlock:^(NSError *error) {
                                                                                                            completionBlock(nil,error);
                                                                                                        }];
                                                                                            
                                                                                        } failureBlock:^(NSError *error) {
                                                                                            completionBlock(nil,error);
                                                                                        }];
                                              
                                              //should be the last iteration anyway, but just in case
                                              *stop = YES;
                                              return;
                                          }
                                          
                                      } failureBlock:^(NSError *error) {
                                          completionBlock(nil,error);
                                          
                                      }];
}

#pragma mark - getter
- (ALAssetsLibrary *)assetsLibrary{
    if (!_assetsLibrary) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetsLibrary;
}

@end
