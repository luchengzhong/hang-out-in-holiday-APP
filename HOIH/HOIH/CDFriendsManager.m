//
//  CDFriendsManager.m
//  HOIH
//
//  Created by 钟路成 on 16/6/1.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import "CDFriendsManager.h"
#import "HOIHConfigure.h"
#import "CDFriends.h"
#import "HOIHHTTPClient.h"
#import "DateUtil.h"

static NSString* entityName = @"CDFriends";
static NSString* configureTimesName = @"FriendsUpdateTime";
@implementation CDFriendsManager{
    NSString *updateTime;
    NSMutableDictionary *friendsList;
}
-(id)init{
    self = [super init];
    if(self){
        [self initFriendsList];
    }
    return self;
}
-(void)initFriendsList{
    NSArray *array = [super select:nil EntityName:entityName];
    friendsList = [NSMutableDictionary new];
    if(!array){
        return;
    }
    for(CDFriends* afriend in array){
        friendsList[afriend.username] = afriend;
    }
}
-(void)updateFriends{
    updateTime = [self friendsUpdateTime];
    HOIHHTTPClient *client = [HOIHHTTPClient sharedHTTPClient];
    client.delegate = self;
    [client getFriends:@"luchengzhong" Time:updateTime];
}
-(NSString*)friendsUpdateTime{
    return [[HOIHConfigure _sharedInstance] getConfigueValueForKey:configureTimesName];
}

-(void)HOIHHTTPClient:(HOIHHTTPClient *)client didUpdateFriends:(id)friends Time:(NSString *)date{
    NSArray *array = friends[@"friends"];
    if([array count]==0){
        return;
    }
    updateTime = array[0][@"update_time"];
    for(NSDictionary* friendItem in array){
        CDFriends *afriend;
        NSLog(@"%@",friendItem[@"username"]);
        if(friendsList[friendItem[@"username"]]){
            afriend = friendsList[friendItem[@"username"]];
        }else{
            afriend = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                                    inManagedObjectContext:[super sharedContext]];
        }
        [afriend setUsername:[friendItem valueForKey:@"username"]
                        Name:friendItem[@"name"] Photo:friendItem[@"photo"]
                  UpdateTime:friendItem[@"update_time"]];
        friendsList[friendItem[@"username"]] = afriend;
    }
    if([super saveContext:[super sharedContext]]){
        [[HOIHConfigure _sharedInstance] setConfigueValue:updateTime ForKey:configureTimesName];
    }
    
    NSLog(@"%@",friends);
}
@end
