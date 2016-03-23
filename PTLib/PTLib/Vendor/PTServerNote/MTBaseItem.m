//
//  MTBaseItem.m
//  PTLatitude
//
//  Created by LiLiLiu on 15/12/16.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "MTBaseItem.h"

@implementation MTBaseItem
+ (instancetype)item {
    return ([[self alloc] init]);
}

#pragma mark - <NSCopying>
- (id)copyWithZone:(NSZone *)zone {
    MTBaseItem *item = [[[self class] allocWithZone:zone] init];
    return (item);
}
#pragma mark -
@end
