//
//  HOIHHTTPClient.m
//  HOIH
//
//  Created by 钟路成 on 16/6/1.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import "HOIHHTTPClient.h"
#import "HOIHUserInfo.h"
static NSString * const strCMTurl = @"http://localhost/hang-out-in-holiday/";
static HOIHHTTPClient *_sharedHTTPClient;
@implementation HOIHHTTPClient

+ (HOIHHTTPClient *)sharedHTTPClient {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedHTTPClient = [[self alloc] initWithStaticURL];
    });
    
    return _sharedHTTPClient;
}

- (instancetype)initWithStaticURL{
    
    self = [super initWithBaseURL:[NSURL URLWithString:strCMTurl]];
    
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        [self.requestSerializer setValue:@"utf-8" forHTTPHeaderField:@"charset"];
    }
    
    return self;
}

- (void)getInvitations:(NSString*)username Time:(NSString*)date{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    

    parameters[@"username"] = username;
    parameters[@"request_type"] = @"getInvitations";
    if(date)
        parameters[@"date"] = date;
    
    [self POST:@"InvitationController.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if ([self.delegate respondsToSelector:@selector(HOIHHTTPClient:didUpdateInvitations:Time:)]) {
            [self.delegate HOIHHTTPClient:self didUpdateInvitations:responseObject[@"invitations"] Time:date];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self.delegate respondsToSelector:@selector(HOIHHTTPClient:didFailWithError:)]) {
            [self.delegate HOIHHTTPClient:self didFailWithError:error];
        }
    }];
    /*[self POST:@"InvitationController.php" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(CMTHTTPClient:didUpdateWithJourney:)]) {
            [self.delegate CMTHTTPClient:self didUpdateWithJourney:responseObject];
            
        }
        NSLog(@"%ld",[responseObject[@"invitations"] count]);
        NSLog(@"%@",responseObject);
        NSString* comment = [responseObject[@"invitations"][2][@"comment"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(comment);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(CMTHTTPClient:didFailWithError:)]) {
            [self.delegate CMTHTTPClient:self didFailWithError:error];
        }
        NSLog(@"%@",error);
        
    }];*/

}

- (void)getFriends:(NSString*)username Time:(NSString*)date{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    
    parameters[@"username"] = username;
    if(date)
        parameters[@"date"] = date;
    
    [self POST:@"FriendController.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if ([self.delegate respondsToSelector:@selector(HOIHHTTPClient:didUpdateFriends:Time:)]) {
            [self.delegate HOIHHTTPClient:self didUpdateFriends:responseObject[@"friends"] Time:date];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self.delegate respondsToSelector:@selector(HOIHHTTPClient:didFailWithError:)]) {
            [self.delegate HOIHHTTPClient:self didFailWithError:error];
        }
        NSLog(@"%@",error);
    }];
}
- (void)getMembers:(NSArray*)requestArray{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"username"] = [HOIHUserInfo getUsername];
    parameters[@"members"] = requestArray;
    
    [self POST:@"MemberController.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if ([self.delegate respondsToSelector:@selector(HOIHHTTPClient:didUpdateFriends:Time:)]) {
            [self.delegate HOIHHTTPClient:self didUpdateFriends:responseObject[@"members"] Time:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self.delegate respondsToSelector:@selector(HOIHHTTPClient:didFailWithError:)]) {
            [self.delegate HOIHHTTPClient:self didFailWithError:error];
        }
        NSLog(@"%@",error);
    }];
}

- (void)getMessages:(NSNumber*)IID Time:(NSString*)date{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"username"] = [HOIHUserInfo getUsername];
    if(date)
        parameters[@"date"] = date;
    else{
        parameters[@"date"] = @"1970-01-01 00:00:00";
    }
    parameters[@"IID"] = IID;
    
    [self POST:@"MessagesController.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if ([self.delegate respondsToSelector:@selector(HOIHHTTPClient:didUpdateMessages:Invitation:)]) {
            [self.delegate HOIHHTTPClient:self didUpdateMessages:responseObject[@"messages"] Invitation:responseObject[@"invitation"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self.delegate respondsToSelector:@selector(HOIHHTTPClient:didFailWithError:)]) {
            [self.delegate HOIHHTTPClient:self didFailWithError:error];
        }
        NSLog(@"%@",error);
    }];
}

-(void)addInvitationTime:(NSString*)inviteTime MemberUIDs:(NSArray*)memArray Type:(NSString*)type PayMethod:(NSString*)payMethod PlaceName:(NSString*)placeName Coordinate:(NSString*)coordinate Comment:(NSString*)comment{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"username"] = [HOIHUserInfo getUsername];
    parameters[@"invite_time"] = inviteTime;
    parameters[@"invited_array"] = memArray;
    parameters[@"type"] = type;
    parameters[@"pay_method"] = payMethod;
    parameters[@"place_name"] = placeName;
    parameters[@"coordinate"] = coordinate;
    parameters[@"comment"] = comment;
    
    parameters[@"request_type"] = @"addInvitation";
    
    [self POST:@"InvitationController.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"add invitation: %@",responseObject);
        if ([self.delegate respondsToSelector:@selector(HOIHHTTPClient:didAddInvitation:)]) {
            [self.delegate HOIHHTTPClient:self didAddInvitation:responseObject];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self.delegate respondsToSelector:@selector(HOIHHTTPClient:didFailWithError:)]) {
            [self.delegate HOIHHTTPClient:self didFailWithError:error];
        }
        NSLog(@"%@",error);
    }];
}
-(void)updateStatus:(NSString *)status IID:(NSNumber*)iid{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"IID"] = iid;
    parameters[@"username"] = [HOIHUserInfo getUsername];
    parameters[@"status"] = status;
    parameters[@"request_type"] = @"updateStatus";
    
    [self POST:@"InvitationController.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"update status:%@",responseObject);
        if ([self.delegate respondsToSelector:@selector(HOIHHTTPClient:didUpdateStatus:)]) {
            [self.delegate HOIHHTTPClient:self didUpdateStatus:responseObject[@"status"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self.delegate respondsToSelector:@selector(HOIHHTTPClient:didFailWithError:)]) {
            [self.delegate HOIHHTTPClient:self didFailWithError:error];
        }
        NSLog(@"%@",error);
    }];
}

- (void)addMessageForInv:(NSNumber*)IID Time:(NSString*)date Content:(NSString*)content{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"IID"] = IID;
    parameters[@"username"] = [HOIHUserInfo getUsername];
    parameters[@"create_time"] = date;
    parameters[@"content"] = content;
    parameters[@"request_type"] = @"addMessage";
    
    [self POST:@"InvitationController.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"update status:%@",responseObject);
        if ([self.delegate respondsToSelector:@selector(HOIHHTTPClient:didSendMessage:)]) {
            [self.delegate HOIHHTTPClient:self didSendMessage:responseObject];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self.delegate respondsToSelector:@selector(HOIHHTTPClient:didFailWithError:)]) {
            [self.delegate HOIHHTTPClient:self didFailWithError:error];
        }
        NSLog(@"%@",error);
    }];

}
@end
