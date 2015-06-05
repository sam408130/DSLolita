//
//  UIImage+Icon.m
//  DSLolita
//
//  Created by 赛 丁 on 15/6/5.
//  Copyright (c) 2015年 samDing. All rights reserved.
//


#import "UIImage+Icon.h"

@implementation UIImage(Icon)


+(UIColor*)colorWithString:(NSString*)string{
    NSInteger length=string.length;
    NSInteger partLength=length/3;
    NSString *part1,*part2,*part3;
    part1=[string substringWithRange:NSMakeRange(0, partLength)];
    part2=[string substringWithRange:NSMakeRange(partLength, partLength)];
    part3=[string substringWithRange:NSMakeRange(partLength*2, partLength)];
    CGFloat hue=[self hashNumberFromString:part3]%256/256.0;
    CGFloat saturation=[self hashNumberFromString:part2]%128/256.0+0.5;
    CGFloat brightness=[self hashNumberFromString:part1]%128/256.0+0.5;
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}


+(NSUInteger)hashNumberFromString:(NSString*)string{
    NSInteger hash=string.hash;
    if(hash<0){
        return -hash;
    }else{
        return hash;
    }
}

+(UIImage*)imageWithHashString:(NSString*)hashString displayString:(NSString*)displayString{
    return [self imageWithColor:[self colorWithString:hashString] string:displayString];
}

+(UIImage*)imageWithColor:(UIColor *)color string:(NSString*)string{
    CGSize size=CGSizeMake(50, 50);
    CGFloat radius=4;
    CGRect rect=CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [[UIBezierPath bezierPathWithRoundedRect:rect
                                cornerRadius:radius] addClip];
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIFont *font=[UIFont systemFontOfSize:30];
    CGFloat fontHeight=font.pointSize;
    CGFloat yOffset=(rect.size.height-fontHeight)/2.0-3;
    CGRect textRect=CGRectMake(0, yOffset, rect.size.width, rect.size.height-yOffset);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [string drawInRect:textRect withAttributes: @{NSFontAttributeName: font,                                                           NSParagraphStyleAttributeName: paragraphStyle, NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
