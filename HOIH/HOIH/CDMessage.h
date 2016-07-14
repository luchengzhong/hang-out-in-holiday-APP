//
//  CDMessage.h
//  HOIH
//
//  Created by 钟路成 on 16/7/13.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface CDMessage : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

-(void)setMessageDict:(NSDictionary*)dict;
@end

NS_ASSUME_NONNULL_END

#import "CDMessage+CoreDataProperties.h"
