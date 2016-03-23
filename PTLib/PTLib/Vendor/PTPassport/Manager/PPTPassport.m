//
//  PPTPassport.m
//  PTLib
//
//  Created by LiLiLiu on 16/3/17.
//  Copyright © 2016年 putao. All rights reserved.
//

#import "PPTPassport.h"

#import "PTPassport.h"

@implementation PPTPassport

+ (void)setUpPassportWithClientType:(NSString *)clientType
                         platformID:(NSString *)platformID
                           deviceID:(NSString *)deviceID
                              appID:(NSString *)appid
                            version:(NSString *)version
                          secretKey:(NSString *)secretKey
                      baseURLString:(NSString *)baseURLString
                     isUploadAvatar:(BOOL) isUpload{
    [PTPassport setUpPassportWithClientType:clientType platformID:platformID deviceID:deviceID appID:appid version:version secretKey:secretKey baseURLString:baseURLString isUploadAvatar:isUpload];
}


/**
 *  @brief  设置上传头像参数，在需要上传头像的注册流程中使用方法前调用
 *          该初始化方法适合用设置上传图片相关接口信息
 */
+ (void)setUpPassportWithUploadAppID:(NSString *)uploadAppID
                uploadServiceBaseURL:(NSString *)serviceBaseUrl
                       uploadBaseURL:(NSString *)baseUrl
                 uploadCheckExistURL:(NSString *)checkExistUrl
                   uploadGetTokenURL:(NSString *)getTokenUrl
                       trueUploadURL:(NSString *)trueUploadUrl{
    [PTPassport setUpPassportWithUploadAppID:uploadAppID uploadServiceBaseURL:serviceBaseUrl uploadBaseURL:baseUrl uploadCheckExistURL:checkExistUrl uploadGetTokenURL:getTokenUrl trueUploadURL:trueUploadUrl];
}

@end
