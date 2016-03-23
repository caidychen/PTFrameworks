//
//  LDTPLogCache.h
//  PTAsyncSocket
//
//  Created by so on 15/8/13.
//  Copyright (c) 2015年 so. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LDTPMessageItem.h"

typedef void(^LDTPLogCacheBlock)(id obj);

@interface LDTPLogCache : NSObject
- (void)queryAllItemsWithBlock:(LDTPLogCacheBlock)block;
- (void)cacheItem:(LDTPMessageItem *)item;
- (void)getTopItemWithBlock:(LDTPLogCacheBlock)block;
@end
