//
//  InvitedLayer.h
//  HOIH
//
//  Created by 钟路成 on 16/5/30.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface InvitedLayer : NSObject
@property CGFloat gap;

-(id)initWithGap:(CGFloat)gap;

-(UIView*) getInvitedLayer:(NSDictionary*)members SourceView:(UIView*)sourceView;
@end
