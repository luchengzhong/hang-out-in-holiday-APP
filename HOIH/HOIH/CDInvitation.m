//
//  CDInvitation.m
//  HOIH
//
//  Created by 钟路成 on 16/6/3.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import "CDInvitation.h"
#import "DateUtil.h"

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

-(void)setDict:(NSDictionary*)item{
    [self setIid:item[@"IID"]];
    [self setStatus:item[@"status"]];
    [self setInviter_id:item[@"inviter_id"]];
    
    [self setUpdate_time:[DateUtil dateFromString:item[@"update_time"]]];
    [self setCreate_time:[DateUtil dateFromString:item[@"create_time"]]];
    [self setInvite_time:[DateUtil dateFromString:item[@"invite_time"]]];
    
    id coordinate = item[@"coordinate"];
    if(coordinate && coordinate != [NSNull null]){
        [self setCoordinate:(NSString*)coordinate];
    }
    id place_name = item[@"place_name"];
    if(place_name && place_name != [NSNull null]){
        [self setPlace_name:(NSString*)place_name];
    }
    id comment = item[@"comment"];
    if(comment && comment != [NSNull null]){
        [self setComment:(NSString*)comment];
    }
    id pay_method = item[@"pay_method"];
    if(pay_method && pay_method != [NSNull null]){
        [self setPay_method:(NSString*)pay_method];
    }
    id type = item[@"type"];
    if(type && type != [NSNull null]){
        [self setType:(NSString*)type];
    }
    
    NSArray *mems = item[@"invited_members"];
    [self setMembersWithArray:mems];
}
@end
