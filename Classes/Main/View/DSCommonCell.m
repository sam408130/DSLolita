//
//  DSCommonCell.m
//  DSLolita
//
//  Created by 赛 丁 on 15/5/25.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSCommonCell.h"
#import "DSCommonItem.h"
#import "DSCommonSwitchItem.h"
#import "DSCommonLabelItem.h"
#import "DSCommonArrowItem.h"
#import "DSBadgeView.h"



@interface DSCommonCell()

@property(strong , nonatomic) UIImageView *rightArrow;

@property(strong , nonatomic) UISwitch *rightSwitch;

@property(strong , nonatomic) UILabel *rightLabel;

@property(strong , nonatomic) DSBadgeView *bageView;

@end


@implementation DSCommonCell


- (UIImageView *)rightArrow{
    
    if (_rightArrow == nil){
        self.rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_icon_arrow"]];
    }
    
    return _rightArrow;
    
}

- (UISwitch *)rightSwitch {
    
    if (_rightSwitch == nil){
        self.rightSwitch = [[UISwitch alloc] init];
    }
    return _rightSwitch;
}


- (UILabel *)rightLabel {
    
    if (_rightLabel == nil) {
        self.rightLabel = [[UILabel alloc] init];
        self.rightLabel.textColor = [UIColor lightGrayColor];
        self.rightLabel.font = [UIFont systemFontOfSize:13];
    }
    return _rightLabel;
}



- (DSBadgeView *)bageView {
    if (_bageView == nil) {
        self.bageView = [[DSBadgeView alloc] init];
    }
    return _bageView;
}


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"common";
    DSCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil){
        cell = [[DSCommonCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.detailTextLabel.font = [UIFont systemFontOfSize:11];
        
        self.backgroundColor = [UIColor clearColor];
        
        self.backgroundView = [[UIImageView alloc] init];
        self.selectedBackgroundView = [[UIImageView alloc] init];
        
    }
    
    return self;
}

#pragma mark - 调整子控件位置
- (void)layoutSubviews {
    [super layoutSubviews];
    
    //调整子标题的x
    self.detailTextLabel.x = CGRectGetMaxX(self.textLabel.frame) + 5;
    
}

#pragma mark - setter

- (void)setIndexPath:(NSIndexPath *)indexPath rowsInSection:(int)rows {
    
    UIImageView *bgView = (UIImageView *)self.backgroundView;
    UIImageView *selectedBgView = (UIImageView *)self.selectedBackgroundView;
    
    if (rows == 1) {
        bgView.image = [UIImage resizableImageWithName:@"common_card_background"];
        selectedBgView.image = [UIImage resizableImageWithName:@"common_card_top_background_highlighted"];
    } else if (indexPath.row == 0) { // 首行
        bgView.image = [UIImage resizableImageWithName:@"common_card_top_background"];
        selectedBgView.image = [UIImage resizableImageWithName:@"common_card_top_background_highlighted"];
    } else if (indexPath.row == rows - 1) { // 末行
        bgView.image = [UIImage resizableImageWithName:@"common_card_bottom_background"];
        selectedBgView.image = [UIImage resizableImageWithName:@"common_card_bottom_background_highlighted"];
    } else { // 中间
        bgView.image = [UIImage resizableImageWithName:@"common_card_middle_background"];
        selectedBgView.image = [UIImage resizableImageWithName:@"common_card_middle_background_highlighted"];
    }
    
}

- (void)setItem:(DSCommonItem *)item {
    
    _item = item;
    
    // 1.设置基本数据
    self.imageView.image = [UIImage imageWithName:item.icon];
    self.textLabel.text = item.title;
    self.detailTextLabel.text = item.subtitle;
    
    // 2.设置右边的内容
    if (item.badgeValue) { // 紧急情况：右边有提醒数字
        self.bageView.badgeValue = item.badgeValue;
        self.accessoryView = self.bageView;
    } else if ([item isKindOfClass:[DSCommonArrowItem class]]) {
        self.accessoryView = self.rightArrow;
    } else if ([item isKindOfClass:[DSCommonSwitchItem class]]) {
        self.accessoryView = self.rightSwitch;
    } else if ([item isKindOfClass:[DSCommonLabelItem class]]) {
        DSCommonLabelItem *labelItem = (DSCommonLabelItem *)item;
        // 设置文字
        self.rightLabel.text = labelItem.text;
        // 根据文字计算尺寸
        self.rightLabel.size = [labelItem.text sizeWithFont:self.rightLabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        self.accessoryView = self.rightLabel;
    } else { // 取消右边的内容
        self.accessoryView = nil;
    }

}



@end
