//
//  LDTPLogCacheOperation.m
//  PTAsyncSocket
//
//  Created by so on 15/8/13.
//  Copyright (c) 2015年 so. All rights reserved.
//

#import "LDTPLogCacheOperation.h"
#import "LDTPMessageItem.h"
#import "FMDatabase.h"

#define LDTP_LOG_CACHE_FILE_NAME    @"ldtpLog.db"       //文件名
#define LDTP_LOG_CACHE_TABLE        @"LOG"              //表名
#define LDTP_LOG_CACHE_DATA         @"data"             //字段(唯一字段data)


@interface LDTPLogCacheOperation ()
@property (strong, nonatomic) FMDatabase *database;
@end

@implementation LDTPLogCacheOperation
+ (instancetype)operation {
    return ([[LDTPLogCacheOperation alloc] init]);
}

- (instancetype)init {
    self = [super init];
    if(self) {
        self.database = [FMDatabase databaseWithPath:[self dataBasePath]];
    }
    return (self);
}

- (void)cancel {
    [super cancel];
    [self closeDB];
}

- (void)main {
    @autoreleasepool {
        [self openDB];
        switch (self.type) {
            case LDTPCacheTypeIn:{
                LDTPMessageItem *item = (LDTPMessageItem *)self.obj;
                [self insertData:[item messagePackData]];
            }break;
            case LDTPCacheTypeOut:{
                [self queryTopItem];
            }break;
            case LDTPCacheTypeQueryList:{
                [self queryTable];
            }break;
            default:break;
        }
    }
}

#pragma mark - actions
- (void)openDB {
    if(![self.database open]) {
        NSLog(@">>>打开数据库失败");
        return;
    }
    [self createTable];
}

- (void)closeDB {
    [self.database close];
}

- (void)createTable {
    NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT, %@ DATA)", LDTP_LOG_CACHE_TABLE, LDTP_LOG_CACHE_DATA];
    if(![self.database executeUpdate:sqlCreateTable]) {
        NSLog(@">>>city 建表失败");
    }
}
#pragma mark -

#pragma mark - getter
- (NSString *)dataBasePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths safeObjectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:LDTP_LOG_CACHE_FILE_NAME];
    return (database_path);
}
#pragma mark -

#pragma mark - action
- (void)insertData:(NSData *)data {
    NSString *keyStr = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (?)", LDTP_LOG_CACHE_TABLE, LDTP_LOG_CACHE_DATA];
    if(![self.database executeUpdate:keyStr, data]) {
        NSLog(@">>>data 插入失败");
    }
}

- (void)queryTopItem {
    NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY ID LIMIT 0,1", LDTP_LOG_CACHE_TABLE];
    FMResultSet *result = [self.database executeQuery:queryString];
    if(!result) {
        return;
    }
    if ([result next]) {
        NSData *data = [result dataForColumn:LDTP_LOG_CACHE_DATA];
        [self deleteData:data];
        self.obj = [LDTPMessageItem itemWithMessagePackData:data];
    }
}

- (void)deleteData:(NSData *)data {
    NSString *keyStr = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?", LDTP_LOG_CACHE_TABLE, LDTP_LOG_CACHE_DATA];
    if(![self.database executeUpdate:keyStr, data]) {
        NSLog(@">>>data 删除失败");
    }
}

- (void)queryTable {
    NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM %@", LDTP_LOG_CACHE_TABLE];
    FMResultSet *result = [self.database executeQuery:queryString];
    if(!result) {
        return;
    }
    NSMutableArray *rowItems = [NSMutableArray array];
    while ([result next]) {
        if([self isCancelled]) {
            self.obj = rowItems;
        }
        NSData *data = [result dataForColumn:LDTP_LOG_CACHE_DATA];
        LDTPMessageItem *item = [LDTPMessageItem itemWithMessagePackData:data];
        if(item) {
            [rowItems addObject:item];
        }
    }
}
#pragma mark -

@end
