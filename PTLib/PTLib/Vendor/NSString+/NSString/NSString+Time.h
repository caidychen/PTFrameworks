//
//  NSString+Time.h
//  PTLatitude
//
//  Created by LiLiLiu on 16/2/17.
//  Copyright © 2016年 PT. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @brief 把时间戳转换为 设计需要的格式
 */
@interface NSString (Time)

+ (NSString *)countTimeTransfoWithString:(NSString *)timeStr;

@end
