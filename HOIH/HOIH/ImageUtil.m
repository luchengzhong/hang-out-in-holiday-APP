//
//  ImageUtil.m
//  HOIH
//
//  Created by 钟路成 on 16/5/31.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import "ImageUtil.h"

@implementation ImageUtil
static NSDictionary *typeNames;
static NSMutableDictionary *typeGaosImages;

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

+ (UIImage*)imageShortNamed:(NSString*)shortName{
    return [UIImage imageNamed:[NSString stringWithFormat:@"photo_%@",shortName]];
}

+ (UIImage*)roundedImageNamed:(NSString*)image toWidth:(NSInteger)width height:(NSInteger)height{
    NSString *imgName = [NSString stringWithFormat:@"photo_%@",image];
    return [self roundedImage:[UIImage imageNamed:imgName] toWidth:width height:height];
}
+(NSDictionary*)getTypeDict{
    static dispatch_once_t onceTokenT;
    dispatch_once(&onceTokenT, ^{
        typeNames = @{@"桌游":@"desk_game",
                      @"聚餐":@"eat",
                      @"开黑":@"vedio_game",
                      @"KTV":@"ktv",
                      @"旅游":@"travel",
                      @"Party":@"party",
                      @"其他":@"party"};
    });
    return typeNames;
}
+ (UIImage*)typeImage:(NSString*)type{
    if(!type){
        type = @"其他";
    }
    NSString *imgName;
    [self getTypeDict];
    imgName = typeNames[type];
    if(!imgName){
        imgName = @"party";
    }
    return [UIImage imageNamed:imgName];
    
}





+ (UIImage*)typeGaussImage:(NSString*)type{
    [self getTypeDict];
    if(!typeGaosImages)
        typeGaosImages = [NSMutableDictionary new];
    if(!typeGaosImages[type]){
        typeGaosImages[type] = [self blur:[UIImage imageNamed:typeNames[type]]];
    }
    return typeGaosImages[type];
}
+ (UIImage*) blur:(UIImage*)theImage
{
    // ***********If you need re-orienting (e.g. trying to blur a photo taken from the device camera front facing camera in portrait mode)
    // theImage = [self reOrientIfNeeded:theImage];
    
    // create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
    
    // setting up Gaussian Blur (we could use one of many filters offered by Core Image)
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:15.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    // CIGaussianBlur has a tendency to shrink the image a little,
    // this ensures it matches up exactly to the bounds of our original image
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    /*UIImage *returnImage = [UIImage imageWithCGImage:cgImage];//create a UIImage for this function to "return" so that ARC can manage the memory of the blur... ARC can't manage CGImageRefs so we need to release it before this function "returns" and ends.
    */
    
    // *************** if you need scaling
    UIImage *returnImage = [[self class] scaleIfNeeded:cgImage];
    CGImageRelease(cgImage);//release CGImageRef because ARC doesn't manage this on its own.
    return returnImage;
}

+(UIImage*) scaleIfNeeded:(CGImageRef)cgimg {
    bool isRetina = [[[UIDevice currentDevice] systemVersion] intValue] >= 4 && [[UIScreen mainScreen] scale] == 2.0;
    if (isRetina) {
        return [UIImage imageWithCGImage:cgimg scale:2.0 orientation:UIImageOrientationUp];
    } else {
        return [UIImage imageWithCGImage:cgimg];
    }
}
@end
