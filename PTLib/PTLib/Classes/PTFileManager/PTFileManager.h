//
//  PTFileManager.h
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

#import <Foundation/Foundation.h>

@interface PTFileManager : NSObject

/**
 *  Create folder
 *  Note: It will first check if folder already exists before creating it.
 *
 *  @param filePath Destination folder to be created
 *
 *  @return If succeeded
 */
+(BOOL)createFolderAtPath:(NSString *)filePath;

/**
 *  Create file
 *
 *  @param filePath File to be created
 *
 *  @return If succeeded
 */
+(BOOL)createFileAtPath:(NSString *)filePath;

/**
 *  Delete file or folder
 *
 *  @param filePath File path or folder to be deleted
 *
 *  @return If succeeded
 */
+(BOOL)removeItemAtPath:(NSString *)filePath;

/**
 *  Check if such file path exists on disk
 *
 *  @param filePath File path to be checked
 *
 *  @return If exists
 */
+(BOOL)fileExistsAtPath:(NSString *)filePath;

/**
 *  Get root path for NSSearchPathDirectory
 *  Note: In normal cases, we use NSLibraryDirectory for storing cache, downloads or other heavy data, because these are not intended to be shared via iCloud. DO NOT use NSDocumentDirectory / enable File Sharing if you are handling heavy data storage !!! (Apple review team does not appreciate it)
 *
 *  @param searchPath Enum types for NSSearchPathDirectory
 *
 *  @return Folder path
 */
+(NSString *)getRootFolderPathForSearchPathDirectory:(NSSearchPathDirectory)searchPath;

/**
 *  Get array of file/folder path in directory
 *
 *  @param directory Folder path you want to retrieve a list of files from
 *
 *  @return Array of file/folder path
 */
+(NSArray *)getListOfFilePathAtDirectory :(NSString *)directory;

/**
 *  Print list of files
 *
 *  @param directory Folder path you are currently pointing at
 */
+(void)printListOfFilesAtDirectory:(NSString *)directory;

/**
 *  Get file path from NSBundle
 *
 *  @param fileName File name
 *  @param fileType File type
 *
 *  @return File path
 */
+(NSString *)getNSBundlePathForFileName:(NSString *)fileName ofType:(NSString *)fileType;

/**
 *  Get a well-formatted description of folder size
 *
 *  @param folderPath Folder path you are currently pointing at
 *
 *  @return Description of folder size
 */
+(NSString *)folderSize:(NSString *)folderPath;
@end
