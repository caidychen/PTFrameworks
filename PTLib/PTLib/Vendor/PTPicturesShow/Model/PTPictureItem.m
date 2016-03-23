//
//  PTPictureItem.m
//  PTLib
//
//  Created by zhangyi on 16/3/18.
//  Copyright © 2016年 putao. All rights reserved.
//

#import "PTPictureItem.h"

@implementation PTPictureItem

+ (instancetype)itemWithDict:(NSDictionary *)dict {
    PTPictureItem *item = [super itemWithDict:dict];
    if(!SOISDictionaryAndNotNil(dict)) {
        return (item);
    }
    item.picUrl = [dict stringObjectForKey:@"src"];
    item.picText = [dict stringObjectForKey:@"text"];
    return (item);
}

@end
