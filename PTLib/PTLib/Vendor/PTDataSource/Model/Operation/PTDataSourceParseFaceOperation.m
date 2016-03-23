//
//  PTDataSourceParseFaceOperation.m
//  PTLatitude
//
//  Created by so on 15/12/22.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTDataSourceParseFaceOperation.h"
#import "PTDataSourceHelper.h"
#import <stdio.h>

@implementation PTDataSourceParseFaceOperation

- (instancetype)init {
    self = [super init];
    if(self) {
        _faceItems = nil;
    }
    return (self);
}

- (void)main {
    @autoreleasepool {
        
        NSString *filePath = PTDataSourceFilePath();
        if(!filePath || filePath.length == 0) {
            return;
        }
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if(![fileManager isExecutableFileAtPath:filePath]) {
            return;
        }
        
        NSString *unZipFilePath = [filePath stringByAppendingPathComponent:PTDataSourceCurrentVersion()];
        if(!unZipFilePath || unZipFilePath.length == 0) {
            return;
        }
        
        if(![fileManager isExecutableFileAtPath:unZipFilePath]) {
            return;
        }
        
        NSString *biaoqingPath = [unZipFilePath stringByAppendingPathComponent:@"biaoqing"];
        if(!biaoqingPath || biaoqingPath.length == 0) {
            return;
        }
        
        if(![fileManager isExecutableFileAtPath:biaoqingPath]) {
            return;
        }
        
        NSString *txtPath = [biaoqingPath stringByAppendingPathComponent:@"set.txt"];
        if(!txtPath || txtPath.length == 0) {
            return;
        }
        
        const char *readPath = [txtPath cStringUsingEncoding:NSUTF8StringEncoding];
        FILE *pRead = fopen(readPath, "r+");
        if(!pRead) {
            return;
        }
        
        NSMutableArray *items = [NSMutableArray array];
        
        char line[50];
        while ((1 == fscanf(pRead, "%s\n", line))) {
            @autoreleasepool {
                NSString *lineString = [NSString stringWithCString:line encoding:NSUTF8StringEncoding];
                NSArray *lineComponents = [lineString componentsSeparatedByString:@","];
                NSString *tx = [lineComponents firstObject];
                NSString *nm = [lineComponents lastObject];
                NSString *pt = @"";
                if(nm) {
                    pt = [biaoqingPath stringByAppendingPathComponent:nm];
                }
                PTFaceItem *item = [PTFaceItem itemWithText:tx imageName:nm facePath:pt];
                [items addObject:item];
            }
        }
        fclose(pRead);
        
        [items sortUsingComparator:^NSComparisonResult(PTFaceItem *item1, PTFaceItem *item2) {
            return ([item1.imageName compare:item2.imageName]);
        }];
        
        self.faceItems = [items copy];
    }
}

@end
