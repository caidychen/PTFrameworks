//
//  DemoSectionItem.m
//  PTLib
//
//  Created by LiLiLiu on 16/3/13.
//  Copyright © 2016年 putao. All rights reserved.
//

#import "DemoSectionItem.h"

#import "DemoSectionRowItem.h"

@implementation DemoSectionItem


+ (instancetype)itemWithDict:(NSDictionary *)dict {
    DemoSectionItem *item = [super itemWithDict:dict];
    if(!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return (item);
    }
    item.sectionName = [dict objectForKey:@"sectionName"];
    
    NSArray *rowDics = [dict safeJsonObjectForKey:@"rows"];

    NSMutableArray *rowItems = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in rowDics) {
        DemoSectionRowItem *rowItem = [DemoSectionRowItem itemWithDict:dictionary];
        [rowItems addObject:rowItem];
    }
    item.rows = [NSArray arrayWithArray:rowItems];
   
    return (item);
}


- (instancetype)init {
    self = [super init];
    if(self) {
        _rows = nil;
        _sectionName = nil;
    }
    return (self);
}

#pragma mark - <NSCopying>
- (id)copyWithZone:(NSZone *)zone {
    DemoSectionItem *item = [super copyWithZone:zone];
    item.rows = self.rows;
    item.sectionName = self.sectionName;
    
    return (self);
}
#pragma mark -

@end
