//
//  HOIHHTTPClient.h
//  HOIH
//
//  Created by 钟路成 on 16/6/1.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
@protocol HOIHHTTPClientDelegate;
@interface HOIHHTTPClient : AFHTTPSessionManager

@property (nonatomic, weak) id<HOIHHTTPClientDelegate>delegate;

+ (HOIHHTTPClient *)sharedHTTPClient;
- (instancetype)initWithStaticURL;

- (void)getInvitations:(NSString*)username Time:(NSString*)date;
- (void)getFriends:(NSString*)username Time:(NSString*)date;
- (void)getMembers:(NSArray*)requestArray;

- (void)addInvitationTime:(NSString*)inviteTime MemberUIDs:(NSArray*)memArray Type:(NSString*)type PayMethod:(NSString*)payMethod PlaceName:(NSString*)placeName Coordinate:(NSString*)coordinate Comment:(NSString*)comment;
- (void)updateStatus:(NSString*)status IID:(NSNumber*)iid;

- (void)addMessageForInv:(NSNumber*)IID Time:(NSString*)date Content:(NSString*)content;
- (void)getMessages:(NSNumber*)IID Time:(NSString*)date;
@end

@protocol HOIHHTTPClientDelegate <NSObject>

@optional
-(void)HOIHHTTPClient:(HOIHHTTPClient *)client didUpdateInvitations:(id)invitations Time:(NSString*)date;
-(void)HOIHHTTPClient:(HOIHHTTPClient *)client didUpdateFriends:(id)friends Time:(NSString*)date;
-(void)HOIHHTTPClient:(HOIHHTTPClient *)client didFailWithError:(NSError*) error;
-(void)HOIHHTTPClient:(HOIHHTTPClient *)client didUpdateMessages:(id)messages Invitation:(id)invitation;
-(void)HOIHHTTPClient:(HOIHHTTPClient *)client didAddInvitation:(id)result;
-(void)HOIHHTTPClient:(HOIHHTTPClient *)client didUpdateStatus:(id)result;
-(void)HOIHHTTPClient:(HOIHHTTPClient *)client didSendMessage:(id)response;
@end