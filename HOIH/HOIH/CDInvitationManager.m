//
//  CDInvitationManager.m
//  HOIH
//
//  Created by 钟路成 on 16/6/2.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import "CDInvitationManager.h"
#import "HOIHUserInfo.h"
#import "HOIHConfigure.h"
#import "CDInvitation.h"
#import "DateUtil.h"
static NSString *invEntityName = @"CDInvitation";
static NSString *memEntityName = @"CDInvitedMember";
static NSString *configureName = @"InvitationUpdateTime";

@implementation CDInvitationManager{
    NSMutableDictionary *invitationDict;
    NSMutableDictionary *membersDict;
    NSString *updateTime;
    CDFriendsManager *membersManager;
}

-(NSArray*)updateInvitationsForPage:(NSInteger)pageNum{
    NSMutableArray *invitationsFromCD;
    if(!invitationDict){
        //Load all invitations from CD into dictionary
        invitationDict = [NSMutableDictionary new];
        invitationsFromCD = [[NSMutableArray alloc] initWithArray:[super select:nil EntityName:invEntityName
                                                                        PageNum:pageNum NumPerPage:20]];
        for (CDInvitation *item in invitationsFromCD) {
            NSString *iid = [NSString stringWithFormat:@"%ld",[item.iid longValue]];
            invitationDict[iid] = item;
        }
    }
    updateTime = [[HOIHConfigure _sharedInstance] getConfigueValueForKey:configureName];
    
    HOIHHTTPClient *client = [HOIHHTTPClient sharedHTTPClient];
    client.delegate = self;
    [client getInvitations:[HOIHUserInfo getUsername] Time:updateTime];
    [invitationsFromCD sortUsingComparator:^NSComparisonResult(id obj1,id obj2){
        return [self compareInvitation1:obj1 Invitation2:obj2];
    }];
    return invitationsFromCD;
}

-(void)HOIHHTTPClient:(HOIHHTTPClient *)client didUpdateInvitations:(id)invitations Time:(NSString *)date{
    
    NSArray *invitationList = (NSArray*)invitations;
    
    if([invitationList count] != 0){
        //create a dictionary to store all members that need to be updated
        
        NSMutableDictionary *memsUsername = [NSMutableDictionary new];
        for(NSDictionary *item in invitationList){
            CDInvitation *cdInvitation;
            NSString *iid = [NSString stringWithFormat:@"%ld",[item[@"IID"] longValue]];
            cdInvitation = invitationDict[iid];
            if(!cdInvitation){
                NSString *selectStr = [NSString stringWithFormat:@"iid = %ld",[item[@"IID"] longValue]];
                NSArray *cdList = [super select:selectStr EntityName:invEntityName PageNum:0 NumPerPage:1];
                if(cdList && [cdList count]>0)
                    cdInvitation = cdList[0];
                else
                    cdInvitation = [NSEntityDescription insertNewObjectForEntityForName:invEntityName
                                                                 inManagedObjectContext:[super sharedContext]];
            }
            [cdInvitation setIid:item[@"IID"]];
            [cdInvitation setStatus:item[@"status"]];
            [cdInvitation setInviter_id:item[@"inviter_id"]];
            [cdInvitation setUpdate_time:item[@"update_time"]];
            [cdInvitation setCreate_time:item[@"create_time"]];
            [cdInvitation setInvite_time:item[@"invite_time"]];
            id coordinate = item[@"coordinate"];
            if(coordinate && coordinate != [NSNull null]){
                [cdInvitation setCoordinate:(NSString*)coordinate];
            }
            id place_name = item[@"place_name"];
            if(place_name && place_name != [NSNull null]){
                [cdInvitation setPlace_name:(NSString*)place_name];
            }
            id comment = item[@"comment"];
            if(comment && comment != [NSNull null]){
                [cdInvitation setComment:(NSString*)comment];
            }
            
            NSArray *mems = item[@"invited_members"];
            [cdInvitation setMembersWithArray:mems];
            for(NSDictionary* memItem in mems){
                memsUsername[memItem[@"UID"]] = [NSNumber numberWithBool:YES];
            }
            invitationDict[iid] = cdInvitation;
            
        }
        NSArray *memUsernames=[memsUsername allKeys];
        if(!membersManager){
            membersManager = [[CDFriendsManager alloc] init];
            membersManager.delegate = _delegate;
        }
        if(!membersDict)
            membersDict = [NSMutableDictionary new];
        //Updatemembers
        membersDict = [membersManager updateMembers:memUsernames];
        if([super saveContext:[super sharedContext]]){
            updateTime = invitationList[0][@"update_time"];
            [[HOIHConfigure _sharedInstance] setConfigueValue:updateTime ForKey:configureName];
        }
    }
    NSArray *newInvitations = [self sortInvitationDict:invitationDict];
    [_delegate CDInvitationManager:self didUpdateInvitations:newInvitations];
}

-(NSArray*)sortInvitationDict:(NSDictionary*)dict{
    NSMutableArray *invitationArray = [NSMutableArray new];
    NSArray *keysArray;
    
    keysArray = [dict keysSortedByValueUsingComparator: ^(id obj1, id obj2) {
        return [self compareInvitation1:obj1 Invitation2:obj2];
    }];
    
    for(NSString *key in keysArray){
        [invitationArray addObject:dict[key]];
    }
    return invitationArray;
}
-(NSComparisonResult)compareInvitation1:(CDInvitation*)inv1 Invitation2:(CDInvitation*)inv2{
    return [DateUtil compareStringDate1:inv1.update_time Date2:inv2.update_time];
}
@end
