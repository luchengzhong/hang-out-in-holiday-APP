//
//  HOIHConfigure.m
//  HOIH
//
//  Created by 钟路成 on 16/6/2.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import "HOIHConfigure.h"

@implementation HOIHConfigure{
    NSMutableDictionary* configues;
    NSString *filePath;
}
static HOIHConfigure *_instance = nil;

+(HOIHConfigure*)_sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        _instance = [[self alloc] initWithContent];
    });
    return _instance;
}

-(id)initWithContent{
    self = [super init];
    if(self){
        filePath = [self dataFilePath];
        configues = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];//[[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        if(!configues){
            configues = [NSMutableDictionary new];
        }
    }
    return self;
    
}
- (NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"HOIHConfigure-inCode"];
}
- (NSString *)getConfigueValueForKey:(NSString*)key{
    return [configues valueForKey:key];;
}
- (BOOL)setConfigueValue:(NSString*)value ForKey:(NSString*)key{
    configues[key] = value;
    return [configues writeToFile:filePath atomically:YES];
}
@end
