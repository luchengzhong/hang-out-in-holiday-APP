//
//  Friends.m
//  HOIH
//
//  Created by 钟路成 on 16/6/1.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import "CDFriends.h"

@implementation CDFriends

// Insert code here to add functionality to your managed object subclass
-(void)setUsername:(NSString*)username Name:(NSString*)name Photo:(NSString*)photo UpdateTime:(NSString*)date{
    self.username = username;
    self.name =name;
    self.photo = photo;
    self.update_time = date;
}
@end
