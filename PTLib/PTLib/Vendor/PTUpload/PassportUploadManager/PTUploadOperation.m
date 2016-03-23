//
//  PTUploadOperation.m
//  PTAlbum
//
//  Created by CHEN KAIDI on 20/8/15.
//  Copyright (c) 2015 putao.Inc. All rights reserved.
//

#import "PTUploadOperation.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AFURLRequestSerialization.h"
#import "PTUploadAssetHelper.h"
#import "Util.h"
#import "PTPassport.h"
#import "NSMutableURLRequest+PostFile.h"



NSString *PTGetSha1String(NSData *data) {
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
}

//NSString *PTAlbumUploadTokenKey(NSString *uid, NSString *babyID) {
//    NSMutableString *tokenKey = [NSMutableString stringWithString:@"PTUploadTokenCache"];
//    if(uid) {
//        [tokenKey appendString:uid];
//        [tokenKey appendString:@"-"];
//    }
//    if(babyID) {
//        [tokenKey appendString:babyID];
//        [tokenKey appendString:@"-"];
//    }
//    return (tokenKey);
//}
//
//void PTAlbumCleanCurrentUploadToken(NSString *uid, NSString *babyID) {
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:PTAlbumUploadTokenKey(uid, babyID)];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}

UIImage *reSizeImage(UIImage *originImage, float width) {
    
    float   scaleSize = width/originImage.size.width;
    
    if (scaleSize < 1) {
        
        UIGraphicsBeginImageContext(CGSizeMake(originImage.size.width * scaleSize, originImage.size.height * scaleSize));
        [originImage drawInRect:CGRectMake(0, 0, originImage.size.width * scaleSize, originImage.size.height * scaleSize)];
        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        return scaledImage;
        
    }
    return originImage;
}

id PTRequestOperationWithTargetURL(NSString *targetURL, NSDictionary *parameter, NSString *method) {
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    requestSerializer.timeoutInterval = 6;
    requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:method URLString:targetURL parameters:parameter error:nil];
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    AFHTTPResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"application/json", @"application/soap+xml", @"text/html", @"text/xml", @"text/json", @"text/javascript", nil];
    
    [requestOperation setResponseSerializer:responseSerializer];
    [requestOperation start];
    [requestOperation waitUntilFinished];
    
    if([requestOperation error]) {
        //NSLog(@">>>area error:%@", [requestOperation error]);
        return nil;
    }
    id responseObject = [requestOperation responseObject];
    
    return responseObject;
}

@interface PTUploadOperation ()
@property (assign, nonatomic, getter=isExist) BOOL exist;
@property (copy, nonatomic) NSString *SHA1Str;
@property (copy, nonatomic) NSString *geoAddressDesc;
@end

@implementation PTUploadOperation

+ (instancetype)operationWithDelegate:(id<PTUploadOperationDelegate>)delegate {
    return ([[self alloc] initWithDelegate:delegate]);
}

- (instancetype)initWithDelegate:(id<PTUploadOperationDelegate>)delegate {
    self = [super init];
    if(self) {
        self.geoAddressDesc = @"";
        _parameter = [[NSMutableDictionary alloc] init];
        self.delegate = delegate;
    }
    return (self);
}

- (void)cancel {
    [self performSelectorOnMainThread:@selector(uploadCancel) withObject:nil waitUntilDone:NO];
    [super cancel];
}

- (void)main {
    @autoreleasepool {
        
        [self performSelectorOnMainThread:@selector(uploadStart) withObject:nil waitUntilDone:NO];
        
        //检测照片是否存在
        self.exist = [self checkIfPhotoExist];
        
        //同步方式拿token
        NSString *token = [self getuploadToken];
        
        //同步方式上传
        [self upLoadPhotoWithToken:token];
    }
}

#pragma mark - action
- (void)uploadStart {
    self.item.uploadStatus = PTUploadOperationStatusPreparing;
    if(self.delegate && [self.delegate respondsToSelector:@selector(uploadOperationDidStart:)]) {
        [self.delegate uploadOperationDidStart:self];
    }
}

