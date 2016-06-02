//
//  HOIHConfigure.h
//  HOIH
//
//  Created by 钟路成 on 16/6/2.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HOIHConfigure : NSObject

+(HOIHConfigure*)_sharedInstance;

- (NSString *)getConfigueValueForKey:(NSString*)key;
- (BOOL)setConfigueValue:(NSString*)value ForKey:(NSString*)key;
@end
