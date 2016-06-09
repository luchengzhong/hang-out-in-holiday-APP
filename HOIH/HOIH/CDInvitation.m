//
//  CDInvitation.m
//  HOIH
//
//  Created by 钟路成 on 16/6/3.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import "CDInvitation.h"

@implementation CDInvitation

// Insert code here to add functionality to your managed object subclass
-(BOOL)setMembersWithArray:(NSArray*)array{
    if(!array || [array count]==0)
        return false;
    NSError *err;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:array options:0 error:&err];
    if(err){
        NSLog(@"err encode:%@",err);
        return false;
    }
    self.members = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return true;
}
-(NSArray*)getMembersArray{
    NSError *err;
    NSData *objectData = [self.members dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&err];
    
    if(err)
        return [NSArray new];
    return json;
}
@end
