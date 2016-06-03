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

@interface CDFriendsManager : HOIHDataManager <HOIHHTTPClientDelegate>
-(NSMutableDictionary*)updateFriends;
-(NSMutableDictionary*)updateMembers:(NSArray*)memberList;
-(void)HOIHHTTPClient:(HOIHHTTPClient *)client didUpdateFriends:(id)friends Time:(NSString *)date;
@end
