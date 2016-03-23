//
//  NSString+Time.m
//  PTLatitude
//
//  Created by LiLiLiu on 16/2/17.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "NSString+Time.h"

@implementation NSString (Time)

+ (NSString *)countTimeTransfoWithString:(NSString *)timeStr{
    NSString *text ;
    
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:[timeStr integerValue]];
    NSTimeInterval timeCount = (-1) *[createDate timeIntervalSinceNow];
    
    NSInteger minute = timeCount / 60;
    NSInteger hour = timeCount / (60 * 60);
    NSInteger day = timeCount / (60 * 60 * 24);
    NSInteger month = timeCount / (60 * 60 * 24 * 30);
    NSInteger year = timeCount / (60 * 60 * 24 * 365);
    
    if (minute <= 1) {
        text = @"刚刚而已";
    } else if ((minute > 1) && (hour < 1)) {
        text = [NSString stringWithFormat:@"%ld分钟前", (long)minute];
    } else if ((hour >= 1) && (day < 1)) {
        text = [NSString stringWithFormat:@"%ld小时前", (long)hour];
    } else if ((day >= 1) && (month < 1)) {
        text = [NSString stringWithFormat:@"%ld天前", (long)day];
    } else if ((month >= 1) && (year < 1)) {
        text = [NSString stringWithFormat:@"%ld月前", (long)month];
    } else {
        text = [NSString stringWithFormat:@"%ld年前", (long)year];
    }
    
    return text;

}

@end
