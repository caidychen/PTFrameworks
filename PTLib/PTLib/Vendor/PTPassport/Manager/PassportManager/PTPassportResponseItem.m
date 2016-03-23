//
//  PTPassportResponseItem.m
//  kidsPlay
//
//  Created by so on 15/10/30.
//  Copyright (c) 2015年 so. All rights reserved.
//

#import "PTPassportResponseItem.h"

NSInteger PTIntegerForKey(NSDictionary *dict, NSString *key) {
    if(!dict || ![dict isKindOfClass:[NSDictionary class]] || !key) {
        return (0);
    }
    id value = [dict objectForKey:key];
    if(!value) {
        return (0);
    }
    if([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        return ([value integerValue]);
    }
    return (0);
}

NSString * PTStringForKey(NSDictionary *dict, NSString *key) {
    if(!dict || ![dict isKindOfClass:[NSDictionary class]] || !key) {
        return (@"");
    }
    id value = [dict objectForKey:key];
    if(!value || [value isKindOfClass:[NSNull class]]) {
        return (@"");
    }
    if([value isKindOfClass:[NSString class]]) {
        return (value);
    }
    return ([NSString stringWithFormat:@"%@", value]);
}


@implementation PTPassportResponseItem

+ (instancetype)item {
    return ([[self alloc] init]);
}

+ (instancetype)itemWithDictionary:(NSDictionary *)dictionary {
    PTPassportResponseItem *item = [self item];
    if(!dictionary || ![dictionary isKindOfClass:[NSDictionary class]] || [dictionary count] == 0) {
        return (item);
    }
    item.errorCode = PTIntegerForKey(dictionary, @"error_code");
    item.msg = PTStringForKey(dictionary, @"msg");
    item.uid = PTStringForKey(dictionary, @"uid");
    item.nickName = PTStringForKey(dictionary, @"nickname");
    item.token = PTStringForKey(dictionary, @"token");
    item.refreshToken = PTStringForKey(dictionary, @"refresh_token");
    item.expireTime = PTStringForKey(dictionary, @"expire_time");
    item.avatar = PTStringForKey(dictionary, @"avatar");
    
    return (item);
}

- (instancetype)init {
    self = [super init];
    if(self) {
        _errorCode = 0;
        _msg = nil;
        _uid = _nickName = _avatar = nil;
        _token = _refreshToken = nil;
        _expireTime = nil;
    }
    return (self);
}

- (NSString *)description {
    NSMutableString *desc = [NSMutableString string];
    [desc appendFormat:@"< %s; ", object_getClassName(self)];
    [desc appendFormat:@"errorCode = %@; ", @(self.errorCode)];
    [desc appendFormat:@"msg = %@; ", self.msg];
    [desc appendFormat:@"uid = %@; ", self.uid];
    [desc appendFormat:@"nickName = %@; ", self.nickName];
    [desc appendFormat:@"token = %@; ", self.token];
    [desc appendFormat:@"refreshToken = %@; ", self.refreshToken];
    [desc appendFormat:@"expireTime = %@; ", self.expireTime];
    [desc appendFormat:@"avatar = %@; ", self.avatar];
    [desc appendString:@">"];
    return (desc);
}

#pragma mark - <NSCopying>
- (id)copyWithZone:(NSZone *)zone {
    PTPassportResponseItem *item = [[[self class] allocWithZone:zone] init];
    item.errorCode = self.errorCode;
    item.msg = self.msg;
    item.uid = self.uid;
    item.nickName = self.nickName;
    item.token = self.token;
    item.refreshToken = self.refreshToken;
    item.expireTime = self.expireTime;
    item.avatar = self.avatar;
    return (item);
}
#pragma mark -

@end
