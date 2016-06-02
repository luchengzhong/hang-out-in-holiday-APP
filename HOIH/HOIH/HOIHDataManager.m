//
//  HOIHDataManager.m
//  HOIH
//
//  Created by 钟路成 on 16/6/2.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import "HOIHDataManager.h"
#import "AppDelegate.h"
@implementation HOIHDataManager

-(NSManagedObjectContext*)sharedContext{
    AppDelegate* delegate = (AppDelegate *)([UIApplication sharedApplication].delegate);
    return delegate.managedObjectContext;
}
-(NSManagedObject*)insert:(NSManagedObject*)object Context:(NSManagedObjectContext*)context{
    NSError *error = nil;
    BOOL success = [context save:&error];
    if(!success){
        NSLog(@"Core data:Failed to save data %@",error.localizedDescription);
        return nil;
    }
    return object;
}
-(NSArray*)select:(NSString*)predicateStr EntityName:(NSString*)entityName{
    NSManagedObjectContext* context = [self sharedContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    
    if(predicateStr){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateStr];
        request.predicate = predicate;
    }
    NSError *error = nil;
    NSArray *objs = [context executeFetchRequest:request error:&error];
    if(error){
        NSLog(@"Core data select error: %@",error.localizedDescription);
        return nil;
    }
    return objs;
}
-(BOOL)delete:(NSManagedObject*)object{
    NSManagedObjectContext* context = [self sharedContext];
    [context deleteObject:object];
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
        return false;
    }
    return true;
}
-(BOOL)saveContext:(NSManagedObjectContext*)context{
    NSError *error = nil;
    BOOL success = [context save:&error];
    if(!success){
        NSLog(@"Core data:Failed to save data %@",error.localizedDescription);
        return false;
    }
    return true;
}
@end
