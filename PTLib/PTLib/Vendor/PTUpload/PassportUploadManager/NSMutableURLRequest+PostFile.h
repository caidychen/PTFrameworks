//
//  NSMutableURLRequest+PostFile.h
//  PTLib
//
//  Created by LiLiLiu on 16/3/16.
//  Copyright © 2016年 putao. All rights reserved.
//
/**
 * 原文链接：http://www.jianshu.com/p/44629e5bf986
 在iOS开发中使用POST请求上传文件分为三步：
 1.设置请求行
 2.设置post请求
 3.设置连接方式
 */

#import <Foundation/Foundation.h>

@interface NSMutableURLRequest (PostFile)

+(instancetype)requestWithURL:(NSURL *)url andFilenName:(NSString *)fileName andLocalFilePath:(NSString *)localFilePath;

+(instancetype)requestWithURL:(NSURL *)url andFilenName:(NSString *)fileName andFileData:(NSData *)fileData;

@end
