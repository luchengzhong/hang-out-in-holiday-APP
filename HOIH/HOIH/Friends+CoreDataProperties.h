//
//  Friends+CoreDataProperties.h
//  HOIH
//
//  Created by 钟路成 on 16/6/1.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDFriends.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDFriends (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *username;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *update_time;
@property (nullable, nonatomic, retain) NSString *photo;

@end

NS_ASSUME_NONNULL_END
