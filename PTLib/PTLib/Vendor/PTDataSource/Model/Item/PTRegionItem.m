//
//  PTRegionItem.m
//  PTLatitude
//
//  Created by so on 15/12/29.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTRegionItem.h"

@implementation PTRegionItem

+ (instancetype)itemWithDictionary:(NSDictionary *)dict {
    PTRegionItem *item = [super itemWithDictionary:dict];
    item.itemID = PTDataSourceStringObjectFromDictionary(dict, @"id");
    item.parentID = PTDataSourceStringObjectFromDictionary(dict, @"parent_id");
    item.name = PTDataSourceStringObjectFromDictionary(dict, @"name");
    return (item);
}

- (instancetype)init {
    self = [super init];
    if(self) {
        _name = nil;
        _parentID = nil;
    }
    return (self);
}

#pragma mark - <NSCopying>
- (id)copyWithZone:(NSZone *)zone {
    PTRegionItem *item = [super copyWithZone:zone];
    item.name = self.name;
    item.parentID = self.parentID;
    item.items = self.items;
    return (item);
}
#pragma mark -

@end
