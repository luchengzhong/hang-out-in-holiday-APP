//
//  CDInvitationManager.h
//  HOIH
//
//  Created by 钟路成 on 16/6/2.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import "HOIHDataManager.h"
#import "HOIHHTTPClient.h"
#import "CDFriendsManager.h"

@protocol CDInvitationManagerDelegate;
@interface CDInvitationManager : HOIHDataManager <HOIHHTTPClientDelegate>
@property id<CDInvitationManagerDelegate, CDFriendsManagerDelegate>delegate;
@property NSMutableDictionary *membersDict;

-(NSArray*)updateInvitationsForPage:(NSInteger)pageNum;
@end

@protocol CDInvitationManagerDelegate <NSObject>

-(void)CDInvitationManager:(CDInvitationManager*)manager didUpdateInvitations:(NSArray*)invitations;

@end