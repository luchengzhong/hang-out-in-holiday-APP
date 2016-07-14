//
//  CDMessageManager.m
//  HOIH
//
//  Created by 钟路成 on 16/7/13.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import "CDMessageManager.h"
#import "CDMessage.h"

@implementation CDMessageManager
static NSString* EntityName = @"CDMessage";
-(NSArray*)getMessageFromCoreData:(NSNumber*)IID{
    NSString *predictStr = [NSString stringWithFormat:@"iid = %@",IID];
    return [super select:predictStr EntityName:EntityName PageNum:0 NumPerPage:-1
   SortDescriptor:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"create_time" ascending:NO]]];
}

-(NSArray*)addMessageFromDicts:(NSArray*)dictArray{
    NSMutableArray *insertArray = [NSMutableArray new];
    for(NSDictionary* dict in dictArray){
        CDMessage *cdMessage;
        NSString *selectStr = [NSString stringWithFormat:@"mid = %ld",[dict[@"MID"] longValue]];
        NSArray *cdList = [super select:selectStr EntityName:EntityName];
        if(cdList && [cdList count]>0)
            continue;
        else
            cdMessage = [NSEntityDescription insertNewObjectForEntityForName:EntityName
                                                         inManagedObjectContext:[super sharedContext]];
        
        [cdMessage setMessageDict:dict];
        [insertArray addObject:cdMessage];

    }
    [super saveContext:[super sharedContext]];
    return insertArray;
}
@end
