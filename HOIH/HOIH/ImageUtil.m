//
//  ImageUtil.m
//  HOIH
//
//  Created by 钟路成 on 16/5/31.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import "ImageUtil.h"

@implementation ImageUtil
static NSMutableDictionary* imageList;
static CGFloat savedImageSize = 30;
+ (UIImage*)roundedImage:(UIImage*)image toWidth:(NSInteger)width height:(NSInteger)height{
    // Create a graphics context with the target size
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
    // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
    CGSize size = CGSizeMake(width, height);
    CGRect rect = CGRectMake(0.0, 0.0, width, height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);

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

+ (UIImage*)resizeImage:(NSString*)name{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageList = [NSMutableDictionary new];
        CGFloat photoWidth = savedImageSize;
        NSArray *imgs = @[@"photo_0",@"photo_1",@"photo_2",@"photo_3",@"photo_4"];
        for(NSString *imgName in imgs){
            imageList[imgName] = [self roundedImage:[UIImage imageNamed:imgName] toWidth:photoWidth height:photoWidth];
            //imageList[imgName] =[UIImage imageNamed:imgName];
        }
    });
    return imageList[[NSString stringWithFormat:@"photo_%@",name]];
}

+ (UIImage*)roundedImageNamed:(NSString*)image toWidth:(NSInteger)width height:(NSInteger)height{
    NSString *imgName = [NSString stringWithFormat:@"photo_%@",image];
    return [self roundedImage:[UIImage imageNamed:imgName] toWidth:width height:height];
}

+ (UIImage*)typeImage:(NSString*)type{
    if(!type){
        type = @"其他";
    }
    NSString *imgName;
    NSDictionary *typeNames = @{@"桌游":@"desk_game",
                                @"聚餐":@"eat",
                                @"开黑":@"vedio_game",
                                @"KTV":@"ktv",
                                @"旅游":@"travel",
                                @"Party":@"party",
                                @"其他":@"party"};
    imgName = typeNames[type];
    if(!imgName){
        imgName = @"party";
    }
    return [UIImage imageNamed:imgName];
    
}
@end
