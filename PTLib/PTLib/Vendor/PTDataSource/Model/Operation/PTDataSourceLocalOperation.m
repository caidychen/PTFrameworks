//
//  PTDataSourceLocalOperation.m
//  PTLatitude
//
//  Created by so on 15/12/29.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTDataSourceLocalOperation.h"
#import "PTDataSourceHelper.h"
#import "ZipArchive.h"

@implementation PTDataSourceLocalOperation

- (instancetype)init {
    self = [super init];
    if(self) {
        _bundleFileName = nil;
        _lastVersion = nil;
    }
    return (self);
}

- (void)main {
    @autoreleasepool {
        
        if(!self.bundleFileName || self.bundleFileName.length == 0 || !self.lastVersion || self.lastVersion.length == 0) {
            return;
        }
        
        NSString *currentVersion = PTDataSourceCurrentVersion();
        if(currentVersion && [currentVersion integerValue] > [self.lastVersion integerValue]) {
            return;
        }
        
        NSString *bundleFilePath = [[NSBundle mainBundle] pathForResource:self.bundleFileName ofType:@"zip"];
        if(!bundleFilePath || bundleFilePath.length == 0) {
            return;
        }
        
        NSString *filePath = PTDataSourceFilePath();
        if(!filePath) {
            return;
        }
        NSString *zipFilePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip", self.lastVersion]];
        [[NSFileManager defaultManager] removeItemAtPath:zipFilePath error:nil];
        
        NSError *copyFileError = nil;
        if(![[NSFileManager defaultManager] copyItemAtPath:bundleFilePath toPath:zipFilePath error:&copyFileError]) {
            NSLog(@"copy local bundle file failure, %@", [copyFileError description]);
            return;
        }
        
        NSString *unZipFilePath = [filePath stringByAppendingPathComponent:self.lastVersion];
        
        if(![self unArchiveDataSourceZipWithZipFilePath:zipFilePath unZipFilePath:unZipFilePath]) {
            NSLog(@"unArchive zip file failure");
        }
    }
}

- (BOOL)unArchiveDataSourceZipWithZipFilePath:(NSString *)zipPath unZipFilePath:(NSString *)unZipFilePath {
    @autoreleasepool {
        [[NSFileManager defaultManager] removeItemAtPath:unZipFilePath error:nil];
        
        ZipArchive *unArchive = [[ZipArchive alloc] init];
        if(![unArchive UnzipOpenFile:zipPath]) {
            NSLog(@"--- 打开ZIP文件失败 ---");
            return (NO);
        }
        if(![unArchive UnzipFileTo:unZipFilePath overWrite:YES]) {
            NSLog(@"--- 解压ZIP文件失败 ---");
            return (NO);
        }
        [unArchive UnzipCloseFile];
        
        //记录最近更新的版本
        PTDataSourceSetVersion(self.lastVersion);
        
        //删除zip文件
        NSError *error = nil;
        if(![[NSFileManager defaultManager] removeItemAtPath:zipPath error:&error]) {
            NSLog(@"--- 删除ZIP文件失败 ---");
        }
        
        return (YES);
    }
}

@end
