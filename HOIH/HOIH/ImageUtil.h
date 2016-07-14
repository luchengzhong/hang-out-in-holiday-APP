//
//  ImageUtil.h
//  HOIH
//
//  Created by 钟路成 on 16/5/31.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageUtil : NSObject
+ (UIImage*)roundedImageNamed:(NSString*)image toWidth:(NSInteger)width height:(NSInteger)height;
+ (UIImage*)roundedImage:(UIImage*)image toWidth:(NSInteger)width height:(NSInteger)height;
+ (UIImage*)roundedImage:(UIImage*)image;
+ (UIImage*)resizeImage:(NSString*)name;
+ (UIImage*)typeImage:(NSString*)type;
@end
