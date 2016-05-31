//
//  InvitedLayer.m
//  HOIH
//
//  Created by 钟路成 on 16/5/30.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import "InvitedLayer.h"
#import "ImageUtil.h"

@implementation InvitedLayer{
    CGFloat photoWidth;
    UIImage *resizedImage;
}
-(id)init{
    return [self initWithGap:5.0f];
}
-(id)initWithGap:(CGFloat)gap{
    self = [super init];
    if(self){
        _gap = gap;
        photoWidth = 30;
        resizedImage = [ImageUtil roundedImage:[UIImage imageNamed:@"zhonglucheng"] toWidth:photoWidth height:photoWidth];
    }
    return self;
}
-(UIView*) getInvitedLayer:(NSDictionary*)members SourceView:(UIView*)sourceView{
    UIView* invitedView = [[UIView alloc] initWithFrame:CGRectMake(0,0,sourceView.frame.size.width,sourceView.frame.size.height)];
    CGFloat xPoint = _gap;
    CGFloat yPoing = _gap;
    NSInteger numberPerRow = invitedView.frame.size.width / (xPoint+photoWidth);
    NSInteger i=0;
    for(i=0;i<10;i++){
        [invitedView addSubview:({
            UIImageView *subView = [[UIImageView alloc] initWithFrame:CGRectMake(xPoint, yPoing, photoWidth, photoWidth)];
            subView.image = resizedImage;
            //[self convertToRoundImage:subView BorderColor:[UIColor whiteColor] BorderWidth:2.0f];
            subView;
        })];
        
        xPoint += _gap+photoWidth;
        if(i>=numberPerRow-1){
            if(yPoing == _gap){
                xPoint = _gap;
                yPoing = invitedView.frame.size.height - photoWidth - _gap;
            }else{
                break;
            }
        }
    }
    
    return invitedView;
}

#pragma mark - image utils
-(void)convertToRoundImage:(UIImageView*)imageView BorderColor:(UIColor*)borderColor BorderWidth:(CGFloat)borderWidth{
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = imageView.frame.size.width * 0.5;
    [imageView.layer setBorderColor:borderColor.CGColor];
    [imageView.layer setBorderWidth:borderWidth];
}
@end
