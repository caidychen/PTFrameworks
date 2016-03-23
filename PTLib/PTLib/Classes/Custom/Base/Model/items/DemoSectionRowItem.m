//
//  DemoSectionRowItem.m
//  PTLib
//
//  Created by LiLiLiu on 16/3/13.
//  Copyright © 2016年 putao. All rights reserved.
//

#import "DemoSectionRowItem.h"

@implementation DemoSectionRowItem


+ (instancetype)itemWithDict:(NSDictionary *)dict {
    DemoSectionRowItem *item = [super itemWithDict:dict];
    if(!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return (item);
    }
    
    item.demoID = [dict objectForKey:@"demoID"];
    item.rowName = [dict objectForKey:@"rowName"];
    NSString *rowState = [dict objectForKey:@"rowState"];
    if ([rowState isEqualToString:@"NotYetStarted"]) {
        item.rowStateColor = @"CDC5C2";
    }
    if ([rowState isEqualToString:@"Start"]) {
        item.rowStateColor = @"EFCDB8";
    }
    if ([rowState isEqualToString:@"InProgress"]) {
        item.rowStateColor = @"ACE5EE";
    }
    if ([rowState isEqualToString:@"Finish"]) {
        item.rowStateColor = @"30BA8F";
    }
    
    
    return (item);
}


- (instancetype)init {
    self = [super init];
    if(self) {
        _demoID = nil;
        _rowName = nil;
        _rowStateColor = nil;
    }
    return (self);
}

#pragma mark - <NSCopying>
- (id)copyWithZone:(NSZone *)zone {
    DemoSectionRowItem *item = [super copyWithZone:zone];
    item.demoID = self.demoID;
    item.rowName = self.rowName;
    item.rowStateColor = self.rowStateColor;
    
    return (self);
}
#pragma mark -

@end
