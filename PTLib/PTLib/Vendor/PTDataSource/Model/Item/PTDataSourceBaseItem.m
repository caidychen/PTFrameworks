//
//  PTDataSourceBaseItem.m
//  PTDataSourceDemo
//
//  Created by so on 15/12/31.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTDataSourceBaseItem.h"

@implementation PTDataSourceBaseItem

+ (instancetype)item {
    return ([[self alloc] init]);
}

+ (instancetype)itemWithDictionary:(NSDictionary *)dict {
    PTDataSourceBaseItem *item = [self item];
    item.itemID = PTDataSourceStringObjectFromDictionary(dict, @"id");
    return (item);
}

- (void)dealloc {
    _itemID = nil;
}

- (instancetype)init {
    self = [super init];
    if(self) {
        _itemID = nil;
    }
    return (self);
}

#pragma mark - <NSCopying>
- (id)copyWithZone:(NSZone *)zone {
    PTDataSourceBaseItem *item = [[[self class] alloc] init];
    item.itemID = self.itemID;
    return (item);
}
#pragma mark -

@end
