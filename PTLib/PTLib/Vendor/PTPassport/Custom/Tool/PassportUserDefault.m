//
//  PassportUserDefault.m
//  PTLib
//
//  Created by LiLiLiu on 16/3/13.
//  Copyright © 2016年 putao. All rights reserved.
//

#import "PassportUserDefault.h"

@implementation PassportUserDefault


+(NSString*)getStringForKey:(NSString*)key
{
    NSString* val = @"";
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) val = [standardUserDefaults stringForKey:key];
    if (val == NULL) val = @"";
    return val;
}

+(NSInteger)getIntForkey:(NSString *)key
{
    NSInteger val = 0;
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) val = [standardUserDefaults integerForKey:key];
    return val;
}

+(NSDictionary*)getDictForKey:(NSString*)key
{
    NSDictionary* val = nil;
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults){
        val = [standardUserDefaults dictionaryForKey:key];
    }
    return val;
}

+(NSArray*)getArrayForKey:(NSString*)key
{
    NSArray* val = nil;
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) val = [standardUserDefaults arrayForKey:key];
    return val;
}

+(BOOL)getBoolForKey:(NSString*)key
{
    BOOL val = FALSE;
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) val = [standardUserDefaults boolForKey:key];
    return val;
}

+(void)setStringForKey:(NSString*)value key:(NSString*)key
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults)
    {
        [standardUserDefaults setObject:value forKey:key];
        [standardUserDefaults synchronize];
    }
}

+(void)setIntForKey:(NSInteger)value key:(NSString*)key
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults)
    {
        [standardUserDefaults setInteger:value forKey:key];
        [standardUserDefaults synchronize];
    }
}

+(void)setDictForKey:(NSDictionary*)value key:(NSString*)key
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults)
    {
        [standardUserDefaults setObject:value forKey:key];
        [standardUserDefaults synchronize];
    }
}

+(void)setArrayForKey:(NSArray*)value key:(NSString*)key
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults)
    {
        [standardUserDefaults setObject:value forKey:key];
        [standardUserDefaults synchronize];
    }
}

+(void)setBoolForKey:(BOOL)value key:(NSString*)key
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults)
    {
        [standardUserDefaults setBool:value forKey:key];
        [standardUserDefaults synchronize];
    }
}

@end
