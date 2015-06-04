//
//  Constrains.h
//  FreeChat
//
//  Created by Feng Junwen on 2/11/15.
//  Copyright (c) 2015 Feng Junwen. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const int kConversationType_OneOne;
extern const int kConversationType_Group;

extern const int kConversationVisibility_Private;
extern const int kConversationVisibility_Public;

extern NSString *kAVUserClassName;

typedef void (^CommonResultBlock)(BOOL successed);
typedef void (^ArrayResultBlock)(NSArray *objects, NSError *error);

@interface Constrains : NSObject

@end
