//
//  PTDataSourceOperation.m
//  PTLatitude
//
//  Created by so on 15/12/18.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTDataSourceOperation.h"
#import "PTDataSourceHelper.h"
#import "AFNetworking.h"
#import "ZipArchive.h"
#import "PTDataSourceCheckItem.h"

static NSTimeInterval const PTDataSourceDownloadTimeOut = 30.0f;

@interface PTDataSourceOperation () {
    AFHTTPRequestOperation *_checkRemoteOperation;
    AFHTTPRequestOperation *_downloadOperation;
}
@property (strong, nonatomic) NSDictionary *checkParameters;
@property (strong, nonatomic) PTDataSourceCheckItem *checkItem;
@end


@implementation PTDataSourceOperation

- (instancetype)init {
    self = [super init];
    if(self) {
        _successed = NO;
        _unZipFilePath = nil;
        _downloadProgressBlock = nil;
        _checkRemoteOperation = nil;
        _downloadOperation = nil;
    }
    return (self);
}

- (void)main {
    @autoreleasepool {
        
        self.checkItem = [self checkRemoteDataSource];
        
        if(!self.checkItem || ![self.checkItem isKindOfClass:[PTDataSourceCheckItem class]]) {
            return;
        }
        
        NSString *currentVersion = PTDataSourceCurrentVersion();
        if(currentVersion && [currentVersion integerValue] >= [self.checkItem.last_version integerValue]) {
            _successed = YES;
            return;
        }
        
        NSString *filePath = PTDataSourceFilePath();
        if(!filePath) {
            return;
        }
        NSString *zipFilePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip", self.checkItem.last_version]];
        [[NSFileManager defaultManager] removeItemAtPath:zipFilePath error:nil];
        
        NSString *unZipFilePath = [filePath stringByAppendingPathComponent:self.checkItem.last_version];
        
        //NSLog(@">>>zipFilePath:%@", zipFilePath);
        //NSLog(@">>>unZipFilePath:%@", unZipFilePath);
        
        if([self downloadDataSourceLevel:PTDataSourceURLLevel1 savedPath:zipFilePath]) {
            if([self unArchiveDataSourceZipWithZipFilePath:zipFilePath unZipFilePath:unZipFilePath]) {
                _successed = YES;
                return;
            }
        }
        
        if([self downloadDataSourceLevel:PTDataSourceURLLevel2 savedPath:zipFilePath]) {
            if([self unArchiveDataSourceZipWithZipFilePath:zipFilePath unZipFilePath:unZipFilePath]) {
                _successed = YES;
                return;
            }
        }
        
        if([self downloadDataSourceLevel:PTDataSourceURLLevel3 savedPath:zipFilePath]) {
            if([self unArchiveDataSourceZipWithZipFilePath:zipFilePath unZipFilePath:unZipFilePath]) {
                _successed = YES;
                return;
            }
        }
        
        _successed = NO;
    }
}

- (void)setCheckParameters:(NSDictionary *)checkParameters {
    _checkParameters = [checkParameters copy];
}

- (PTDataSourceCheckItem *)checkRemoteDataSource {
    
    __block BOOL loading = YES;
    
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if(!appVersion) {
        appVersion = @"1.0.0";
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters addEntriesFromDictionary:self.checkParameters];
    [parameters setObject:appVersion forKey:@"app_version"];
    [parameters setObject:PTDataSourceCurrentVersion() forKey:@"version"];
    [parameters setObject:PTDataSourceCurrentVersion() forKey:@"resource_version"];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:
                                                         @"application/json",
                                                         @"application/soap+xml",
                                                         @"text/html",
                                                         @"text/xml",
                                                         @"text/json",
                                                         @"text/javascript", nil];
    __block typeof(PTDataSourceCheckItem *) item = nil;
    _checkRemoteOperation = [manager GET:self.checkURLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        item = [PTDataSourceCheckItem itemWithDictionary:responseObject];
        loading = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        item = nil;
        loading = NO;
    }];
    
    while (loading && ![self isCancelled]) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    return (item);
}

//下载文件
- (BOOL)downloadDataSourceLevel:(PTDataSourceURLLevel)level savedPath:(NSString *)savedPath {
    @autoreleasepool {
        NSString *fileURLString = PTDataSourceURLStringWithItemAndLevel(self.checkItem, PTDataSourceURLLevel1);
        if(!fileURLString) {
            return (NO);
        }
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:fileURLString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:PTDataSourceDownloadTimeOut];
        
        [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
        
        _downloadOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        _downloadOperation.outputStream = [NSOutputStream outputStreamToFileAtPath:savedPath append:YES];
        [_downloadOperation setDownloadProgressBlock:self.downloadProgressBlock];
        
        if(!_downloadOperation) {
            return (NO);
        }
        [_downloadOperation start];
        [_downloadOperation waitUntilFinished];
        
        NSError *error = [_downloadOperation error];
        if(error) {
            //NSLog(@">>>download operation error:%@", [error description]);
            return (NO);
        }
        return (YES);
    }
}

- (BOOL)unArchiveDataSourceZipWithZipFilePath:(NSString *)zipPath unZipFilePath:(NSString *)unZipFilePath {
    @autoreleasepool {
        [[NSFileManager defaultManager] removeItemAtPath:unZipFilePath error:nil];
        
        ZipArchive *unArchive = [[ZipArchive alloc] init];
        if(![unArchive UnzipOpenFile:zipPath]) {
            //NSLog(@"--- 打开ZIP文件失败 ---");
            return (NO);
        }
        if(![unArchive UnzipFileTo:unZipFilePath overWrite:YES]) {
            //NSLog(@"--- 解压ZIP文件失败 ---");
            return (NO);
        }
        [unArchive UnzipCloseFile];
        
        self.unZipFilePath = unZipFilePath;
        
        //记录最近更新的版本
        PTDataSourceSetVersion(self.checkItem.last_version);
        
        //删除zip文件
        NSError *error = nil;
        if(![[NSFileManager defaultManager] removeItemAtPath:zipPath error:&error]) {
            //NSLog(@"--- 删除ZIP文件失败 ---");
        }
        
        return (YES);
    }
}

- (void)cancel {
    if(_checkRemoteOperation) {
        [_checkRemoteOperation cancel];
    }
    if(_downloadOperation) {
        [_downloadOperation cancel];
    }
    [super cancel];
}

@end
