//
//  UIImage+Extension.m
//  新浪微博
//
//  Created by xc on 15/3/5.
//  Copyright (c) 2015年 xc. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)
/**
 *  争对ios7以上的系统适配新的图片资源
 *
 *  @param imageName 图片名称
 *
 *  @return 新的图片
 */
+ (UIImage *)imageWithName:(NSString *)imageName
{
    UIImage *newImage = nil;
    if (iOS7) {
        newImage = [UIImage imageNamed:[imageName stringByAppendingString:@"_os7"]];
    }
    if (newImage == nil) {
        newImage = [UIImage imageNamed:imageName];
    }
    return newImage;
    
}
+ (UIImage *)resizableImageWithName:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    // 获取原有图片的宽高的一半
    CGFloat w = image.size.width * 0.5;
    CGFloat h = image.size.height * 0.5;
    
    // 生成可以拉伸指定位置的图片
    UIImage *newImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w) resizingMode:UIImageResizingModeStretch];
    
    return newImage;
}

/**
 *  实现图片的缩小或者放大
 *
 *  @param image 原图
 *  @param size  大小范围
 *
 *  @return 新的图片
 */

-(UIImage*) scaleImageWithSize:(CGSize)size
{
    
    UIGraphicsBeginImageContextWithOptions(size,NO,0);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}
@end
