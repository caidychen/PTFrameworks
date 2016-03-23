//
//  PTZipArchive.m
//  PTImageDemo
//
//  Created by CHEN KAIDI on 16/3/2016.
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

#import "PTZipArchive.h"
#import "ZipArchive.h"

@implementation PTZipArchive

+(BOOL)extractFileAtPath:(NSString *)filePath deleteZipFile:(BOOL)deleteZipFile{
    NSString *destPath = [filePath stringByDeletingLastPathComponent];
    return [self extractFileAtPath:filePath to:destPath deleteZipFile:deleteZipFile];
}

+(BOOL)extractFileAtPath:(NSString *)filePath to:(NSString *)despath deleteZipFile:(BOOL)deleteZipFile{
    NSFileManager *fileManager= [NSFileManager defaultManager];
    NSString *extension = [[filePath pathExtension] lowercaseString];
    if ([extension isEqualToString:@"zip"]) {
        ZipArchive *zipArchive  = [[ZipArchive alloc] init];
        if ([zipArchive UnzipOpenFile:filePath]) {
            NSLog(@"unzip file path :%@",despath);
            BOOL unZipSuccess = [zipArchive UnzipFileTo:despath overWrite:YES];
            [zipArchive UnzipCloseFile];
            if (unZipSuccess) {
                NSLog(@"File %@ unzip successful",filePath);
            }else{
                NSLog(@"File %@ unzip failed",filePath);
            }
            if (deleteZipFile) {
                [fileManager removeItemAtPath:filePath error:NULL];
            }
            return unZipSuccess;
        }else{
            NSLog(@"Unable to open %@. The file might be corrupted or does not exist",[filePath lastPathComponent]);
            return NO;
        }
    }
    NSLog(@"File format not supported");
    return NO;
}

+(BOOL)addFileToZip:(NSString *)sourcePath saveAt:(NSString *)destPath{
    NSString *rename = [[sourcePath lastPathComponent] stringByDeletingPathExtension];
    return [self addFileToZip:sourcePath saveAt:destPath rename:rename];
}

+(BOOL)addFileToZip:(NSString *)sourcePath saveAt:(NSString *)destPath rename:(NSString *)rename{
    ZipArchive* zip = [[ZipArchive alloc] init];
    NSString* zipfile = [destPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",rename]];
    BOOL ret = [zip CreateZipFile2:zipfile];
    ret = [zip addFileToZip:sourcePath newname:[sourcePath lastPathComponent]];//zip
    if( ![zip CloseZipFile2] )
    {
        zipfile = @"";
    }
    return ret;
}

@end
