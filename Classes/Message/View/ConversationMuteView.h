//
//  ConversationMuteView.h
//  FreeChat
//
//  Created by Feng Junwen on 2/11/15.
//  Copyright (c) 2015 Feng Junwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConversationStore.h"

@interface ConversationMuteView : UITableViewCell

@property (nonatomic, weak) id<ConversationOperationDelegate> delegate;

@property (nonatomic, strong) UISwitch *switchView;

+ (CGFloat)cellHeight;

@end