- (void)uploadProgress:(double)progress {
    self.item.uploadStatus = PTUploadOperationStatusUploading;
    self.item.progress = progress;
    if(self && self.delegate && [self.delegate respondsToSelector:@selector(uploadOperation:progress:)]) {
        [self.delegate uploadOperation:self progress:progress];
    }
}

- (void)uploadFinished:(NSDictionary *)responseObj {
    self.item.hashString = [responseObj stringObjectForKey:@"hash"];
    self.item.uploadStatus = [self isExist] ? PTUploadOperationStatusExist : PTUploadOperationStatusSuccess;
    if(self.delegate && [self.delegate respondsToSelector:@selector(uploadOperationDidFinish:responseObj:)]) {
        [self.delegate uploadOperationDidFinish:self responseObj:responseObj];
    }
}

- (void)uploadCancel {
    self.item.uploadStatus = PTUploadOperationStatusCancel;
    if(self.delegate && [self.delegate respondsToSelector:@selector(uploadOperationDidCancel:)]) {
        [self.delegate uploadOperationDidCancel:self];
    }
    self.delegate = nil;
}

- (void)uploadFailed {
    self.item.uploadStatus = PTUploadOperationStatusFailure;
    if(self.delegate && [self.delegate respondsToSelector:@selector(uploadOperationDidFailure:)]) {
        [self.delegate uploadOperationDidFailure:self];
    }
}
#pragma mark -

- (BOOL)checkIfPhotoExist {
    @autoreleasepool {
        
        UIImage *image = self.item.image;
        if(!image) {
            UIImage *currentImage = [UPLOAD_ASSETHELPER  getImageFromAsset:self.item.asset type:UPLOAD_ASSET_PHOTO_FULL_RESOLUTION];
            if([self isCancelled]) {
                return (NO);
            }
            //确保sha1 值一致
            image = reSizeImage(currentImage, 1242.0f);
        }
        
        if([self isCancelled]) {
            return (NO);
        }
        NSData *data = UIImageJPEGRepresentation(image, 1.0f);
        if([self isCancelled]) {
            return (NO);
        }
        self.SHA1Str = PTGetSha1String(data);
        if([self isCancelled]) {
            return (NO);
        }
        if (!self.SHA1Str) {
            return (NO);
        }
        //转换sha1值
        NSString *sha1TargetUrl = [NSString stringWithFormat:@"%@%@", self.item.sha1BaseURLString, self.item.sha1Path];
        NSDictionary *parameters = @{@"sha1":self.SHA1Str};
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
        responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"application/json",@"application/soap+xml",@"text/html", @"text/xml",@"text/json",@"text/javascript", nil];
        
        AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
        requestSerializer.timeoutInterval = 15.0f;
        requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
        
        NSError *serializationError = nil;
        NSMutableURLRequest *request = [requestSerializer multipartFormRequestWithMethod:@"POST" URLString:[[NSURL URLWithString:sha1TargetUrl relativeToURL:nil] absoluteString] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            for (NSString *key in [parameters allKeys]) {
                NSString *value = [parameters objectForKey:key];
                [formData appendPartWithFormData:[value dataUsingEncoding:NSUTF8StringEncoding] name:key];
            }
        } error:&serializationError];
        
        if (serializationError) {
            return (NO);
        }
        
        AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:nil failure:nil];
        
        [operation setResponseSerializer:responseSerializer];
        [operation start];
        [operation waitUntilFinished];
        
        if([self isCancelled]) {
            return (NO);
        }
        
        NSDictionary *responseDict = [operation responseObject];
        if(!responseDict || ![responseDict isKindOfClass:[NSDictionary class]]) {
            return (NO);
        }
        NSString *hash = [responseDict safeStringForKey:@"hash"];
        return (hash && [hash isKindOfClass:[NSString class]] && [hash length] > 0);
    }
}

