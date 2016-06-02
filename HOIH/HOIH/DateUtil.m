//
//  DateUtil.m
//  HOIH
//
//  Created by 钟路成 on 16/6/2.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import "DateUtil.h"

@implementation DateUtil
+ (NSString*)getCurrentNormalDateString{
    NSDate *date = [NSDate date];
    return [self formatDateFromDate:date Type:@"Normal"];
}

+(NSString *)formatDateFromDate:(NSDate *)date Type:(NSString *)type{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if ([type isEqualToString:@"Normal"]) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }else{
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    NSString *strToReturn = [dateFormatter stringFromDate:date];
    
    return strToReturn;
}

@end
