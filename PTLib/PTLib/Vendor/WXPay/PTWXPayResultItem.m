//
//  PTWXPayResultItem.m
//  PTLatitude
//
//  Created by zhangyi on 16/3/1.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTWXPayResultItem.h"
#import "JSONKit.h"  // 解析json

@implementation PTWXPayResultItem

+ (instancetype)itemWithDict:(NSDictionary *)dict {
    PTWXPayResultItem *item = [super itemWithDict:dict];

    if(!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        if ([dict isKindOfClass:[NSString class]]) {
            dict = [(NSString *)dict objectFromJSONString];
        } else {
            return (item);
        }

    }

    
    item.appId = [dict safeStringForKey:@"appid"];
    item.partnerId = [dict safeStringForKey:@"partnerid"];
    item.nonceStr = [dict safeStringForKey:@"noncestr"];
    item.package = [dict safeStringForKey:@"package"];
    item.prepayId = [dict safeStringForKey:@"prepayid"];
    item.timeStamp = [dict safeStringForKey:@"timestamp"];
    item.sign = [dict safeStringForKey:@"sign"];
    
    
    return (item);
}
@end
