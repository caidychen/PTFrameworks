//
//  PTZipArchive.h
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

#import <Foundation/Foundation.h>

@interface PTZipArchive : NSObject

/**
 *  Extract zip file to current folder path
 *
 *  @param filePath      Source file path
 *  @param deleteZipFile Whether it should delete the zip file once it's done
 *
 *  @return If succeeded
 */
+(BOOL)extractFileAtPath:(NSString *)filePath deleteZipFile:(BOOL)deleteZipFile;

/**
 *  Extract zip file to designated folder path
 *
 *  @param filePath      Source file path
 *  @param despath       Destination folder where extracted files will be moved to
 *  @param deleteZipFile Whether it should delete the zip file once it's done
 *
 *  @return If succeeded
 */
+(BOOL)extractFileAtPath:(NSString *)filePath to:(NSString *)despath deleteZipFile:(BOOL)deleteZipFile;

/**
 *  Add file to zip
 *  Note: Folder cannot be zipped
 *
 *  @param sourcePath Source file path
 *  @param destPath   Destination folder for zipped file
 *
 *  @return If succeeded
 */
+(BOOL)addFileToZip:(NSString *)sourcePath saveAt:(NSString *)destPath;

/**
 *  Add file to zip with a new zip name
 *
 *  @param sourcePath Source file path
 *  @param destPath   Destination folder path
 *  @param rename     new name
 *
 *  @return If succeeded
 */
+(BOOL)addFileToZip:(NSString *)sourcePath saveAt:(NSString *)destPath rename:(NSString *)rename;

@end
