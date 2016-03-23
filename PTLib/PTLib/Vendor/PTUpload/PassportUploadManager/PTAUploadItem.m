//
//  PTAUploadItem.m
//  PTAlbum
//
//  Created by shenzhou on 15/5/7.
//  Copyright (c) 2015年 putao.Inc. All rights reserved.
//

#import "PTAUploadItem.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "Util.h"
#import "PTAPI.h"
#import "PTPassport.h"

NSString *PTAUploadItemStateDesc(PTAUploadItem *item) {
    if(!item) {
        return (@"");
    }
    switch (item.uploadStatus) {
        case PTUploadOperationStatusPreparing:{
            return (@"等待上传...");
        }break;
        case PTUploadOperationStatusUploading:{
         //   return (@"上传中...");
            /* self.stateLable.text = [NSString stringWithFormat:@"完成%d%%",(int)(progressRatio*100)];*/
            //return [NSString stringWithFormat:@"完成％d%%",(int)(item.progress*100)];
            CGFloat uploadProgress = item.progress;
            NSString *uploadingStr = [NSString stringWithFormat:@"完成%d%%",(int)(uploadProgress*100)];
            return uploadingStr;
        }break;
        case PTUploadOperationStatusFailure:{
            return (@"上传失败");
        }break;
        case PTUploadOperationStatusSuccess:{
            return (@"上传成功");
        }break;
        case PTUploadOperationStatusExist:{
            return (@"已上传到云端，无需上传");
        }break;
        case PTUploadOperationStatusCancel:{
            return (@"取消上传");
        }break;
        case PTUploadOperationStatusNone:
        default:{
            return (@"等待上传...");
        }break;
    }
}

@implementation PTAUploadItem

- (instancetype)init {
    self = [super init];
    if(self) {
        _progress = 0;
        _image = nil;
        self.uploadStatus = PTUploadOperationStatusNone;
        //获取上传 Token 相关路径
        self.tokenBaseURLString = [PTPassport getuploadServiceBaseURLString];
        self.tokenPath = [PTPassport getUploadGetTokenURLString];
        //验证图片 SH1 路径
        self.sha1BaseURLString = [PTPassport getuploadBaseURLString];
        self.sha1Path = [PTPassport getUploadCheckExistURLString];
        //上传图片路径
        self.uploadBaseURLString = [PTPassport getuploadBaseURLString];
        self.uploadPath = [PTPassport getUploadTrueUplpadURLString];
    }
    return (self);
}

@end
