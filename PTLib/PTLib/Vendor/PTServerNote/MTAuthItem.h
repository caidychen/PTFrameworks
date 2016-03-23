//
//  MTAuthItem.h
//  PTLatitude
//
//  Created by LiLiLiu on 15/12/16.
//  Copyright © 2015年 PT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTBaseItem.h"

/**
 * @brief Socket 链接时保存认证信息的实体类
 */
@interface MTAuthItem : MTBaseItem <NSCopying>

@property (copy, nonatomic) NSString *deviceid;
@property (assign, nonatomic) NSUInteger appid;
@property (copy, nonatomic, readonly) NSString *sign;

+ (instancetype)itemWithDeviceID:(NSString *)deviceid
                      appID:(NSUInteger)appid;

- (NSData *)messagePackData;

@end
