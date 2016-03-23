//
//  MTCSNoticeAckItem.m
//  PTLatitude
//
//  Created by LiLiLiu on 15/12/16.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "MTCSNoticeAckItem.h"
#import "MPMessagePack.h"

@implementation MTCSNoticeAckItem

- (instancetype)init {
    self = [super init];
    if(self) {
        _msgId = 0;
    }
    return (self);
}

- (NSData *)messagePackData {
    NSArray *arr = @[[NSNumber numberWithUnsignedLong:self.msgId]];
    NSData *data = [arr mp_messagePack];
    return (data);
}

- (NSString *)description {
    return ([NSString stringWithFormat:@"< %s; msgId = %@; >",object_getClassName(self), @(self.msgId)]);
}

#pragma mark - <NSCopying>
- (id)copyWithZone:(NSZone *)zone {
    MTCSNoticeAckItem *item = [super copyWithZone:zone];
    item.msgId = self.msgId;
    return (item);
}
#pragma mark -

@end
