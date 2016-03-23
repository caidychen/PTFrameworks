//
//  MTAuthItem.m
//  PTLatitude
//
//  Created by LiLiLiu on 15/12/16.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "MTAuthItem.h"

#import "MPMessagePack.h"
#import "MTHelper.h"

#define PT_MT_SECRET      @"499478a81030bb177e578f86410cda8641a22799"     //secret


@implementation MTAuthItem
@synthesize sign = _sign;

+ (instancetype)itemWithDeviceID:(NSString *)deviceid
                           appID:(NSUInteger)appid{
    MTAuthItem *item = [self item];
    item.appid = appid;
    item.deviceid = deviceid;
    return (item);
}

- (instancetype)init {
    self = [super init];
    if(self) {
        _appid = 0;
        _sign = nil;
        _deviceid = @"";
    }
    return (self);
}

#pragma mark - getter
- (NSString *)sign {
    if(!_sign) {
        _sign = [MTMakeSign(self.appid, self.deviceid, PT_MT_SECRET) copy];
    }
    return (_sign);
}
#pragma mark -

- (NSData *)messagePackData {
    //这里打包顺序与文档中的一致
    NSArray *arr = @[self.deviceid ? : @"",
                     [NSNumber numberWithUnsignedLong:self.appid],
                     self.sign ? : @""];
    NSData *data = [arr mp_messagePack];
    return (data);
}

- (NSString *)description {
    return ([NSString stringWithFormat:@"< %s; appid = %@; sign = %@; deviceid = %@; >", object_getClassName(self), @(self.appid), self.sign, self.deviceid]);
}

#pragma mark - <NSCopying>
- (id)copyWithZone:(NSZone *)zone {
    MTAuthItem *item = [super copyWithZone:zone];
    item.appid = self.appid;
    item.deviceid = self.deviceid;
    return (item);
}
#pragma mark -


@end
