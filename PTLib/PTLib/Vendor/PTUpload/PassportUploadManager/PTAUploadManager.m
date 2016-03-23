//
//  PTAUploadManager.m
//  PTAlbum
//
//  Created by shenzhou on 15/5/7.
//  Copyright (c) 2015年 putao.Inc. All rights reserved.
//

#import "PTAUploadManager.h"
#import "PPTKit.h"

NSString * const PTAlbumUploadManagerDidUploadOnePhotoNotification      = @"PTAlbumUploadManagerDidUploadOnePhotoNotification";
NSString * const PTAlbumUploadManagerDidUploadAllPhotoNotification      = @"PTAlbumUploadManagerDidUploadAllPhotoNotification";
NSString * const PTAlbumUploadManagerUploadFailedOnePhotoNotification   = @"PTAlbumUploadManagerUploadFailedOnePhotoNotification";
NSString * const PTAlbumUploadManagerDidChangeNotification              = @"PTAlbumUploadManagerDidChangeNotification";

@interface PTAUploadManager() <PTUploadOperationDelegate>
@property (assign, atomic, getter=isChecking) BOOL checking;
@end

@implementation PTAUploadManager

+ (instancetype)manager{
    static PTAUploadManager *_manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _manager = [[PTAUploadManager alloc] init];
    });
    return (_manager);
}

+ (void)cancelAllOperationsAndCleanItems {
    [[self manager] cancelAllOperationsAndCleanItems];
}

+ (void)addUploadItem:(PTAUploadItem *)item {
    [[self manager] addUploadItem:item];
}

+ (void)reUploadItem:(PTAUploadItem *)item {
    [[self manager] reUploadItem:item];
}

+ (void)addUploadItems:(NSArray *)items {
    [[self manager] addUploadItems:items];
}

+ (void)cancelUploadItem:(PTAUploadItem *)item {
    [[self manager] cancelUploadItem:item];
}

- (void)dealloc {
    [self.queue cancelAllOperations];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        self.state = PTAUploadManagerStateNone;
        self.checking = NO;
        _queue = [[NSOperationQueue alloc] init];
        [_queue setMaxConcurrentOperationCount:1];
        _taskItems = [[NSMutableArray alloc] init];
        _uploadedItems = [[NSMutableArray alloc] init];
        _failedItems = [[NSMutableArray alloc] init];
    }
    return (self);
}

- (void)cancelUploadItem:(PTAUploadItem *)item {
    [self.failedItems addObject:item];
    PTUploadOperation *operation = [PTUploadOperation operationWithDelegate:self];
    operation.item = item;
    [operation cancel];
}

- (void)cancelAllOperationsAndCleanItems {
    [self.queue cancelAllOperations];
    [self.taskItems removeAllObjects];
    [self.uploadedItems removeAllObjects];
    [self.failedItems removeAllObjects];
}

- (void)addUploadItem:(PTAUploadItem *)item {
    [self.taskItems addObject:item];
    [self.failedItems removeObject:item];
    
    PTUploadOperation *operation = [PTUploadOperation operationWithDelegate:self];
    operation.item = item;
    [self.queue addOperation:operation];
}

- (void)reUploadItem:(PTAUploadItem *)item {
    
    if(!item) {
        return;
    }
    
    [self.taskItems removeObject:item];
    [self.uploadedItems removeObject:item];
    [self.failedItems removeObject:item];
    
    [self addUploadItem:item];
}

- (void)addUploadItems:(NSArray *)items {
    for(PTAUploadItem *uploadItem in items) {
        if(uploadItem.asset || uploadItem.image) {
            [self addUploadItem:uploadItem];
        }
    }
}

#pragma mark - setter
- (void)setState:(PTAUploadManagerState)state {
    BOOL changed = _state != state;
    _state = state;
    if(changed) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(uploadManagerDidChange:)]) {
            [self.delegate uploadManagerDidChange:self];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:PTAlbumUploadManagerDidChangeNotification object:@(_state)];
    }
}

- (void)setDelegate:(id<PTAUploadManagerDelegate>)delegate {
    _delegate = delegate;
    if(self.delegate && [self.delegate respondsToSelector:@selector(uploadManagerDidChange:)]) {
        [self.delegate uploadManagerDidChange:self];
    }
    [self checkCurrentOperations];
}
#pragma mark -

#pragma mark - action
- (void)checkCurrentOperations {
    
    if([self isChecking]) {
        return;
    }
    self.checking = YES;
    
    NSUInteger totalCount = self.taskItems.count;
    NSUInteger uploadedCount = self.uploadedItems.count;
    NSUInteger failedCount = self.failedItems.count;
    if(totalCount == uploadedCount) {
        self.state = PTAUploadManagerStateFinished;
    } else if(totalCount == failedCount) {
        self.state = PTAUploadManagerStateFailed;
    } else {
        self.state = PTAUploadManagerStateUploading;
    }
    
    if((totalCount == uploadedCount) && self.taskItems.count > 0) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(uploadManagerDidFinished:)]) {
            [self.delegate uploadManagerDidFinished:self];
        }
        
        [self.taskItems removeAllObjects];
        [[NSNotificationCenter defaultCenter] postNotificationName:PTAlbumUploadManagerDidUploadAllPhotoNotification object:nil];
    }
    
    self.checking = NO;
}
#pragma mark -

#pragma mark - <PTUploadOperationDelegate>
- (void)uploadOperationDidStart:(PTUploadOperation *)operation {
    self.state = PTAUploadManagerStateUploading;
}

- (void)uploadOperationDidCancel:(PTUploadOperation *)operation {
    [self checkCurrentOperations];
    if(self.delegate && [self.delegate respondsToSelector:@selector(uploadOperationDidCancel:)]) {
        [self.delegate uploadOperationDidCancel:operation];
    }
}

- (void)uploadOperation:(PTUploadOperation *)operation progress:(double)progress {
    if(self.delegate && [self.delegate respondsToSelector:@selector(uploadOperation:progress:)]) {
        [self.delegate uploadOperation:operation progress:progress];
    }
}

- (void)uploadOperationDidFinish:(PTUploadOperation *)operation responseObj:(NSDictionary *)responseObj {
    
    PTAUploadItem *item = operation.item;
    item.uploadStatus = PTUploadOperationStatusSuccess;
    
    [self.uploadedItems addObject:operation.item];
    
    if(item && responseObj && [responseObj isKindOfClass:[NSDictionary class]] && [responseObj safeObjectForKey:@"data"]) {
        NSDictionary *dataDict = [responseObj safeObjectForKey:@"data"];
        if(dataDict && [dataDict isKindOfClass:[NSDictionary class]]) {
            item.hashString = [dataDict safeStringForKey:@"hash"];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PTAlbumUploadManagerDidUploadOnePhotoNotification object:item];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(uploadOperationDidFinish:responseObj:)]) {
        [self.delegate uploadOperationDidFinish:operation responseObj:responseObj];
    }
    
    [self checkCurrentOperations];
}

- (void)uploadOperationDidFailure:(PTUploadOperation *)operation {
    [self.failedItems addObject:operation.item];
    [self checkCurrentOperations];
    if(self.delegate && [self.delegate respondsToSelector:@selector(uploadOperationDidFailure:)]) {
        [self.delegate uploadOperationDidFailure:operation];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:PTAlbumUploadManagerUploadFailedOnePhotoNotification object:operation.item];
}
#pragma mark -

@end
