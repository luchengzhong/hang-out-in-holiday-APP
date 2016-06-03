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
static NSString* configureMemberTimesName = @"MembersUpdateTime";
@implementation CDFriendsManager{
    NSString *updateTime;
    NSMutableDictionary *friendsList;
    NSString *configureName;
}

-(void)initUserInfoList:(NSString*)selectString{
    NSArray *array = [super select:selectString EntityName:entityName];
    friendsList = [NSMutableDictionary new];
    if(!array){
        return;
    }
    for(CDFriends* afriend in array){
        friendsList[afriend.username] = afriend;
    }
}
#pragma mark - Members
-(NSMutableDictionary*)updateMembers:(NSMutableArray*)memberList{
    if([memberList count] == 0)
        return [NSMutableDictionary new];
    
    //remove duplicate
    NSOrderedSet *mySet = [[NSOrderedSet alloc] initWithArray:memberList];
    memberList = [[NSMutableArray alloc] initWithArray:[mySet array]];
    
    //read from core data
    NSString *selectStr = @"";
    NSMutableArray *requestArray = [NSMutableArray new];
    NSInteger index=0;
    NSInteger count = [memberList count];
    for(index=0;index<count;index++){
        NSString* uid = memberList[index];
        if(index != 0)
            selectStr = [selectStr stringByAppendingString:[NSString stringWithFormat:@" or username = '%@'", uid]];
        else
            selectStr = [selectStr stringByAppendingString:[NSString stringWithFormat:@"username = '%@'", uid]];
        [requestArray addObject:uid];
    }
    
    //update from server
    [self initUserInfoList:selectStr];
    configureName = configureMemberTimesName;
    updateTime = [[HOIHConfigure _sharedInstance] getConfigueValueForKey:configureName];
    HOIHHTTPClient *client = [HOIHHTTPClient sharedHTTPClient];
    client.delegate = self;
    [client getMembers:requestArray Time:updateTime];
    return friendsList;
}


#pragma mark - Friends
-(NSMutableDictionary*)updateFriends{
    [self initUserInfoList:@"isFriend = true"];
    updateTime = [self friendsUpdateTime];
    HOIHHTTPClient *client = [HOIHHTTPClient sharedHTTPClient];
    client.delegate = self;
    [client getFriends:@"luchengzhong" Time:updateTime];
    return friendsList;
}
-(NSString*)friendsUpdateTime{
    configureName = configureTimesName;
    return [[HOIHConfigure _sharedInstance] getConfigueValueForKey:configureName];
}

-(void)HOIHHTTPClient:(HOIHHTTPClient *)client didUpdateFriends:(id)friends Time:(NSString *)date{
    NSArray *array = friends;
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
            [afriend setIsFriend:[NSNumber numberWithBool:NO]];
        }
        if([configureName isEqualToString:configureTimesName]){
            [afriend setIsFriend:[NSNumber numberWithBool:YES]];
        }
        [afriend setUsername:[friendItem valueForKey:@"username"]
                        Name:friendItem[@"name"] Photo:friendItem[@"photo"]
                  UpdateTime:friendItem[@"update_time"]];
        friendsList[friendItem[@"username"]] = afriend;
    }
    //to do... delete friend
    if([super saveContext:[super sharedContext]]){
        [[HOIHConfigure _sharedInstance] setConfigueValue:updateTime ForKey:configureName];
    }
    
    NSLog(@"%@",friends);
}
@end
