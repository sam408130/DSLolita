//
//  JKAssetsGroupCell.h
//  JKImagePicker
//
//  Created by Jecky on 15/1/11.
//  Copyright (c) 2015年 Jecky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface JKAssetsGroupCell : UITableViewCell

@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@property (nonatomic, assign) BOOL   isSelected;

@end
