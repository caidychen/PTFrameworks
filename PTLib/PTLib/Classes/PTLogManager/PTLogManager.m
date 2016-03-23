//
//  PTLogManager.m
//  PTImageDemo
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

#import "PTLogManager.h"
#include <sys/sysctl.h>
#include <sys/utsname.h>

@implementation PTLogManager

+(void)print{
    NSString *contents = [NSString stringWithContentsOfFile:PT_LOG_FILEPATH encoding:NSUTF8StringEncoding error:nil];
    printf("\n===================================PTLogManager==================================");
    printf("\n=================================================================================");
    printf("\n%s",[contents UTF8String]);
    printf("\n=================================================================================");
}

+(void)upload{
    NSString *urlString = @"http://www.examplescript.com";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    NSData *fileData = [NSData dataWithContentsOfFile:PT_LOG_FILEPATH];
    [body appendData:fileData];
    [request setHTTPBody:body];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
    }];
}

+(void)clear{
    [@"" writeToFile:PT_LOG_FILEPATH atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

+(NSString *)getProjectBundleName{
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleName = [NSString stringWithFormat:@"%@", [info objectForKey:@"CFBundleName"]];
    return bundleName;
}

+(NSString *)getPlatformName{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return platform;
}

@end
