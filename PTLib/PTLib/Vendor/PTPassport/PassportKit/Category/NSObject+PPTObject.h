//
//  NSObject+PPTObject.h
//  PTLib
//
//  Created by LiLiLiu on 16/3/14.
//  Copyright © 2016年 putao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray(PPTObject)
- (id)safeObjectAtIndex:(NSInteger)index;
@end


@interface NSMutableArray(PPTObject)
- (void)safeAddObject:(id)anObject;
- (void)safeInsertObject:(id)anObject atIndex:(NSInteger)index;
- (void)safeRemoveObjectAtIndex:(NSInteger)index;
- (void)safeReplaceObjectAtIndex:(NSInteger)index withObject:(id)anObject;
@end


@interface NSDictionary(PPTObject)
- (NSString *)stringObjectForKey:(id <NSCopying>)key;
- (id)safeJsonObjectForKey:(id <NSCopying>)key;
@end


@interface NSMutableDictionary(PPTObject)
- (void)safeSetObject:(id)anObject forKey:(id <NSCopying>)aKey;
@end