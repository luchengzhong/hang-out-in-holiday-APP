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
- (instancetype)initWithBaseURL:(NSURL *)url;

- (void)getInvitations:(NSString*)username Time:(NSString*)date;
- (void)getFriends:(NSString*)username Time:(NSString*)date;
- (void)getMembers:(NSArray*)requestArray Time:(NSString*)date;
@end

@protocol HOIHHTTPClientDelegate <NSObject>

@optional
-(void)HOIHHTTPClient:(HOIHHTTPClient *)client didUpdateInvitations:(id)invitations Time:(NSString*)date;
-(void)HOIHHTTPClient:(HOIHHTTPClient *)client didUpdateFriends:(id)friends Time:(NSString*)date;
-(void)HOIHHTTPClient:(HOIHHTTPClient *)client didFailWithError:(NSError*) error;
@end