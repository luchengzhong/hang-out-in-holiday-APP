//
//  CDMessageManager.h
//  HOIH
//
//  Created by 钟路成 on 16/7/13.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import "HOIHDataManager.h"

@interface CDMessageManager : HOIHDataManager

-(NSArray*)getMessageFromCoreData:(NSNumber*)IID;
-(NSArray*)addMessageFromDicts:(NSArray*)dictArray;
@end
