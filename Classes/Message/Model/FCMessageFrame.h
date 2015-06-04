//
//  FCMessageFrame.h
//  FreeChat
//
//  Created by Feng Junwen on 3/3/15.
//  Copyright (c) 2015 Feng Junwen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>
#import "UUMessageFrame.h"
#import "Message.h"

@interface FCMessageFrame : NSObject

@property (nonatomic, assign, readonly) CGRect nameF;
@property (nonatomic, assign, readonly) CGRect iconF;
@property (nonatomic, assign, readonly) CGRect timeF;
@property (nonatomic, assign, readonly) CGRect contentF;

@property (nonatomic, assign, readonly) CGFloat cellHeight;
@property (nonatomic, strong) Message *message;
@property (nonatomic, assign) BOOL showTime;

- (void)setMessage:(Message *)message;

@end
