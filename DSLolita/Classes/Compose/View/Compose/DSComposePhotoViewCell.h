//
//  DSComposePhotoViewCell.h
//  DSLolita
//
//  Created by 赛 丁 on 15/6/1.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKAssets.h"



@interface DSComposePhotoViewCell : UICollectionViewCell

@property (nonatomic , strong) JKAssets *asset;
@property (nonatomic , weak) UIButton *deletePhotoButton;
@property (nonatomic , strong) NSIndexPath *indexpath;
@property (nonatomic , strong) UIImageView *imageView;
@end
