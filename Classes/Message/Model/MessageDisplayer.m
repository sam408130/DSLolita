//
//  MessageDisplayer.m
//  FreeChat
//
//  Created by Feng Junwen on 2/10/15.
//  Copyright (c) 2015 Feng Junwen. All rights reserved.
//

#import "MessageDisplayer.h"
#import <UIKit/UIKit.h>

@implementation MessageDisplayer

+ (void)displayError:(NSError*)error {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Failed" message:[NSString stringWithFormat:@"code: %ld, detail: %@", (long)[error code], [error description]] delegate:nil cancelButtonTitle:@"造了" otherButtonTitles:nil, nil];
    [alertView show];
}

@end
