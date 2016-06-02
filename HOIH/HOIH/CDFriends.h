//
//  Friends.h
//  HOIH
//
//  Created by 钟路成 on 16/6/1.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface CDFriends : NSManagedObject

-(void)setUsername:(NSString*)username Name:(NSString*)name Photo:(NSString*)photo UpdateTime:(NSString*)date;
// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "Friends+CoreDataProperties.h"
