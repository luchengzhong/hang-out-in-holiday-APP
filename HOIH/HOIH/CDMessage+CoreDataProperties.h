//
//  CDMessage+CoreDataProperties.h
//  HOIH
//
//  Created by 钟路成 on 16/7/13.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDMessage (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSDate *create_time;
@property (nullable, nonatomic, retain) NSNumber *iid;
@property (nullable, nonatomic, retain) NSNumber *mid;
@property (nullable, nonatomic, retain) NSString *type;
@property (nullable, nonatomic, retain) NSString *uid;

@end

NS_ASSUME_NONNULL_END
