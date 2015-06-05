//
//  JKAssetsViewCell.m
//  JKImagePicker
//
//  Created by Jecky on 15/1/12.
//  Copyright (c) 2015年 Jecky. All rights reserved.
//

#import "JKAssetsViewCell.h"
#import "JKUtil.h"
#import "UIView+JKPicker.h"

@interface JKAssetsViewCell() 

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton    *photoButton;
@property (nonatomic, strong) UIButton    *checkButton;


@end

@implementation JKAssetsViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Create a image view
        self.backgroundColor = [UIColor clearColor];
        self.autoresizesSubviews = YES;
        [self imageView];
        self.checkButton.right = self.imageView.width;
    }
    
    return self;
}

#pragma mark - setter/getter
- (void)setAsset:(ALAsset *)asset
{
    if (asset == nil) {
        _asset = asset;
        self.photoButton.hidden = NO;
        self.imageView.hidden = YES;
        return;
    }
    
    self.imageView.hidden = NO;
    self.photoButton.hidden = YES;
    if (_asset != asset) {
        _asset = asset;
        // Update view
        CGImageRef thumbnailImageRef = [asset thumbnail];
        
        if (thumbnailImageRef) {
            self.imageView.image = [UIImage imageWithCGImage:thumbnailImageRef];
            self.img = [UIImage imageWithCGImage:thumbnailImageRef];
        } else {
            self.imageView.image = [UIImage imageNamed:@"assets_placeholder_picture"];
        }
    }
    
}

- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    
    self.checkButton.selected = isSelected;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _imageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (UIButton *)checkButton{
    if (!_checkButton) {
        _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage  *img = [UIImage imageNamed:@"photo_check_default"];
        UIImage  *imgH = [UIImage imageNamed:@"photo_check_selected"];
        _checkButton.frame = CGRectMake(0, 0, img.size.width, img.size.height);
        [_checkButton setBackgroundImage:img forState:UIControlStateNormal];
        [_checkButton setBackgroundImage:imgH forState:UIControlStateSelected];
        [_checkButton addTarget:self action:@selector(photoDidChecked) forControlEvents:UIControlEventTouchUpInside];
        _checkButton.exclusiveTouch = YES;
        [self.imageView addSubview:_checkButton];
    }
    return _checkButton;
}

- (UIButton *)photoButton{
    if (!_photoButton) {
        _photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _photoButton.frame = self.contentView.bounds;
        UIImage  *bgImg = [UIImage imageNamed:@"compose_photograph_background"];
        [_photoButton setBackgroundImage:bgImg forState:UIControlStateNormal];
        [_photoButton setBackgroundImage:bgImg forState:UIControlStateNormal];

        UIImage  *img = [UIImage imageNamed:@"compose_photograph"];
        UIImage  *imgH = [UIImage imageNamed:@"compose_photograph_highlighted"];
        [_photoButton setImage:img forState:UIControlStateNormal];
        [_photoButton setImage:imgH forState:UIControlStateHighlighted];
        [_photoButton addTarget:self action:@selector(photo) forControlEvents:UIControlEventTouchUpInside];
        _photoButton.exclusiveTouch = YES;
        
        [self.contentView addSubview:_photoButton];
        
    }
    return _photoButton;
}

- (void)photo
{
    if ([_delegate respondsToSelector:@selector(startPhotoAssetsViewCell:)]) {
        [_delegate startPhotoAssetsViewCell:self];
    }
}

- (void)photoDidChecked
{
    if (self.checkButton.selected) {
        if ([_delegate respondsToSelector:@selector(didDeselectItemAssetsViewCell:)]) {
            [_delegate didDeselectItemAssetsViewCell:self];
        }
    }else{
        if ([_delegate respondsToSelector:@selector(didSelectItemAssetsViewCell:)]) {
            [_delegate didSelectItemAssetsViewCell:self];
        }
    }
}

@end
