//
//  ConversationMemberGroupView.h
//  FreeChat
//
//  Created by Feng Junwen on 2/11/15.
//  Copyright (c) 2015 Feng Junwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConversationMemberGroupView : UITableViewCell

+ (CGFloat)cellHeight;

- (NSArray*)avatarArray;
- (NSArray*)usernameArray;

@end
