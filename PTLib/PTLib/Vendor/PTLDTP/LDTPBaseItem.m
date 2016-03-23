//
//  LDTPBaseItem.m
//  PTAsyncSocket
//
//  Created by so on 15/8/13.
//  Copyright (c) 2015年 so. All rights reserved.
//

#import "LDTPBaseItem.h"

@implementation LDTPBaseItem
+ (instancetype)item {
    return ([[self alloc] init]);
}

#pragma mark - <NSCopying>
- (id)copyWithZone:(NSZone *)zone {
    LDTPBaseItem *item = [[[self class] allocWithZone:zone] init];
    return (item);
}
#pragma mark -
@end
