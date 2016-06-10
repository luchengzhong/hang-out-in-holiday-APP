//
//  DateUtil.h
//  HOIH
//
//  Created by 钟路成 on 16/6/2.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSObject
+ (NSString*)getCurrentNormalDateString;
+ (NSComparisonResult)compareStringDate1:(NSString*)date1 Date2:(NSString*)date2;
@end
