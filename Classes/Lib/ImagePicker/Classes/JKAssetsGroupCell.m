//
//  JKAssetsGroupCell.m
//  JKImagePicker
//
//  Created by Jecky on 15/1/11.
//  Copyright (c) 2015年 Jecky. All rights reserved.
//

#import "JKAssetsGroupCell.h"
#import "JKUtil.h"
#import "UIView+JKPicker.h"
#import "JKAssetsThumbnailView.h"

@interface JKAssetsGroupCell()

@property (nonatomic, strong) JKAssetsThumbnailView *thumbnailView;
@property (nonatomic, strong) UILabel     *assetsNameLabel;
@property (nonatomic, strong) UILabel     *assetsCountLabel;
@property (nonatomic, strong) UIImageView   *checkImageView;

@end

@implementation JKAssetsGroupCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Cell settings
        self.accessoryType = UITableViewCellAccessoryNone;
        [self thumbnailView];
    }
    
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//common_image_loading
#pragma makr - setter
- (void)setAssetsGroup:(ALAssetsGroup *)assetsGroup{
    if (_assetsGroup != assetsGroup) {
        _assetsGroup = assetsGroup;
        
        // Update thumbnail view
        self.thumbnailView.assetsGroup = _assetsGroup;
        
        // Update label
        self.assetsNameLabel.text = [_assetsGroup valueForProperty:ALAssetsGroupPropertyName];
        [self.assetsNameLabel sizeToFit];
        self.assetsNameLabel.left = self.thumbnailView.right + 18;
        self.assetsNameLabel.bottom = self.thumbnailView.centerY-2;
        
        self.assetsCountLabel.text = [NSString stringWithFormat:@"%ld", (long)[_assetsGroup numberOfAssets]];
        [self.assetsCountLabel sizeToFit];
        self.assetsCountLabel.left = self.assetsNameLabel.left;
        self.assetsCountLabel.top = self.assetsNameLabel.bottom+4;

    }
}

- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    
    self.checkImageView.hidden = !isSelected;
}

#pragma makr - getter
- (JKAssetsThumbnailView *)thumbnailView{
    if (!_thumbnailView) {
        _thumbnailView = [[JKAssetsThumbnailView alloc] initWithFrame:CGRectMake(8, 4, 70, 74)];
        _thumbnailView.backgroundColor = [UIColor clearColor];
        _thumbnailView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self.contentView addSubview:_thumbnailView];
    }
    return _thumbnailView;
}

- (UIImageView *)checkImageView{
    if (!_checkImageView) {
        _checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"picker_photo_filter_checked"]];
        _checkImageView.backgroundColor = [UIColor clearColor];
        _checkImageView.right = self.thumbnailView.width-3;
        _checkImageView.bottom = self.thumbnailView.height-3;
        [self.thumbnailView addSubview:_checkImageView];
    }
    return _checkImageView;
}

- (UILabel *)assetsNameLabel{
    if (!_assetsNameLabel) {
        _assetsNameLabel = [[UILabel alloc] init];
        _assetsNameLabel.backgroundColor = [UIColor clearColor];
        _assetsNameLabel.textColor = [UIColor blackColor];
        _assetsNameLabel.font = [UIFont systemFontOfSize:17.0f];
        [self.contentView addSubview:_assetsNameLabel];
    }
    return _assetsNameLabel;
}

- (UILabel *)assetsCountLabel{
    if (!_assetsCountLabel) {
        _assetsCountLabel = [[UILabel alloc] init];
        _assetsCountLabel.backgroundColor = [UIColor clearColor];
        _assetsCountLabel.textColor = [UIColor blackColor];
        _assetsCountLabel.font = [UIFont systemFontOfSize:12.0f];
        [self.contentView addSubview:_assetsCountLabel];
    }
    return _assetsCountLabel;
}
@end
