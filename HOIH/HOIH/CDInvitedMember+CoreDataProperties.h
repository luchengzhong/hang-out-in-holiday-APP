//
//  CDInvitedMember+CoreDataProperties.h
//  HOIH
//
//  Created by 钟路成 on 16/6/3.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDInvitedMember.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDInvitedMember (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *uid;
@property (nullable, nonatomic, retain) NSString *status;

@end

NS_ASSUME_NONNULL_END
