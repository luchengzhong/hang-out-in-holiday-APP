//
//  CDInvitation+CoreDataProperties.h
//  HOIH
//
//  Created by 钟路成 on 16/6/3.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDInvitation.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDInvitation (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *iid;
@property (nullable, nonatomic, retain) NSString *create_time;
@property (nullable, nonatomic, retain) NSString *invite_time;
@property (nullable, nonatomic, retain) NSString *coordinate;
@property (nullable, nonatomic, retain) NSString *place_name;
@property (nullable, nonatomic, retain) NSString *inviter_id;
@property (nullable, nonatomic, retain) NSString *comment;
@property (nullable, nonatomic, retain) NSString *update_time;
@property (nullable, nonatomic, retain) NSString *status;
@property (nullable, nonatomic, retain) NSSet<CDInvitedMember *> *members;

@end

@interface CDInvitation (CoreDataGeneratedAccessors)

- (void)addMembersObject:(CDInvitedMember *)value;
- (void)removeMembersObject:(CDInvitedMember *)value;
- (void)addMembers:(NSSet<CDInvitedMember *> *)values;
- (void)removeMembers:(NSSet<CDInvitedMember *> *)values;

@end

NS_ASSUME_NONNULL_END