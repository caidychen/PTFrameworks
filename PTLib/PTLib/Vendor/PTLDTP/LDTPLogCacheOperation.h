//
//  LDTPLogCacheOperation.h
//  PTAsyncSocket
//
//  Created by so on 15/8/13.
//  Copyright (c) 2015年 so. All rights reserved.
//

#import <Foundation/Foundation.h>

//先进先出，即先发送最早缓存的item
typedef NS_OPTIONS(NSUInteger, LDTPCacheType) {
    LDTPCacheTypeQueryList      = 0,        //查询表
    LDTPCacheTypeIn,                        //入
    LDTPCacheTypeOut                        //出
};

@interface LDTPLogCacheOperation : NSOperation
@property (assign) LDTPCacheType type;
@property (strong, nonatomic) id obj;
+ (instancetype)operation;
@end
