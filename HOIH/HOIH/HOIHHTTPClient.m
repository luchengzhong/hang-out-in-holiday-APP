//
//  HOIHHTTPClient.m
//  HOIH
//
//  Created by 钟路成 on 16/6/1.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import "HOIHHTTPClient.h"
static NSString * const strCMTurl = @"http://localhost/hang-out-in-holiday/";
static HOIHHTTPClient *_sharedHTTPClient;
@implementation HOIHHTTPClient

+ (HOIHHTTPClient *)sharedHTTPClient {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedHTTPClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:strCMTurl]];
    });
    
    return _sharedHTTPClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    
    self = [super initWithBaseURL:url];
    
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
    
    [self POST:@"InvitationController.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([self.delegate respondsToSelector:@selector(HOIHHTTPClient:didUpdateInvitations:Time:)]) {
            [self.delegate HOIHHTTPClient:self didUpdateInvitations:responseObject Time:date];
        }
        NSLog(@"%@",responseObject);
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
        if ([self.delegate respondsToSelector:@selector(HOIHHTTPClient:didUpdateFriends:Time:)]) {
            [self.delegate HOIHHTTPClient:self didUpdateFriends:responseObject Time:date];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self.delegate respondsToSelector:@selector(HOIHHTTPClient:didFailWithError:)]) {
            [self.delegate HOIHHTTPClient:self didFailWithError:error];
        }
        NSLog(@"%@",error);
    }];
}
@end