//获取上传照片的token, 一个token有效期30分钟
- (NSString *)getuploadToken {
    @autoreleasepool {
        
        //        NSMutableDictionary *tokenDict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:PTAlbumUploadTokenKey(self.item.userID, self.item.babyID)]];
        //        if(tokenDict) {
        //            NSString *token = [tokenDict safeStringForKey:@"token"];
        //            NSTimeInterval timeInt = [[tokenDict safeNumberForKey:@"timeInt"] doubleValue];
        //            NSTimeInterval nowTimeInt = [[NSDate date] timeIntervalSince1970];
        //            if(token && [token length] > 0 && (nowTimeInt - timeInt < 30 * 60)) {
        //                return (token);
        //            }
        //        } else {
        //            tokenDict = [NSMutableDictionary dictionary];
        //        }
        
        NSString *targetUrl = [NSString stringWithFormat:@"%@%@", self.item.tokenBaseURLString, self.item.tokenPath];
        
        [self.parameter safeSetObject:self.item.userID forKey:@"uid"];
        [self.parameter safeSetObject:self.item.babyID forKey:@"baby_id"];
        [self.parameter safeSetObject:self.geoAddressDesc ? : @"" forKey:@"address"];
        [self.parameter safeSetObject:@"uploadPhotos" forKey:@"type"];
        NSDictionary *reponseTokenObject = PTRequestOperationWithTargetURL(targetUrl, self.parameter, @"GET");
        if([self isCancelled]) {
            return(nil);
        }
        
        NSInteger status = [[reponseTokenObject safeNumberForKey:KEY_PTDEFAULT_STATUS] integerValue];
        if(status != 200) {
            NSLog(@"获取图片上传Token失败");
            return nil;
        }else{
            NSDictionary *tokenDataDic = [reponseTokenObject objectForKey:@"data"];
            NSString *uploadToken = [tokenDataDic objectForKey:@"uploadToken"];
            //            [tokenDict safeSetObject:uploadToken forKey:@"token"];
            //            [tokenDict safeSetObject:@([[NSDate date] timeIntervalSince1970]) forKey:@"timeInt"];
            //
            //            [[NSUserDefaults standardUserDefaults] setObject:tokenDict forKey:PTAlbumUploadTokenKey(self.item.userID, self.item.babyID)];
            //            [[NSUserDefaults standardUserDefaults] synchronize];
            
            return uploadToken;
        }
    }
}

