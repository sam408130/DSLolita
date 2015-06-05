//
//  JKPhotoBrowserCell.h
//  JKPhotoBrowser
//
//  Created by Jecky on 14/12/29.
//  Copyright (c) 2014年 Jecky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface JKPhotoBrowserCell : UICollectionViewCell

@property (nonatomic, strong) UIImage    *image;
@property (nonatomic, strong) ALAsset    *asset;

@end
