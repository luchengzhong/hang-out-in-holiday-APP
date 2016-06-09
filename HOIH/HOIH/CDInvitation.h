//
//  CDInvitation.h
//  HOIH
//
//  Created by 钟路成 on 16/6/3.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface CDInvitation : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
-(BOOL)setMembersWithArray:(NSArray*)array;
-(NSArray*)getMembersArray;
@end

NS_ASSUME_NONNULL_END

#import "CDInvitation+CoreDataProperties.h"
