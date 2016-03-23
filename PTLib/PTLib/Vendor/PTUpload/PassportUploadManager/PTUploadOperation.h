//
//  PTUploadOperation.h
//  PTAlbum
//
//  Created by CHEN KAIDI on 20/8/15.
//  Copyright (c) 2015 putao.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTAUploadItem.h"

@class PTUploadOperation;
@protocol PTUploadOperationDelegate <NSObject>
@optional
- (void)uploadOperationDidStart:(PTUploadOperation *)operation;
- (void)uploadOperationDidCancel:(PTUploadOperation *)operation;
- (void)uploadOperation:(PTUploadOperation *)operation progress:(double)progress;
- (void)uploadOperationDidFinish:(PTUploadOperation *)operation responseObj:(id)responseObj;
- (void)uploadOperationDidFailure:(PTUploadOperation *)operation;
@end

@interface PTUploadOperation : NSOperation
@property (nonatomic, weak) id <PTUploadOperationDelegate> delegate;
@property (nonatomic, strong) NSMutableDictionary *parameter;
@property (nonatomic, strong) PTAUploadItem *item;
+ (instancetype)operationWithDelegate:(id<PTUploadOperationDelegate>)delegate;
- (instancetype)initWithDelegate:(id<PTUploadOperationDelegate>)delegate;
@end


