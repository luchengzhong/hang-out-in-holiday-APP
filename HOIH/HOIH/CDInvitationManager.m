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
    NSString *updateTime;
    CDFriendsManager *membersManager;
    NSMutableDictionary *memsUsername;
}

-(NSArray*)updateInvitationsForPage:(NSInteger)pageNum{
    NSMutableArray *invitationsFromCD = [self getInvitationsFromCoreDataForPage:pageNum];
    //update from server;
    if(pageNum == 0){
        updateTime = [[HOIHConfigure _sharedInstance] getConfigueValueForKey:configureName];
        
        HOIHHTTPClient *client = [HOIHHTTPClient sharedHTTPClient];
        client.delegate = self;
        [client getInvitations:[HOIHUserInfo getUsername] Time:updateTime];
    }
    return invitationsFromCD;
}
#pragma mark - Core data
-(NSMutableArray*)getInvitationsFromCoreDataForPage:(NSInteger)pageNum{
    NSMutableArray *invitationsFromCD;
    
    //Load all invitations from CD into dictionary
    invitationDict = [NSMutableDictionary new];
    memsUsername = [NSMutableDictionary new];
    invitationsFromCD = [[NSMutableArray alloc]
                         initWithArray:[super select:nil EntityName:invEntityName PageNum:pageNum NumPerPage:20
                                      SortDescriptor:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"update_time" ascending:NO]]]];
    for (CDInvitation *item in invitationsFromCD) {
        NSString *iid = [NSString stringWithFormat:@"%ld",[item.iid longValue]];
        invitationDict[iid] = item;
        memsUsername[item.inviter_id] = [NSNumber numberWithBool:YES];
        for(NSDictionary* memItem in item.getMembersArray){
            memsUsername[memItem[@"UID"]] = [NSNumber numberWithBool:YES];
        }
    }
    [self getMembersFromCoreData];
    //Sort
    /*[invitationsFromCD sortUsingComparator:^NSComparisonResult(id obj1,id obj2){
        return [self compareInvitation1:obj1 Invitation2:obj2];
    }];*/
    return invitationsFromCD;
}
-(NSDictionary*)getMembersFromCoreData{
    //set update member delegate
    if(!membersManager){
        membersManager = [[CDFriendsManager alloc] init];
        membersManager.delegate = _delegate;
    }
    if(!_membersDict)
        _membersDict = [NSMutableDictionary new];
    
    //Updatemembers
    if([memsUsername count]>0)
        _membersDict = [membersManager getMembersFromCoreData:[NSMutableArray arrayWithArray:[memsUsername allKeys]]];
    return _membersDict;
}
#pragma mark - HTTP
-(void)HOIHHTTPClient:(HOIHHTTPClient *)client didUpdateInvitations:(id)invitations Time:(NSString *)date{
    
    NSArray *invitationList = (NSArray*)invitations;
    
    if([invitationList count] != 0){
        //create a dictionary to store all members that need to be updated
        
        if(!memsUsername)
            memsUsername = [NSMutableDictionary new];
        for(NSDictionary *item in invitationList){
            CDInvitation *cdInvitation;
            NSString *iid = [NSString stringWithFormat:@"%ld",[item[@"IID"] longValue]];
            cdInvitation = invitationDict[iid];
            if(!cdInvitation){
                NSString *selectStr = [NSString stringWithFormat:@"iid = %ld",[item[@"IID"] longValue]];
                NSArray *cdList = [super select:selectStr EntityName:invEntityName];
                if(cdList && [cdList count]>0)
                    cdInvitation = cdList[0];
                else
                    cdInvitation = [NSEntityDescription insertNewObjectForEntityForName:invEntityName
                                                                 inManagedObjectContext:[super sharedContext]];
            }
            [cdInvitation setIid:item[@"IID"]];
            [cdInvitation setStatus:item[@"status"]];
            [cdInvitation setInviter_id:item[@"inviter_id"]];
            
            [cdInvitation setUpdate_time:[DateUtil dateFromString:item[@"update_time"]]];
            [cdInvitation setCreate_time:[DateUtil dateFromString:item[@"create_time"]]];
            [cdInvitation setInvite_time:[DateUtil dateFromString:item[@"invite_time"]]];
            
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
        
        //set update member delegate
        if(!membersManager){
            membersManager = [[CDFriendsManager alloc] init];
            membersManager.delegate = _delegate;
        }
        if(!_membersDict)
            _membersDict = [NSMutableDictionary new];
        
        //Updatemembers
        _membersDict = [membersManager updateMembers:memUsernames];
        if([super saveContext:[super sharedContext]]){
            updateTime = invitationList[0][@"update_time"];
            [[HOIHConfigure _sharedInstance] setConfigueValue:updateTime ForKey:configureName];
        }
        NSArray *newInvitations = [self getInvitationsFromCoreDataForPage:0];;
        //NSArray *newInvitations = [self sortInvitationDict:invitationDict];
        [_delegate CDInvitationManager:self didUpdateInvitations:newInvitations];
    }else{
        [_delegate CDInvitationManager:self didUpdateInvitations:nil];
    }
    
}

/*-(NSArray*)sortInvitationDict:(NSDictionary*)dict{
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
}*/
@end
