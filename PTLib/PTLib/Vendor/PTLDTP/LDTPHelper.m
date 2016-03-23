//
//  LDTPHelper.m
//  PTAsyncSocket
//
//  Created by so on 15/8/13.
//  Copyright (c) 2015年 so. All rights reserved.
//

#import "LDTPHelper.h"
#import "MPMessagePack.h"
#import "PTUtilTool.h"
#import "PTGloba.h"

void mosaic(char *buff, int buf_size, NSData *sbuf, uint8_t message_type) {
    NSUInteger sbuf_len = [sbuf length];
    bzero((void*)buff, buf_size);
    buff[0] = message_type & 0xFF;
    memcpy((void*)(buff+2), (void*)&sbuf_len, 4);//4bytes for msgpack size
    memcpy((void*)(buff+6), (void*)[sbuf bytes], sbuf_len);
}

NSUInteger LDTPTimeInt() {
    return ((NSUInteger)[[NSDate date] timeIntervalSince1970]);
}

NSString *LDTPChannelAndVersion() {
    return ([NSString stringWithFormat:@"%@;%@", @(PTCurrentTPChannelID), [PTUtilTool getAppVersion]]);
}

NSString *LDTPMakeSign(NSUInteger uid,
                       NSUInteger appid,
                       NSString *deviceid,
                       NSString *token,
                       NSString *secret) {
    NSString *total = [NSString stringWithFormat:@"%@%@%@%@%@", @(uid), @(appid), deviceid, token, secret];
    NSString *sign = [[[total md5] uppercaseString] copy];
    return (sign);
}

NSData * LDTPPackData(LDTPMessageType type, NSData *msg) {
    uint8_t msgSize = [msg length];
    uint8_t bufferSize = msgSize + 6;
    char *buffer = malloc(bufferSize * sizeof(char));
    mosaic(buffer, msgSize, msg, type);
    NSData *data = [NSData dataWithBytes:buffer length:bufferSize];
    if(buffer != NULL) {
        free(buffer);
        buffer = NULL;
    }
    return (data);
}

NSUInteger LDTPParsePackage(char *buff, int buff_len) {
    int sbuf_len = 0;
    memcpy((void*)&sbuf_len, buff+2, 4);
    
    char *packed = malloc(sbuf_len * sizeof(char));
    memcpy((void*)packed, buff+6, sbuf_len);
    
    NSData *data = [NSData dataWithBytes:packed length:sbuf_len];
    if(packed != NULL) {
        free(packed);
        packed = NULL;
    }
    NSError *error = nil;
    NSArray *arr = [data mp_array:&error];
    if(arr && [arr isKindOfClass:[NSArray class]]) {
        return ([[arr firstObject] unsignedIntValue]);
    }
    return (0);
}
