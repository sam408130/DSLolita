//
//  UIImage+Extension.h
//  新浪微博
//
//  Created by xc on 15/3/5.
//  Copyright (c) 2015年 xc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
+ (UIImage *) imageWithName:(NSString *) imageName;
+ (UIImage *) resizableImageWithName:(NSString *)imageName;
- (UIImage*) scaleImageWithSize:(CGSize)size;

@end
