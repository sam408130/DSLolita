//
//  JKAssetsGroupsView.m
//  JKImagePicker
//
//  Created by Jecky on 15/1/11.
//  Copyright (c) 2015年 Jecky. All rights reserved.
//

#import "JKAssetsGroupsView.h"
#import "JKAssetsGroupCell.h"
#import "UIView+JKPicker.h"

@interface JKAssetsGroupsView()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView  *tableView;
@property (nonatomic, strong) NSIndexPath  *selectedIndexPath;
@property (nonatomic, strong) UIButton     *touchButton;

@end

static CGFloat kHeightAssetsGroupCell = 86.0;

@implementation JKAssetsGroupsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        [self tableView];
        
    }
    return self;
}

- (void)cancelAssetsGroupSelect
{
    if ([_delegate respondsToSelector:@selector(assetsGroupsViewDidCancel:)]) {
        [_delegate assetsGroupsViewDidCancel:self];
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.assetsGroups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *AssetsGroupCell = @"AssetsGroupCell";
    JKAssetsGroupCell *cell = (JKAssetsGroupCell *)[tableView dequeueReusableCellWithIdentifier:AssetsGroupCell];
    if (cell == nil) {
        cell = [[JKAssetsGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AssetsGroupCell];
    }
    
    ALAssetsGroup *assetsGroup = self.assetsGroups[indexPath.row];
    cell.assetsGroup = assetsGroup;
    cell.isSelected = [self selectAssetsGroup:assetsGroup];
    if (_selectedIndexPath.row == indexPath.row) {
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    } else {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHeightAssetsGroupCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _selectedIndexPath = indexPath;
    
    [self.tableView reloadData];

    ALAssetsGroup *assetsGroup = self.assetsGroups[indexPath.row];
    if ([_delegate respondsToSelector:@selector(assetsGroupsView:didSelectAssetsGroup:)]) {
        [_delegate assetsGroupsView:self didSelectAssetsGroup:assetsGroup];
    }
    
}

- (BOOL)selectAssetsGroup:(ALAssetsGroup *)assetsGroup
{
    NSString *groupID = [assetsGroup valueForProperty:ALAssetsGroupPropertyPersistentID];
    NSInteger count = [[self.selectedAssetCount objectForKey:groupID] integerValue];
    return count>0;
}

- (void)removeAssetSelected:(JKAssets *)asset
{
    NSInteger count = [[self.selectedAssetCount objectForKey:asset.groupPropertyID] integerValue];
    if (count<=1) {
        [self.selectedAssetCount removeObjectForKey:asset.groupPropertyID];
    }else{
        [self.selectedAssetCount setObject:[NSNumber numberWithInteger:count-1]
                                    forKey:asset.groupPropertyID];
    }
    
    [self.tableView reloadData];
}

- (void)addAssetSelected:(JKAssets *)asset
{
    NSInteger count = [[self.selectedAssetCount objectForKey:asset.groupPropertyID] integerValue];
    [self.selectedAssetCount setObject:[NSNumber numberWithInteger:count+1]
                                forKey:asset.groupPropertyID];
    
    [self.tableView reloadData];

}

#pragma mark - setter
- (void)setSelectedAssetCount:(NSMutableDictionary *)selectedAssetCount{
    if (_selectedAssetCount != selectedAssetCount) {
        _selectedAssetCount = selectedAssetCount;
        
        [self.tableView reloadData];
    }
}

- (void)setAssetsGroups:(NSArray *)assetsGroups{
    if (_assetsGroups != assetsGroups) {
        _assetsGroups = assetsGroups;
        
        NSInteger  rowCount = 0;
        if ([_assetsGroups count]>4) {
            rowCount = 4;
        }else{
            rowCount = [_assetsGroups count];
        }
        
        _selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        self.tableView.height = rowCount*kHeightAssetsGroupCell;
        self.touchButton.top = self.tableView.bottom;
        self.touchButton.height = self.height - self.tableView.bottom;
        [self.tableView reloadData];
    }
}

#pragma mark - getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, 4*kHeightAssetsGroupCell) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;        
        [self addSubview:_tableView];
    }
    return _tableView;
}

- (UIButton *)touchButton{
    if (!_touchButton) {
        _touchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _touchButton.frame = CGRectMake(0, self.tableView.bottom, self.width, self.height-self.tableView.bottom);
        [_touchButton addTarget:self action:@selector(cancelAssetsGroupSelect) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_touchButton];
    }
    return _touchButton;
}

@end
