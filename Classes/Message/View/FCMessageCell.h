//
//  FCMessageCellTableViewCell.h
//  FreeChat
//
//  Created by Feng Junwen on 3/3/15.
//  Copyright (c) 2015 Feng Junwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUMessageCell.h"
#import "FCMessageFrame.h"

@class FCMessageCell;

@protocol FCMessageCellDelegate <NSObject>
@optional
- (void)headImageDidClick:(FCMessageCell *)cell userId:(NSString *)userId;
- (void)cellContentDidClick:(FCMessageCell *)cell image:(UIImage *)contentImage;
@end

@interface FCMessageCell : UITableViewCell

@property (nonatomic, retain)UILabel *labelTime;
@property (nonatomic, retain)UILabel *labelNum;
@property (nonatomic, retain)UIButton *btnHeadImage;

@property (nonatomic, retain)UUMessageContentButton *btnContent;

@property (nonatomic, retain)FCMessageFrame *messageFrame;

@property (nonatomic, assign)id<FCMessageCellDelegate>delegate;

@end
