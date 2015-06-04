//
//  UIBarButtonItem+Extension.h
//  新浪微博
//
//  Created by xc on 15/3/6.
//  Copyright (c) 2015年 xc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

+ (instancetype)BarButtonItemWithTitle:(NSString *) title style:(UIBarButtonItemStyle) style target:(id)target action:(SEL) action;

+ (instancetype)BarButtonItemWithBackgroudImageName:(NSString *)backgroudImage highBackgroudImageName:(NSString *)highBackgroudImageName target:(id)target action:(SEL)action;
+ (instancetype)BarButtonItemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName title:(NSString *)title target:(id)target action:(SEL)action;
@end
