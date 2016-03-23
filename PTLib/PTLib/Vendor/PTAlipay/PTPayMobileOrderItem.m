//
//  PTPayMobileOrderItem.m
//  PTLatitude
//
//  Created by LiLiLiu on 15/12/15.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTPayMobileOrderItem.h"

@implementation PTPayMobileOrderItem


#pragma mark - 解析服务器返回 JSON 数据的方法
+ (instancetype)itemWithDict:(NSDictionary *)dict {
    PTPayMobileOrderItem *item = [super itemWithDict:dict];
    if(!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return (item);
    }
    
    item.code = [dict safeStringForKey:@"code"];

    return (item);
}

- (instancetype)init {
    self = [super init];
    if(self) {
        _code= nil;
    }
    return (self);
}


#pragma mark - <NSCopying>
- (id)copyWithZone:(nullable NSZone *)zone{
    PTPayMobileOrderItem *item = [super copyWithZone:zone];
    item.code = self.code;
    
    return (item);
}
#pragma mark -

@end
