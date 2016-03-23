//
//  PTAUploadItem.h
//  PTAlbum
//
//  Created by shenzhou on 15/5/7.
//  Copyright (c) 2015年 putao.Inc. All rights reserved.
//

#import "PPTBaseItem.h"

typedef NS_OPTIONS(NSUInteger, PTUploadOperationStatus) {
    PTUploadOperationStatusNone         = 0,    //未开始
    PTUploadOperationStatusPreparing,           //准备中
    PTUploadOperationStatusUploading,           //上传中
    PTUploadOperationStatusFailure,             //上传失败
    PTUploadOperationStatusSuccess,             //上传成功
    PTUploadOperationStatusExist,               //已经上传过
    PTUploadOperationStatusCancel               //取消上传
};

@class PTAUploadItem;
NSString *PTAUploadItemStateDesc(PTAUploadItem *item);

@class ALAsset;

@interface PTAUploadItem : PPTBaseItem

@property (nonatomic, assign) PTUploadOperationStatus uploadStatus;
@property (nonatomic, assign) double progress;

@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) ALAsset *asset;
@property (nonatomic, copy) NSString *hashString;

@property (nonatomic, copy) NSString *sha1Path;
@property (nonatomic, copy) NSString *sha1BaseURLString;
@property (nonatomic, copy) NSString *tokenPath;
@property (nonatomic, copy) NSString *tokenBaseURLString;
@property (nonatomic, copy) NSString *uploadPath;
@property (nonatomic, copy) NSString *uploadBaseURLString;

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *babyID;

//暂时方案
@property (nonatomic, weak) id handle;

@end
