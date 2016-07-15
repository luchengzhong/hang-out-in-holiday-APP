//
//  InvitedLayer.m
//  HOIH
//
//  Created by 钟路成 on 16/5/30.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import "InvitedLayer.h"
#import "ImageUtil.h"
#import "CDFriends.h"

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
        //resizedImage = [ImageUtil roundedImage:[UIImage imageNamed:@"zhonglucheng"] toWidth:photoWidth height:photoWidth];
    }
    return self;
}
-(id)initWithGap:(CGFloat)gap PhotoWidth:(CGFloat)width{
    self = [self initWithGap:gap];
    if(self){
        photoWidth = width;
    }
    return self;
}
-(UIView*) getInvitedLayer:(NSArray*)members SourceView:(UIView*)sourceView{
    UIView* invitedView = [[UIView alloc] initWithFrame:CGRectMake(0,0,sourceView.frame.size.width,sourceView.frame.size.height)];
    invitedView.layer.contentsScale = [UIScreen mainScreen].scale;
    CGFloat xPoint = _gap;
    CGFloat yPoing = _gap;
    NSInteger numberPerRow = invitedView.frame.size.width / (xPoint+photoWidth);
    if(numberPerRow >= [members count]){
        yPoing = invitedView.frame.size.height / 2 -photoWidth/2;
    }
    
    NSInteger i=0;
    NSInteger count = [members count];
    for(i=0;i<count;i++){
        [invitedView addSubview:({
            UIImageView *subView = [[UIImageView alloc] initWithFrame:CGRectMake(xPoint, yPoing, photoWidth, photoWidth)];
            CDFriends *mem = members[i];
            subView.layer.contentsScale = [UIScreen mainScreen].scale;
            subView.image = [ImageUtil resizeImage:mem.photo];
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
-(UIView*) getInvitedLayer:(NSArray*)members SourceView:(UIView*)sourceView MemberInfo:(NSDictionary*)memberInfo{
    NSMutableArray *cdMembers = [NSMutableArray new];
    for(NSDictionary *mem in members){
        [cdMembers addObject:memberInfo[mem[@"UID"]]];
    }
    
    return [self getInvitedLayer:cdMembers SourceView:sourceView];
}

#pragma mark - image utils
-(void)convertToRoundImage:(UIImageView*)imageView BorderColor:(UIColor*)borderColor BorderWidth:(CGFloat)borderWidth{
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = imageView.frame.size.width * 0.5;
    [imageView.layer setBorderColor:borderColor.CGColor];
    [imageView.layer setBorderWidth:borderWidth];
}
@end
