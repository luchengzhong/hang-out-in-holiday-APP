//
//  CDInvitationManager.m
//  HOIH
//
//  Created by 钟路成 on 16/6/2.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import "CDInvitationManager.h"
#import "HOIHHTTPClient.h"
static NSString *invEntityName = @"CDInvitation";
@implementation CDInvitationManager

-(NSMutableArray*)updateInvitationsForPage:(NSInteger)pageNum{
    NSMutableArray *invitationsFromCD;
    invitationsFromCD = [[NSMutableArray alloc] initWithArray:[super select:nil EntityName:invEntityName
                                                                    PageNum:pageNum NumPerPage:20]];
    
    
    
    return invitationsFromCD;
}


@end
