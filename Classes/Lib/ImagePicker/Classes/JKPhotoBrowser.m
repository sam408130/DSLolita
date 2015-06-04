//
//  JKPhotoBrowser.m
//  JKPhotoBrowser
//
//  Created by Jecky on 14/12/29.
//  Copyright (c) 2014年 Jecky. All rights reserved.
//

#import "JKPhotoBrowser.h"
#import "JKPhotoBrowserCell.h"
#import "UIView+JKPicker.h"
#import "JKUtil.h"
#import "JKPromptView.h"

@interface JKPhotoBrowser() <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView   *topView;

@property (nonatomic, strong) UILabel  *numberLabel;
@property (nonatomic, strong) UIButton    *checkButton;

@end

static NSString *kJKPhotoBrowserCellIdentifier = @"kJKPhotoBrowserCellIdentifier";

@implementation JKPhotoBrowser

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [JKUtil getColor:@"282828"];
        self.autoresizesSubviews = YES;
        [self collectionView];
        [self topView];
    }
    return self;
}

- (void)closePhotoBrower
{
    [self hide:YES];
}


- (void)photoDidChecked
{
    if (!self.checkButton.selected&&self.pickerController.selectedAssetArray.count>=self.pickerController.maximumNumberOfSelection) {
        NSString  *str = [NSString stringWithFormat:@"最多选择%lu张照片",self.pickerController.maximumNumberOfSelection];
        [JKPromptView showWithImageName:@"picker_alert_sigh" message:str];
        return;
    }
    
    if (self.checkButton.selected) {
        if ([_delegate respondsToSelector:@selector(photoBrowser:didDeselectAtIndex:)]) {
            [_delegate photoBrowser:self didDeselectAtIndex:self.currentPage];
        }
    }else{
        if ([_delegate respondsToSelector:@selector(photoBrowser:didSelectAtIndex:)]) {
            [_delegate photoBrowser:self didSelectAtIndex:self.currentPage];
        }
    }
    
    self.checkButton.selected = !self.checkButton.selected;
}

- (void)show:(BOOL)animated
{
    if (animated){
        self.top = [UIScreen mainScreen].bounds.size.height;
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        [UIView animateWithDuration:0.3f
                         animations:^{
                             self.top = 0;
                         }
                         completion:^(BOOL finished) {
                         }];
        
    }else{
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
}

- (void)hide:(BOOL)animated
{
    if (animated){
        [UIView animateWithDuration:0.3f
                         animations:^{
                             self.top = [UIScreen mainScreen].bounds.size.height;
                         }
                         completion:^(BOOL finished) {
                             [self removeFromSuperview];
                         }];
    }
    else{
        [self removeFromSuperview];
    }
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.assetsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JKPhotoBrowserCell *cell = (JKPhotoBrowserCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kJKPhotoBrowserCellIdentifier forIndexPath:indexPath];
    
    cell.asset = [self.assetsArray objectAtIndex:indexPath.row];
    return cell;
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.bounds.size.width+20, self.bounds.size.height);
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    float itemWidth = CGRectGetWidth(self.collectionView.frame);
    if (offsetX >= 0){
        int page = offsetX / itemWidth;
        [self didScrollToPage:page];
    }
}

- (void)didScrollToPage:(int)page
{
    _currentPage = page;
    [self updateStatus];
}

- (BOOL)assetIsSelected:(NSURL *)assetURL
{
    for (JKAssets *asset in self.pickerController.selectedAssetArray) {
        if ([assetURL isEqual:asset.assetPropertyURL]) {
            return YES;
        }
    }
    return NO;
}


- (void)reloadPhotoeData
{
    [self.collectionView setContentOffset:CGPointMake(_currentPage*CGRectGetWidth(self.collectionView.frame), 0) animated:NO];
    [self updateStatus];
    [self.collectionView reloadData];
}


- (void)updateStatus
{
    self.numberLabel.text = [NSString stringWithFormat:@"%lu/%lu",(long)(_currentPage+1),(unsigned long)[self.assetsArray count]];
    self.numberLabel.text = [NSString stringWithFormat:@"%lu/%lu",(long)(_currentPage+1),(unsigned long)[self.assetsArray count]];
    
    ALAsset  *asset = [self.assetsArray objectAtIndex:_currentPage];
    NSURL *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
    self.checkButton.selected = [self assetIsSelected:assetURL];
}

#pragma mark - setter
- (void)setAssetsArray:(NSMutableArray *)assetsArray{
    if (_assetsArray != assetsArray) {
        _assetsArray = assetsArray;
        
        [self reloadPhotoeData];
    }
}

#pragma mark - getter
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0.0;
        layout.minimumInteritemSpacing = 0.0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-10, 0, self.bounds.size.width+20, self.bounds.size.height) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[JKPhotoBrowserCell class] forCellWithReuseIdentifier:kJKPhotoBrowserCellIdentifier];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [self addSubview:_collectionView];
        
    }
    return _collectionView;
}

- (UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(floor((CGRectGetWidth(self.frame)-100)/2), 32, 100, 20)];
        _numberLabel.backgroundColor = [UIColor clearColor];
        _numberLabel.textColor = [UIColor whiteColor];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.font = [UIFont systemFontOfSize:17.0f];
        _numberLabel.text = @"0/0";
    }
    return _numberLabel;
}

- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 64)];
        _topView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        [_topView addSubview:self.numberLabel];
        
        UIImage  *img = [UIImage imageNamed:@"camera_edit_cut_cancel"];
        UIImage  *imgHigh = [UIImage imageNamed:@"camera_edit_cut_cancel_highlighted"];
        UIButton  *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10, 20+floor((44-img.size.height)/2), img.size.width, img.size.height);
        [button setBackgroundImage:img forState:UIControlStateNormal];
        [button setBackgroundImage:imgHigh forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(closePhotoBrower) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:button];
        
        _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage  *img1 = [UIImage imageNamed:@"photo_check_default"];
        UIImage  *imgH = [UIImage imageNamed:@"photo_check_selected"];
        _checkButton.frame = CGRectMake(0, 0, img1.size.width, img1.size.height);
        [_checkButton setBackgroundImage:img1 forState:UIControlStateNormal];
        [_checkButton setBackgroundImage:imgH forState:UIControlStateSelected];
        [_checkButton addTarget:self action:@selector(photoDidChecked) forControlEvents:UIControlEventTouchUpInside];
        _checkButton.exclusiveTouch = YES;
        _checkButton.right = self.width-10;
        _checkButton.centerY = button.centerY;
        [_topView addSubview:_checkButton];
        
        [self addSubview:_topView];
    }
    return _topView;
}

@end
