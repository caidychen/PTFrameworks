//
//  PTAUploadManager.h
//  PTAlbum
//
//  Created by shenzhou on 15/5/7.
//  Copyright (c) 2015年 putao.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTUploadOperation.h"
#import "PTAUploadItem.h"

/**
 *  @brief  完成单张图片上传
 */
extern NSString * const PTAlbumUploadManagerDidUploadOnePhotoNotification;

extern NSString * const PTAlbumUploadManagerDidUploadAllPhotoNotification;

/**
 *  @brief  单张图片上传失败
 */
extern NSString * const PTAlbumUploadManagerUploadFailedOnePhotoNotification;

/**
 *  @brief  manager状态改变
 */
extern NSString * const PTAlbumUploadManagerDidChangeNotification;


typedef NS_OPTIONS(NSUInteger, PTAUploadManagerState) {
    PTAUploadManagerStateNone       = 0,    //
    PTAUploadManagerStateUploading,
    PTAUploadManagerStateFinished,
    PTAUploadManagerStateFailed
};

@class PTAUploadManager;
@protocol PTAUploadManagerDelegate <PTUploadOperationDelegate>
@optional
- (void)uploadManagerDidChange:(PTAUploadManager *)manager;
- (void)uploadManagerDidFinished:(PTAUploadManager *)manager;
@end

@interface PTAUploadManager : NSObject
@property (weak, nonatomic) id <PTAUploadManagerDelegate> delegate;
@property (assign, nonatomic) PTAUploadManagerState state;
@property (nonatomic, strong, readonly) NSMutableArray *taskItems;
@property (nonatomic, strong, readonly) NSMutableArray *uploadedItems;
@property (nonatomic, strong, readonly) NSMutableArray *failedItems;
@property (nonatomic, strong, readonly) NSOperationQueue *queue;
+ (instancetype)manager;
+ (void)cancelAllOperationsAndCleanItems;

+ (void)addUploadItem:(PTAUploadItem *)item;
+ (void)reUploadItem:(PTAUploadItem *)item;
+ (void)addUploadItems:(NSArray *)items;
+ (void)cancelUploadItem:(PTAUploadItem *)item;
@end

