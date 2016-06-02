//
//  HOIHDataManager.h
//  HOIH
//
//  Created by 钟路成 on 16/6/2.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface HOIHDataManager : NSObject
-(NSManagedObjectContext*)sharedContext;
-(NSManagedObject*)insert:(NSManagedObject*)object Context:(NSManagedObjectContext*)context;
-(NSArray*)select:(NSString*)predicateStr EntityName:(NSString*)entityName;
-(BOOL)delete:(NSManagedObject*)object;
-(BOOL)saveContext:(NSManagedObjectContext*)context;
@end
