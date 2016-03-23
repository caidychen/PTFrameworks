//
//  PTFileManager.m
//
//  Created by CHEN KAIDI on 15/3/2016.
//  Copyright © 2016 Putao. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "PTFileManager.h"

@implementation PTFileManager

+(BOOL)createFolderAtPath:(NSString *)filePath{
    BOOL isDir;
    NSFileManager *fileManager= [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:filePath isDirectory:&isDir]){
        if(![fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:NULL]){
            NSLog(@"Error: Create folder failed %@", filePath);
            return NO;
        }else{
            return YES;
        }
    }
    return YES;
}

+(BOOL)createFileAtPath:(NSString *)filePath{
    return [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
}

+(BOOL)removeItemAtPath:(NSString *)filePath{
    NSFileManager *fileManager= [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:filePath error:NULL];
}

+(BOOL)fileExistsAtPath:(NSString *)filePath{
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

+(NSString *)getRootFolderPathForSearchPathDirectory:(NSSearchPathDirectory)searchPath{
    return NSSearchPathForDirectoriesInDomains(searchPath, NSUserDomainMask, YES)[0];
}

+(NSArray *)getListOfFilePathAtDirectory :(NSString *)directory{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    NSArray* dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directory error:NULL];
    [dirs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *filename = (NSString *)obj;
        NSString *extension = [[filename pathExtension] lowercaseString];
        NSString *filePath = [directory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",filename]];
        if(extension.length>0){
            filePath = [filePath stringByAppendingString:[NSString stringWithFormat:@".%@",extension]];
        }
        if (filePath.length>0) {
            [tempArray addObject:filePath];
        }
    }];
    return tempArray;
}

+(void)printListOfFilesAtDirectory:(NSString *)directory{
    NSArray* dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directory error:NULL];
    NSLog(@"*********************************START***********************************");
    NSLog(@"%@",directory);
    NSLog(@"=========================================================================");
    if (dirs.count == 0) {
        NSLog(@"%@:Empty folder",directory);
    }
    [dirs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *filename = (NSString *)obj;
        NSString *extension = [[filename pathExtension] lowercaseString];
        if (extension.length > 0) {
            NSLog(@"%@ (File Type:%@)",filename,extension);
        }else{
            NSLog(@"%@",filename);
        }
        
    }];
    NSLog(@"********************************END**************************************");
}

+(NSString *)getNSBundlePathForFileName:(NSString *)fileName ofType:(NSString *)fileType{
    return [[NSBundle mainBundle] pathForResource:fileName ofType:fileType];
}

+(NSString *)folderSize:(NSString *)folderPath {
    NSArray *filesArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:folderPath error:nil];
    NSEnumerator *filesEnumerator = [filesArray objectEnumerator];
    NSString *fileName;
    unsigned long long int fileSize = 0;
    while (fileName = [filesEnumerator nextObject]) {
        NSDictionary *fileDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:fileName] error:nil];
        fileSize += [fileDictionary fileSize];
    }
    NSString *folderSizeStr = [NSByteCountFormatter stringFromByteCount:fileSize countStyle:NSByteCountFormatterCountStyleFile];
    return folderSizeStr;
}

@end
