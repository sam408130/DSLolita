//
//  JKAssetsThumbnailView.m
//  JKImagePicker
//
//  Created by Jecky on 15/1/11.
//  Copyright (c) 2015年 Jecky. All rights reserved.
//

#import "JKAssetsThumbnailView.h"
#import "JKUtil.h"

@interface JKAssetsThumbnailView ()

@property (nonatomic, strong) NSArray *thumbnailImages;
@property (nonatomic, strong) UIImage *blankImage;

@end

@implementation JKAssetsThumbnailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(70.0, 74.0);
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    
    
    if (self.thumbnailImages.count == 3) {
        UIImage *thumbnailImage = self.thumbnailImages[2];
        
        CGRect thumbnailImageRect = CGRectMake(4.0, 0, 62.0, 62.0);
        CGContextFillRect(context, thumbnailImageRect);
        [thumbnailImage drawInRect:CGRectInset(thumbnailImageRect, 0.5, 0.5)];
    }
    if (self.thumbnailImages.count >= 2) {
        UIImage *thumbnailImage = self.thumbnailImages[1];
        
        CGRect thumbnailImageRect = CGRectMake(2.0, 2.0, 66.0, 66.0);
        CGContextFillRect(context, thumbnailImageRect);
        [thumbnailImage drawInRect:CGRectInset(thumbnailImageRect, 0.5, 0.5)];
    }
    if (self.thumbnailImages.count >= 1) {
        UIImage *thumbnailImage = self.thumbnailImages[0];
        
        CGRect thumbnailImageRect = CGRectMake(0, 4.0, 70.0, 70.0);
        CGContextFillRect(context, thumbnailImageRect);
        [thumbnailImage drawInRect:CGRectInset(thumbnailImageRect, 0.5, 0.5)];
    }
}


#pragma mark - setter/getter
- (void)setAssetsGroup:(ALAssetsGroup *)assetsGroup
{
    if (_assetsGroup != assetsGroup) {
        _assetsGroup = assetsGroup;
        
        // Extract three thumbnail images
        NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, MIN(3, assetsGroup.numberOfAssets))];
        NSMutableArray *thumbnailImages = [NSMutableArray array];
        [assetsGroup enumerateAssetsAtIndexes:indexes
                                      options:0
                                   usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                       if (result) {
                                           CGImageRef thumbnailImageRef = [result thumbnail];
                                           if (thumbnailImageRef) {
                                               [thumbnailImages addObject:[UIImage imageWithCGImage:thumbnailImageRef]];
                                           } else {
                                               [thumbnailImages addObject:[self blankImage]];
                                           }
                                       }
                                   }];
        
        if ([thumbnailImages count]>0) {
            self.thumbnailImages = thumbnailImages;
        }else{
            [thumbnailImages addObject:self.blankImage];
            [thumbnailImages addObject:self.blankImage];
            [thumbnailImages addObject:self.blankImage];
            self.thumbnailImages = thumbnailImages;
        }
        [self setNeedsDisplay];
    }
}

- (UIImage *)blankImage
{
    if (_blankImage == nil) {
        _blankImage = [UIImage imageNamed:@"assets_placeholder_picture"];
    }
    return _blankImage;
}


@end
