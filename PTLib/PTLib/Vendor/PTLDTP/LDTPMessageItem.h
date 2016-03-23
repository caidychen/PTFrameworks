//
//  LDTPMessageItem.h
//  PTAsyncSocket
//
//  Created by so on 15/8/13.
//  Copyright (c) 2015年 so. All rights reserved.
//

#import "LDTPBaseItem.h"

@interface LDTPMessageItem : LDTPBaseItem <NSCopying>
@property (assign, nonatomic) NSUInteger actionID;
@property (assign, nonatomic) NSUInteger timeInt;
@property (copy, nonatomic) NSString *info1;
@property (copy, nonatomic) NSString *info2;
@property (copy, nonatomic) NSString *info3;
@property (copy, nonatomic) NSString *info4;
@property (copy, nonatomic) NSString *info5;

+ (instancetype)itemWithActionID:(NSUInteger)actionid
                         timeInt:(NSUInteger)timeInt
                           info1:(NSString *)info1
                           info2:(NSString *)info2
                           info3:(NSString *)info3
                           info4:(NSString *)info4
                           info5:(NSString *)info5;

+ (instancetype)itemWithMessagePackData:(NSData *)data;
- (NSData *)messagePackData;

@end
