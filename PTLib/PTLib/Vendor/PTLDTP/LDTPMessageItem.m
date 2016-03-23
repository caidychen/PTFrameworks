//
//  LDTPMessageItem.m
//  PTAsyncSocket
//
//  Created by so on 15/8/13.
//  Copyright (c) 2015年 so. All rights reserved.
//

#import "LDTPMessageItem.h"
#import "MPMessagePack.h"

id LDTPArrayObjectAtIndex(NSArray *array, NSUInteger index ) {
    if(!array || ![array isKindOfClass:[NSArray class]]) {
        return (nil);
    }
    if(index >= array.count) {
        return (nil);
    }
    return (array[index]);
}

@implementation LDTPMessageItem

+ (instancetype)itemWithActionID:(NSUInteger)actionid
                         timeInt:(NSUInteger)timeInt
                           info1:(NSString *)info1
                           info2:(NSString *)info2
                           info3:(NSString *)info3
                           info4:(NSString *)info4
                           info5:(NSString *)info5 {
    LDTPMessageItem *item = [self item];
    item.actionID = actionid;
    item.timeInt = timeInt;
    item.info1 = info1;
    item.info2 = info2;
    item.info3 = info3;
    item.info4 = info4;
    item.info5 = info5;
    return (item);
}

+ (instancetype)itemWithMessagePackData:(NSData *)data {
    LDTPMessageItem *item = [self item];
    if(!data) {
        return (item);
    }
    NSError *error = nil;
    NSArray *array = [data mp_array:&error];
    if(!array || ![array isKindOfClass:[NSArray class]]) {
        NSLog(@">>>mp un package failed:%@", error);
        return (item);
    }
    item.actionID = [LDTPArrayObjectAtIndex(array, 0) unsignedIntegerValue];
    item.timeInt = [LDTPArrayObjectAtIndex(array, 1) unsignedIntegerValue];
    item.info1 = LDTPArrayObjectAtIndex(array, 2);
    item.info2 = LDTPArrayObjectAtIndex(array, 3);
    item.info3 = LDTPArrayObjectAtIndex(array, 4);
    item.info4 = LDTPArrayObjectAtIndex(array, 5);
    item.info5 = LDTPArrayObjectAtIndex(array, 6);
    return (item);
}

- (instancetype)init {
    self = [super init];
    if(self) {
        _actionID = 0;
        _timeInt = [[NSDate date] timeIntervalSince1970];
        _info1 = @"";
        _info2 = @"";
        _info3 = @"";
        _info4 = @"";
        _info5 = @"";
    }
    return (self);
}

- (NSData *)messagePackData {
    NSArray *arr = @[[NSNumber numberWithUnsignedLong:self.actionID],
                     [NSNumber numberWithUnsignedLong:self.timeInt],
                     self.info1 ? : @"",
                     self.info2 ? : @"",
                     self.info3 ? : @"",
                     self.info4 ? : @"",
                     self.info5 ? : @""];
    NSData *data = [arr mp_messagePack];
    return (data);
}

- (NSString *)description {
    return ([NSString stringWithFormat:@"< %s; actionid = %@; timeInt = %@; info1 = %@; info2 = %@; info3 = %@; info4 = %@; info5 = %@; >", object_getClassName(self), @(self.actionID), @(self.timeInt), self.info1, self.info2, self.info3, self.info4, self.info5]);
}

#pragma mark - <NSCopying>
- (id)copyWithZone:(NSZone *)zone {
    LDTPMessageItem *item = [super copyWithZone:zone];
    item.actionID = self.actionID;
    item.timeInt = self.timeInt;
    item.info1 = self.info1;
    item.info2 = self.info2;
    item.info3 = self.info3;
    item.info4 = self.info4;
    item.info5 = self.info5;
    return (item);
}
#pragma mark -
@end