//上传照片--分真上传跟假上传
- (void)upLoadPhotoWithToken:(NSString *)uploadToken {
    
    if(!uploadToken || ![uploadToken isKindOfClass:[NSString class]] || uploadToken.length == 0) {
        [self performSelectorOnMainThread:@selector(uploadFailed) withObject:nil waitUntilDone:NO];
        return;
    }
    
    @autoreleasepool {
        
        //        NSString *babyId = self.item.babyID;
        NSString *photoKey = [self isExist] ? nil : @"file";
        UIImage *image = self.item.image;
        NSDate *date = [NSDate date];
        
        if(!image && self.item.asset) {
            
            ALAsset *asset = self.item.asset;
            if ([asset valueForProperty:ALAssetPropertyDate]) {
                date = [asset valueForProperty:ALAssetPropertyDate];
            }
            
            //存在则读图片
            if (![self isExist]) {
                @autoreleasepool {
                    //服务器不存在,则真上传照片
                    UIImage *currentImage = [UPLOAD_ASSETHELPER  getImageFromAsset:asset type:UPLOAD_ASSET_PHOTO_FULL_RESOLUTION];
                    if([self isCancelled]) {
                        return;
                    }
                    //图片进行压缩
                    image = reSizeImage(currentImage, 1242.0);
                    if([self isCancelled]) {
                        return;
                    }
                }
            }
        }
        
        if([self isCancelled]) {
            return;
        }
        
        //        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        //        NSString *destDateString = [dateFormatter stringFromDate:date];
        
        [self.parameter safeSetObject:[PTPassport getUploadAppID] forKey:@"appid"];
        [self.parameter safeSetObject:self.item.userID forKey:@"x:uid"];
        //        [self.parameter safeSetObject:destDateString forKey:@"x:shoot_time"];
        //        [self.parameter safeSetObject:self.geoAddressDesc ? : @"" forKey:@"x:address"];
        [self.parameter safeSetObject:uploadToken forKey:@"uploadToken"];
        [self.parameter safeSetObject:self.SHA1Str forKey:@"filename"];
        
        NSString *targetUrl = nil;
        NSData *imageData = nil;
        if (photoKey && [photoKey isEqualToString:@"file"]) {
            //真上传Preset
            targetUrl = [NSString stringWithFormat:@"%@%@", self.item.uploadBaseURLString, self.item.uploadPath];
            imageData = UIImageJPEGRepresentation(image, 1.0f);
            if([self isCancelled]) {
                return;
            }
        } else {
            if([self isCancelled]) {
                return;
            }
            //假上传Preset
            [self.parameter safeSetObject:self.SHA1Str forKey:@"sha1"];
            targetUrl = [NSString stringWithFormat:@"%@%@", self.item.uploadBaseURLString, self.item.uploadPath];
        }
        
        //上传请求
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"application/json",@"application/soap+xml",@"text/html", @"text/xml",@"text/json",@"text/javascript", nil];
        manager.requestSerializer.timeoutInterval = 15.0f;
        manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
        
        NSError *serializationError = nil;
        NSMutableURLRequest *request = [manager.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:[[NSURL URLWithString:targetUrl relativeToURL:nil] absoluteString] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            for (NSString *key in [self.parameter allKeys]) {
                NSString *value = [self.parameter objectForKey:key];
                [formData appendPartWithFormData:[value dataUsingEncoding:NSUTF8StringEncoding] name:key];
                
            }
            
            if (imageData) {
                [formData appendPartWithFileData:imageData
                                            name:photoKey
                                        fileName:[NSString stringWithFormat:@"%@.jpg",photoKey]
                                        mimeType:@"image/jpg"];
            }
            
        } error:&serializationError];
        
        if (serializationError) {
            [self performSelectorOnMainThread:@selector(uploadFailed) withObject:nil waitUntilDone:NO];
            return;
        }
        
        AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request
                                                                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                                 
                                                                                 //NSLog(@">>> upload response:%@", responseObject);
                                                                                 /**
                                                                                  * 正确返回
                                                                                  {
                                                                                  ext = jpg;
                                                                                  filename = 71242ea1559591ec6c3901c6468037a3b3608d8c;
                                                                                  hash = 71242ea1559591ec6c3901c6468037a3b3608d8c;
                                                                                  height = 750;
                                                                                  width = 750;
                                                                                  }
                                                                                  
                                                                                  错误返回
                                                                                  {
                                                                                  error = "\U4e0a\U4f20\U5931\U8d25hash=7271a4e7a374dcb4d5c7ec731e4706e53dddcb65 \U6587\U4ef6\U4e0d\U5b58\U5728";
                                                                                  "error_code" = 60004;
                                                                                  request = "/upload";
                                                                                  }
                                                                                  */
                                                                                 NSInteger error_code = 0;
                                                                                 if(responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                                                                                     if ([responseObject safeStringForKey:@"error_code"]) {
                                                                                         error_code = [[responseObject safeStringForKey:@"error_code"] integerValue];
                                                                                     }
                                                                                 }
                                                                                 if(error_code == 0) {
                                                                                     NSLog(@"----------------- upload seccess -----------------");
                                                                                     [self uploadFinished:responseObject];
                                                                                 } else {
                                                                                     [self uploadFailed];
                                                                                 }
                                                                             }
                                                                             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                                 
                                                                                 [self uploadFailed];
                                                                             }];
        
        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            if(totalBytesExpectedToWrite != 0) {
                double totalProgress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
                [self uploadProgress:totalProgress];
            }
        }];
        
        [operation setResponseSerializer:manager.responseSerializer];
        [operation start];
        [operation waitUntilFinished];
    }
}

@end
