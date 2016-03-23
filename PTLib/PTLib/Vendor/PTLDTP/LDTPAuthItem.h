//
//  LDTPAuthItem.h
//  PTAsyncSocket
//
//  Created by so on 15/8/13.
//  Copyright (c) 2015年 so. All rights reserved.
//

#import "LDTPBaseItem.h"

@interface LDTPAuthItem : LDTPBaseItem <NSCopying>
@property (assign, nonatomic) NSUInteger uid;
@property (assign, nonatomic) NSUInteger appid;
@property (copy, nonatomic) NSString *deviceid;
@property (copy, nonatomic) NSString *token;
@property (copy, nonatomic, readonly) NSString *sign;

+ (instancetype)itemWithUID:(NSUInteger)uid
                      appID:(NSUInteger)appid
                   deviceID:(NSString *)deviceid
                      token:(NSString *)token;

- (NSData *)messagePackData;

@end
