//
//  LDTPLogCache.m
//  PTAsyncSocket
//
//  Created by so on 15/8/13.
//  Copyright (c) 2015年 so. All rights reserved.
//

#import "LDTPLogCache.h"
#import "LDTPLogCacheOperation.h"

@interface LDTPLogCache () {
    NSOperationQueue *_queue;
}
@end

@implementation LDTPLogCache

- (void)dealloc {
    [_queue cancelAllOperations];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        _queue = [[NSOperationQueue alloc] init];
        [_queue setMaxConcurrentOperationCount:1];
    }
    return (self);
}

- (void)queryAllItemsWithBlock:(LDTPLogCacheBlock)block {
    [self queryItemWithType:LDTPCacheTypeQueryList block:block];
}

- (void)cacheItem:(LDTPMessageItem *)item {
    LDTPLogCacheOperation *operation = [LDTPLogCacheOperation operation];
    operation.type = LDTPCacheTypeIn;
    operation.obj = item;
    [_queue addOperation:operation];
}

- (void)getTopItemWithBlock:(LDTPLogCacheBlock)block {
    [self queryItemWithType:LDTPCacheTypeOut block:block];
}

- (void)queryItemWithType:(LDTPCacheType)type block:(LDTPLogCacheBlock)block {
    LDTPLogCacheOperation *operation = [LDTPLogCacheOperation operation];
    operation.type = type;
    __weak typeof(operation) weak_operation = operation;
    operation.completionBlock = ^(void){
        if(block) {
            block(weak_operation.obj);
        }
    };
    [_queue addOperation:operation];
}

@end
