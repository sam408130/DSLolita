//
//  ConversationMuteView.m
//  FreeChat
//
//  Created by Feng Junwen on 2/11/15.
//  Copyright (c) 2015 Feng Junwen. All rights reserved.
//

#import "ConversationMuteView.h"

@implementation ConversationMuteView

@synthesize  switchView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *receiveNotifyLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 150, 20)];
        [receiveNotifyLabel setFont:[UIFont systemFontOfSize:18.0]];
        [receiveNotifyLabel setText:@"不接收通知消息"];
        [self.contentView addSubview:receiveNotifyLabel];
        
        self.switchView = [[UISwitch alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width - 70, 10, 60, 30)];
        [self.contentView addSubview:self.switchView];
        [self.switchView addTarget:self action:@selector(switchChanged:forEvent:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

+ (CGFloat)cellHeight {
    return 50.0f;
}

- (void) switchChanged:(id)sender forEvent:(UIEvent *)event {
    UISwitch *swv = (UISwitch *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(mute:conversation:)]) {
        [self.delegate mute:swv.isOn conversation:nil];
    }
}

@end
