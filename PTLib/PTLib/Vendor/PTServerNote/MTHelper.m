//
//  MTHelper.m
//  PTLatitude
//
//  Created by LiLiLiu on 15/12/16.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "MTHelper.h"

#import "MPMessagePack.h"
#import "PTUtilTool.h"
#import "PTGloba.h"

void mosaicMT(char *buff, int buf_size, NSData *sbuf, uint8_t message_type) {
    NSUInteger sbuf_len = [sbuf length];
    bzero((void*)buff, buf_size);
    buff[0] = message_type & 0xFF;
    memcpy((void*)(buff+2), (void*)&sbuf_len, 4);//4bytes for msgpack size
    memcpy((void*)(buff+6), (void*)[sbuf bytes], sbuf_len);
}

NSUInteger MTTimeInt() {
    return ((NSUInteger)[[NSDate date] timeIntervalSince1970]);
}


NSString *MTMakeSign(NSUInteger appid,
                     NSString *deviceid,
                     NSString *secret) {
    NSString *total = [NSString stringWithFormat:@"%@%@%@", deviceid, @(appid), secret];
    NSString *sign = [[[total md5] uppercaseString] copy];
    return (sign);
}


NSData * MTPackData(MTMessageType type, NSData *msg) {
    uint8_t msgSize = [msg length];
    uint8_t bufferSize = msgSize + 6;
    char *buffer = malloc(bufferSize * sizeof(char));
    mosaicMT(buffer, msgSize, msg, type);
    NSData *data = [NSData dataWithBytes:buffer length:bufferSize];
    if(buffer != NULL) {
        free(buffer);
        buffer = NULL;
    }
    return (data);
}


//解析 头信息 (不带粘包处理)
NSArray * MTParsePackage(char *buff, int buff_len) {
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
        return arr;
    }
    return (nil);
}



//解析 头信息 (带粘包处理)
NSArray * MTParsePackageInPackSize(char *buff, uint32_t buff_len){
    //    int sbuf_len = 0;
    //    memcpy((void*)&sbuf_len, buff+2, 4);
    //
    //    char *packed = malloc(sbuf_len * sizeof(char));
    //    memcpy((void*)packed, buff+6, sbuf_len);
    
    NSData *data = [NSData dataWithBytes:buff length:buff_len];
    //    if(packed != NULL) {
    //        free(packed);
    //        packed = NULL;
    //    }
    NSError *error = nil;
    NSArray *arr = [data mp_array:&error];
    if(arr && [arr isKindOfClass:[NSArray class]]) {
        return arr;
    }
    return (nil);
}

