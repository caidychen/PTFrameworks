//
//  NSObject+PPTSwizzle.m
//  PTLib
//
//  Created by LiLiLiu on 16/3/14.
//  Copyright © 2016年 putao. All rights reserved.
//

#import "NSObject+PPTSwizzle.h"
#import <objc/runtime.h>

@implementation NSObject (PPTSwizzle)

@end


@implementation NSArray (PPTSwizzleMethod)

-(id)safeObjectAtIndex:(NSUInteger)index
{
    
    if (index < self.count)
    {
        id value = [self objectAtIndex:index];
        if (value == [NSNull null]) {
            return nil;
        }
        return value;
    }
    
    NSLog(@"NSArray Count:%lu,  %@ index:%lu 越界",(unsigned long)self.count ,self,(unsigned long)index);
    return nil;//越界返回为nil
    
}

@end

@implementation NSDictionary (PPTSwizzleMethod)

-(id)safeObjectForKey:(id)aKey
{
    id value = [self objectForKey:aKey];
    if ([value isKindOfClass:[NSNull class]]) {
        value = nil;
    }
    return value;
}

-(id)safeNumberForKey:(id)aKey
{
    id value = [self objectForKey:aKey];
    if ([value isKindOfClass:[NSString class]]) {
        value = @([value integerValue]);
    }else if (![value isKindOfClass:[NSNumber class]]) {
        value = @(0);
    }
    return value;
}

-(id)safeStringForKey:(id)aKey
{
    id value = [self objectForKey:aKey];
    if ([value isKindOfClass:[NSNumber class]]) {
        value = [value stringValue];
    }else if (![value isKindOfClass:[NSString class]]) {
        value = @"";
    }
    return value;
}

@end

@implementation NSMutableDictionary (PPTSwizzleMethod)

-(void)safeSetObject:(id)anObject forKey:(id)aKey{
    
    if (anObject) {
        [self setObject:anObject forKey:aKey];
    }
    else{
        //NSLog(@"Attempting to set nil to key:%@. Insertion aborted.",aKey);
    }
}

@end

