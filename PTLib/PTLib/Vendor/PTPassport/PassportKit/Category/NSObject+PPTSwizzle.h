//
//  NSObject+PPTSwizzle.h
//  PTLib
//
//  Created by LiLiLiu on 16/3/14.
//  Copyright © 2016年 putao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PPTSwizzle)

@end


@interface NSArray (PPTSwizzleMethod)
-(id)safeObjectAtIndex:(NSUInteger)index;
@end


@interface NSDictionary (PPTSwizzleMethod)
-(id)safeObjectForKey:(id)aKey;
-(id)safeNumberForKey:(id)aKey;
-(id)safeStringForKey:(id)aKey;
@end

@interface NSMutableDictionary (PPTSwizzleMethod)
-(void)safeSetObject:(id)anObject forKey:(id)aKey;

@end