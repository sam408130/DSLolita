//
//  JKAssetsGroupsView.h
//  JKImagePicker
//
//  Created by Jecky on 15/1/11.
//  Copyright (c) 2015年 Jecky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "JKAssets.h"

@class JKAssetsGroupsView;

@protocol JKAssetsGroupsViewDelegate <NSObject>
@optional
- (void)assetsGroupsViewDidCancel:(JKAssetsGroupsView *)groupsView;
- (void)assetsGroupsView:(JKAssetsGroupsView *)groupsView didSelectAssetsGroup:(ALAssetsGroup *)assGroup;

@end

@interface JKAssetsGroupsView : UIView

@property (nonatomic, weak) id<JKAssetsGroupsViewDelegate>  delegate;
@property (nonatomic, assign) NSInteger indexAssetsGroup;
@property (nonatomic, strong) NSArray   *assetsGroups;

@property (nonatomic, strong) NSMutableDictionary   *selectedAssetCount;

- (void)removeAssetSelected:(JKAssets *)asset;
- (void)addAssetSelected:(JKAssets *)asset;

@end
