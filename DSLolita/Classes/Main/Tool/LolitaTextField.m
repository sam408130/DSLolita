//
//  LolitaTextField.m
//  Lolita
//
//  Created by 赛 丁 on 15/5/18.
//  Copyright (c) 2015年 赛 丁. All rights reserved.
//

#import "LolitaTextField.h"

@implementation LolitaTextField
-(void)drawRect:(CGRect)rect {
    [self setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
    [self setTintColor:[UIColor lightGrayColor]];
    [self setBorderStyle:UITextBorderStyleNone];
    [self setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self setTextColor:[UIColor colorWithWhite:130/255.0f alpha:1.0f]];
    
    UIImage *imageBack = [UIImage imageNamed:@"txtFieldBack"];
    [self setBackground:imageBack];
    
    UIColor *color = [UIColor colorWithWhite:210/255.0f alpha:1.0f];
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: color}];
    
    [self setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
}


@end
