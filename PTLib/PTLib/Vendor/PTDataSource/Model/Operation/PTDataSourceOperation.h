//
//  PTDataSourceOperation.h
//  PTLatitude
//
//  Created by so on 15/12/18.
//  Copyright © 2015年 PT. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PTDataSourceOperationDownloadProgressBlock)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead);

@interface PTDataSourceOperation : NSOperation

/**
 *  @brief  回调block
 */
@property (copy, nonatomic) PTDataSourceOperationDownloadProgressBlock downloadProgressBlock;

/**
 *  @brief  处理结果
 */
@property (assign, nonatomic, getter=isSuccessed) BOOL successed;

/**
 *  @brief  解压后文件目录
 */
@property (copy, nonatomic) NSString *unZipFilePath;

@property (copy, nonatomic) NSString *checkURLString;

- (void)setCheckParameters:(NSDictionary *)checkParameters;

@end
