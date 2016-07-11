//
//  CDInvitation+CoreDataProperties.h
//  HOIH
//
//  Created by 钟路成 on 16/7/6.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDInvitation.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDInvitation (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *comment;
@property (nullable, nonatomic, retain) NSString *coordinate;
@property (nullable, nonatomic, retain) NSDate *create_time;
@property (nullable, nonatomic, retain) NSNumber *iid;
@property (nullable, nonatomic, retain) NSDate *invite_time;
@property (nullable, nonatomic, retain) NSString *inviter_id;
@property (nullable, nonatomic, retain) NSString *members;
@property (nullable, nonatomic, retain) NSString *place_name;
@property (nullable, nonatomic, retain) NSString *status;
@property (nullable, nonatomic, retain) NSDate *update_time;

@end

NS_ASSUME_NONNULL_END
