//
//  JKPhotoBrowserCell.m
//  JKPhotoBrowser
//
//  Created by Jecky on 14/12/29.
//  Copyright (c) 2014年 Jecky. All rights reserved.
//

#import "JKPhotoBrowserCell.h"
#import "UIView+JKPicker.h"

@interface JKPhotoBrowserCell() <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UIImageView   *imageView;

@end

@implementation JKPhotoBrowserCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Create a image view
        self.backgroundColor = [UIColor clearColor];
        
        [self scrollView];
        [self imageView];
        
        self.autoresizesSubviews = YES;
    }
    
    return self;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    
    [self.scrollView setZoomScale:1.0];
    
}

#pragma mark- setter
- (void)setAsset:(ALAsset *)asset{
    if (_asset != asset) {
        _asset = asset;
        
        self.image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
    }
}

- (void)setImage:(UIImage *)image{
    if (image != _image) {
        _image = image;
        
        CGSize maxSize = self.scrollView.size;
        CGFloat widthRatio = maxSize.width/image.size.width;
        CGFloat heightRatio = maxSize.height/image.size.height;
        CGFloat initialZoom = (widthRatio > heightRatio) ? heightRatio : widthRatio;
        
        if (initialZoom > 1) {
            initialZoom = 1;
        }
        
        CGRect r = self.scrollView.frame;
        r.size.width = image.size.width * initialZoom;
        r.size.height = image.size.height * initialZoom;
        self.imageView.frame = r;
        self.imageView.center = CGPointMake(self.scrollView.width/2, self.scrollView.height/2);
        self.imageView.image = image;
        
        [self.scrollView setMinimumZoomScale:initialZoom];
        [self.scrollView setMaximumZoomScale:5];
        [self.scrollView setZoomScale:1.0];
    }
}

#pragma mark- scroll
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                        scrollView.contentSize.height * 0.5 + offsetY);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

#pragma mark- getter
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width-20, self.frame.size.height)];
        _scrollView.delegate = self;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleWidth;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleWidth;
        [self.scrollView addSubview:_imageView];
    }
    
    return _imageView;
}

@end
