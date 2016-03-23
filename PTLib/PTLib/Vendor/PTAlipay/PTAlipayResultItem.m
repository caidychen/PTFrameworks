//
//  PTAlipayResultItem.m
//  PTLatitude
//
//  Created by LiLiLiu on 15/12/16.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTAlipayResultItem.h"

@implementation PTAlipayResultItem


#pragma mark - 解析服务器返回 JSON 数据的方法
+ (instancetype)itemWithDict:(NSDictionary *)dict {
    PTAlipayResultItem *item = [super itemWithDict:dict];
    if(!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return (item);
    }
    
    item.memo = [dict safeStringForKey:@"memo"];
    item.result = [dict safeStringForKey:@"result"];
    item.resultStatus = [dict safeStringForKey:@"resultStatus"];
    
    return (item);
}

- (instancetype)init {
    self = [super init];
    if(self) {
        _memo = _result = _resultStatus = nil;
    }
    return (self);
}


#pragma mark - <NSCopying>
- (id)copyWithZone:(nullable NSZone *)zone{
    PTAlipayResultItem *item = [super copyWithZone:zone];
    item.memo = self.memo;
    item.result = self.result;
    item.resultStatus = self.resultStatus;
    
    return (item);
}
#pragma mark -

@end
