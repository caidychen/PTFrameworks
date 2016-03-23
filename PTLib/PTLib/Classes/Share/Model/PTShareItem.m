//
//  PTShareItem.m
//  PTLib
//
//  Created by zhangyi on 16/3/14.
//  Copyright © 2016年 putao. All rights reserved.
//

#import "PTShareItem.h"

@implementation PTShareItem

- (instancetype)init {
    self = [super init];
    if (self) {
        _shareImage = [[UIImage alloc] init];
        _thumbImage = [[UIImage alloc] init];
    }
    return self;
}

@end
