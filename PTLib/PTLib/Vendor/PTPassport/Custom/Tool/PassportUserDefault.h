//
//  PassportUserDefault.h
//  PTLib
//
//  Created by LiLiLiu on 16/3/13.
//  Copyright © 2016年 putao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PassportUserDefault : NSObject


+(NSString*)getStringForKey:(NSString*)key;
+(NSInteger)getIntForkey:(NSString*)key;
+(NSDictionary*)getDictForKey:(NSString*)key;
+(NSArray*)getArrayForKey:(NSString*)key;
+(BOOL)getBoolForKey:(NSString*)key;
+(void)setStringForKey:(NSString*)value key:(NSString*)key;
+(void)setIntForKey:(NSInteger)value key:(NSString*)key;
+(void)setDictForKey:(NSDictionary*)value key:(NSString*)key;
+(void)setArrayForKey:(NSArray*)value key:(NSString*)key;
+(void)setBoolForKey:(BOOL)value key:(NSString*)key;

@end
