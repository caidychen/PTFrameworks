//
//  PTLog.m
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

#import "PTLog.h"

@implementation PTLog

void _LogWrite(const char *file, int lineNumber, const char *funcName, NSString *format,...) {
    va_list ap;
    va_start (ap, format);
    format = [format stringByAppendingString:@"\n"];
    NSString *msg = [[NSString alloc] initWithFormat:[NSString stringWithFormat:@"%@",format] arguments:ap];
    va_end (ap);
    NSString *bundleName = [PTLogManager getProjectBundleName];
    NSString *finalLog = [NSString stringWithFormat:@"%s: %s %50s:%3d - %s",[bundleName UTF8String], [[[NSDate date] descriptionWithLocale:[NSLocale currentLocale]] UTF8String],funcName, lineNumber, [msg UTF8String]];
    fprintf(stderr,"%s",[finalLog UTF8String]);
    append(finalLog);
}

void _Log(const char *file, int lineNumber, const char *funcName, NSString *format,...) {
    va_list ap;
    va_start (ap, format);
    format = [format stringByAppendingString:@"\n"];
    NSString *msg = [[NSString alloc] initWithFormat:[NSString stringWithFormat:@"%@",format] arguments:ap];
    va_end (ap);
    NSString *bundleName = [PTLogManager getProjectBundleName];
    NSString *finalLog = [NSString stringWithFormat:@"%s: %s %50s:%3d - %s",[bundleName UTF8String], [[[NSDate date] descriptionWithLocale:[NSLocale currentLocale]] UTF8String],funcName, lineNumber, [msg UTF8String]];
    fprintf(stderr,"%s",[finalLog UTF8String]);
}

void append(NSString *msg){
    // create if needed
    unsigned long long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:PT_LOG_FILEPATH error:nil] fileSize];
    if (fileSize > MAX_LOG_FILE_SIZE) {
        NSFileManager *fileManager= [NSFileManager defaultManager];
        [fileManager removeItemAtPath:PT_LOG_FILEPATH error:nil];
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:PT_LOG_FILEPATH]){
        //fprintf(stderr,"Creating file at %s",[PT_LOG_FILEPATH UTF8String]);
        [[NSData data] writeToFile:PT_LOG_FILEPATH atomically:YES];
        NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:PT_LOG_FILEPATH];
        [handle truncateFileAtOffset:[handle seekToEndOfFile]];
        NSString *deviceInfo = [NSString stringWithFormat:@"Device:%@\niOS:%@\n",[PTLogManager getPlatformName],[UIDevice currentDevice].systemVersion];
        [handle writeData:[deviceInfo dataUsingEncoding:NSUTF8StringEncoding]];
        [handle closeFile];
    }
    // append
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:PT_LOG_FILEPATH];
    [handle truncateFileAtOffset:[handle seekToEndOfFile]];
    [handle writeData:[msg dataUsingEncoding:NSUTF8StringEncoding]];
    [handle closeFile];
}

@end
