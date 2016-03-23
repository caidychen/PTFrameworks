//
//  LDTPAuthItem.m
//  PTAsyncSocket
//
//  Created by so on 15/8/13.
//  Copyright (c) 2015年 so. All rights reserved.
//

#import "LDTPAuthItem.h"
#import "MPMessagePack.h"
#import "LDTPHelper.h"

#define PT_LDTP_SECRET      @"fff1eea145938f0378e9ba39463846f2"     //secret_key

@implementation LDTPAuthItem
@synthesize sign = _sign;

+ (instancetype)itemWithUID:(NSUInteger)uid
                      appID:(NSUInteger)appid
                   deviceID:(NSString *)deviceid
                      token:(NSString *)token {
    LDTPAuthItem *item = [self item];
    item.uid = uid;
    item.appid = appid;
    item.deviceid = deviceid;
    item.token = token;
    return (item);
}

- (instancetype)init {
    self = [super init];
    if(self) {
        _uid = 0;
        _appid = 0;
        _sign = nil;
        _deviceid = @"";
        _token = @"";
    }
    return (self);
}

#pragma mark - getter
- (NSString *)sign {
    if(!_sign) {
        _sign = [LDTPMakeSign(self.uid, self.appid, self.deviceid, self.token, PT_LDTP_SECRET) copy];
    }
    return (_sign);
}
#pragma mark -

- (NSData *)messagePackData {
    NSArray *arr = @[[NSNumber numberWithUnsignedLong:self.uid],
                     [NSNumber numberWithUnsignedLong:self.appid],
                     self.sign ? : @"",
                     self.deviceid ? : @"",
                     self.token ? : @""];
    NSData *data = [arr mp_messagePack];
    return (data);
}

- (NSString *)description {
    return ([NSString stringWithFormat:@"< %s; uid = %@; appid = %@; sign = %@; deviceid = %@; token = %@; >", object_getClassName(self), @(self.uid), @(self.appid), self.sign, self.deviceid, self.token]);
}

#pragma mark - <NSCopying>
- (id)copyWithZone:(NSZone *)zone {
    LDTPAuthItem *item = [super copyWithZone:zone];
    item.uid = self.uid;
    item.appid = self.appid;
    item.deviceid = self.deviceid;
    item.token = self.token;
    return (item);
}
#pragma mark -

@end
