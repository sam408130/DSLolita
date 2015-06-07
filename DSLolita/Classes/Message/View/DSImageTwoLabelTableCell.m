//
//  DSImageTwoLabelTableCell.m
//  DSLolita
//
//  Created by 赛 丁 on 15/6/5.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSImageTwoLabelTableCell.h"


@implementation DSImageTwoLabelTableCell

-(instancetype)init{
    self=[self init];
    if(self){
//        self.image = [UIImage resizableImageWithName:@"timeline_card_top_background"];
//        self.highlighted = [UIImage resizableImageWithName:@"timeline_card_top_background_highlighted"];
    }
    return self;
}



-(void)layoutSubviews{
    [super layoutSubviews];
    if (_unreadCount > 0) {
        [self.unreadBadge setHidden:NO];
        self.unreadBadge.badgeText=[NSString stringWithFormat:@"%ld",(long)_unreadCount];
    }else{
        [self.unreadBadge setHidden:YES];
    }
}

-(JSBadgeView*)unreadBadge{
    if(_unreadBadge==nil){
        _unreadBadge=[[JSBadgeView alloc] initWithParentView:_myImageView alignment:JSBadgeViewAlignmentTopRight];
    }
    return _unreadBadge;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end