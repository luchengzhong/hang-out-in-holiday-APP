//
//  CDMessage.m
//  HOIH
//
//  Created by 钟路成 on 16/7/13.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import "CDMessage.h"
#import "DateUtil.h"

@implementation CDMessage

// Insert code here to add functionality to your managed object subclass
-(void)setMessageDict:(NSDictionary*)dict{
    if(!dict){
        NSLog(@"nil message dict");
        return;
    }
    self.iid = [NSNumber numberWithInteger:[dict[@"IID"] integerValue]];
    self.mid = [NSNumber numberWithInteger:[dict[@"MID"] integerValue]];
    self.uid = dict[@"UID"];
    self.content = dict[@"content"];
    self.type = dict[@"type"];
    self.create_time = [DateUtil dateFromString:dict[@"create_time"]];
}
@end
