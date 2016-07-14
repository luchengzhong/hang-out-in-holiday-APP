//
//  CDFriendsManager.h
//  HOIH
//
//  Created by 钟路成 on 16/6/1.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HOIHHTTPClient.h"
#import "HOIHDataManager.h"
@protocol CDFriendsManagerDelegate;

@interface CDFriendsManager : HOIHDataManager <HOIHHTTPClientDelegate>
@property id<CDFriendsManagerDelegate> delegate;

-(NSMutableDictionary*)getFriendsFromCoreData;
-(NSMutableDictionary*)updateFriends;
-(NSMutableDictionary*)updateMembers:(NSArray*)memberList;
-(void)HOIHHTTPClient:(HOIHHTTPClient *)client didUpdateFriends:(id)friends Time:(NSString *)date;
-(NSMutableDictionary*)getMembersFromCoreData:(NSMutableArray*)usernameList;
@end

@protocol CDFriendsManagerDelegate <NSObject>

@optional
-(void)CDFriendsManager:(CDFriendsManager *)manager didUpdateUserinfos:(NSDictionary *)userinfos Time:(NSString*)date;
@end