//
//  ImageUtil.m
//  HOIH
//
//  Created by 钟路成 on 16/5/31.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import "ImageUtil.h"

@implementation ImageUtil
+ (UIImage*)roundedImage:(UIImage*)image toWidth:(NSInteger)width height:(NSInteger)height{
    // Create a graphics context with the target size
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
    // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
    CGSize size = CGSizeMake(width, height);
    CGRect rect = CGRectMake(0.0, 0.0, width, height);
    
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Flip the context because UIKit coordinate system is upside down to Quartz coordinate system
    CGContextTranslateCTM(context, 0.0, height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGPathRef path = CGPathCreateWithEllipseInRect(CGRectMake(0.0, 0.0, width, height), NULL);
    CGContextAddPath(context, path);
    CGContextClip(context);
    
    // Draw the original image to the context
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGContextDrawImage(context, rect, image.CGImage);
    
    CGContextSetRGBStrokeColor(context, 1, 1, 1, 1);
    
    CGFloat boundWidth = 2 * width/30;
    
    CGContextSetLineWidth(context, boundWidth);
    CGContextStrokeEllipseInRect(context, rect);
    
    // Retrieve the UIImage from the current context
    UIImage *imageOut = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return imageOut;
}
+ (UIImage*)roundedImage:(UIImage*)image{
    return [self roundedImage:image toWidth:image.size.width height:image.size.height];
}
@end
