//
//  FCMessageFrame.m
//  FreeChat
//
//  Created by Feng Junwen on 3/3/15.
//  Copyright (c) 2015 Feng Junwen. All rights reserved.
//

#import "FCMessageFrame.h"
#import "NSDate+Utils.h"

@implementation FCMessageFrame

-(id)init {
    self = [super init];
    if (self) {
        self.showTime = TRUE;
    }
    return self;
}

- (void)setMessage:(Message *)message{
    
    _message = message;
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    if (!_message.imMessage) {
        NSString *notificationText = [Message getNotificationContent:_message];
        CGFloat timeY = ChatMargin;
        CGSize timeSize = [notificationText sizeWithFont:ChatTimeFont constrainedToSize:CGSizeMake(300, 100) lineBreakMode:NSLineBreakByWordWrapping];
        CGFloat timeX = (screenW - timeSize.width) / 2;
        _timeF = CGRectMake(timeX, timeY, timeSize.width + ChatTimeMarginW, timeSize.height + ChatTimeMarginH);
        _cellHeight = timeY + timeSize.height + ChatTimeMarginH;
        _iconF = CGRectMake(0, 0, 0, 0);
        _nameF = CGRectMake(0, 0, 0, 0);
        _contentF = CGRectMake(0, 0, 0, 0);
        return;
    }

    // 1、计算时间的位置
    NSString *sendTime = [[NSDate dateWithTimeIntervalSinceReferenceDate:_message.sentTimestamp/1000] string];
    if (_showTime){
        CGFloat timeY = ChatMargin;
        CGSize timeSize = [sendTime sizeWithFont:ChatTimeFont constrainedToSize:CGSizeMake(300, 100) lineBreakMode:NSLineBreakByWordWrapping];
        
        CGFloat timeX = (screenW - timeSize.width) / 2;
        _timeF = CGRectMake(timeX, timeY, timeSize.width + ChatTimeMarginW, timeSize.height + ChatTimeMarginH);
    }
    
    // 2、计算头像位置
    CGFloat iconX = ChatMargin;
    if (_message.imMessage.ioType == AVIMMessageIOTypeOut) {
        iconX = screenW - ChatMargin - ChatIconWH;
    }
    CGFloat iconY = CGRectGetMaxY(_timeF) + ChatMargin;
    _iconF = CGRectMake(iconX, iconY, ChatIconWH, ChatIconWH);
    
    // 3、计算ID位置
    _nameF = CGRectMake(iconX, iconY+ChatIconWH, ChatIconWH, 20);
    
    // 4、计算内容位置
    CGFloat contentX = CGRectGetMaxX(_iconF)+ChatMargin;
    CGFloat contentY = iconY;
    
    //根据种类分
    CGSize contentSize;
    if (![_message.imMessage isKindOfClass:[AVIMTypedMessage class]]) {
        contentSize = [_message.imMessage.content sizeWithFont:ChatContentFont  constrainedToSize:CGSizeMake(ChatContentW, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    } else {
        AVIMTypedMessage *typedMessage = (AVIMTypedMessage *)_message.imMessage;
        switch (typedMessage.mediaType) {
            case kAVIMMessageMediaTypeText:
                contentSize = [((AVIMTextMessage *)typedMessage).text sizeWithFont:ChatContentFont  constrainedToSize:CGSizeMake(ChatContentW, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
                break;
            case kAVIMMessageMediaTypeImage:
                contentSize = CGSizeMake(ChatPicWH, ChatPicWH);
                break;
            case kAVIMMessageMediaTypeAudio:
                contentSize = CGSizeMake(120, 20);
                break;
            default:
                break;
        }
    }
    if (_message.imMessage.ioType == AVIMMessageIOTypeOut) {
        contentX = iconX - contentSize.width - ChatContentLeft - ChatContentRight - ChatMargin;
    }
    _contentF = CGRectMake(contentX, contentY, contentSize.width + ChatContentLeft + ChatContentRight, contentSize.height + ChatContentTop + ChatContentBottom);
    
    _cellHeight = MAX(CGRectGetMaxY(_contentF), CGRectGetMaxY(_nameF))  + ChatMargin;
}

@end
