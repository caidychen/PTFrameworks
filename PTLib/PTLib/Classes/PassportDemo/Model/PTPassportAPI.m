//
//  PTPassportAPI.m
//  PTLib
//
//  Created by LiLiLiu on 16/3/14.
//  Copyright © 2016年 putao. All rights reserved.
//

#import "PTPassportAPI.h"

NSString * const _Nonnull PT_PROJECT_PassportAppID               = @"1108";
NSString * const _Nonnull PT_PROJECT_PassportAppSecretKey        = @"c58908e3fa2647a2801fe5417cbcfd8f";


/**
 *  @brief  0:内网测试
 */
#if (PT_PASSPORT_API_TYPE == 0)
NSString * const _Nonnull PT_PROJECT_PassportServiceBaseURL      = @"https://account-api-dev.putao.com";
//NSString * const _Nonnull PT_PROJECT_PassportServiceBaseURL      = @"http://10.1.11.31:9083";

NSString * const _Nonnull PT_PROJECT_UploadBaseURL               = @"http://upload.dev.putaocloud.com"; //图片服务器
NSString * const _Nonnull PT_PROJECT_UserServiceBaseURL           = @"http://api.weidu.start.wang";

/**
 *  @brief  1.外网测试
 */
#elif (PT_PASSPORT_API_TYPE == 1)
NSString * const _Nonnull PT_PROJECT_PassportServiceBaseURL       = @"https://account-api.putao.com";
NSString * const _Nonnull PT_PROJECT_UploadBaseURL                = @"http://upload.putaocloud.com"; //图片服务器
NSString * const _Nonnull PT_PROJECT_UserServiceBaseURL            = @"http://api-weidu.putao.com";

/**
 *  @brief  2.发布AppStore
 */
#elif (PT_PASSPORT_API_TYPE == 2)
NSString * const _Nonnull PT_PROJECT_PassportServiceBaseURL       = @"https://account-api.putao.com";
NSString * const _Nonnull PT_PROJECT_UploadBaseURL                = @"http://upload.putaocloud.com"; //图片服务器
NSString * const _Nonnull PT_PROJECT_UserServiceBaseURL            = @"http://api-weidu.putao.com";

#endif
/***********************************************************************************/





/***********************************************************************************/
/********************************  个人信息相关  ***********************************/
NSString * const _Nonnull PT_PROJECT_UserRegisterEdit            = @"/user/edit";
NSString * const _Nonnull PT_PROJECT_UserEditInfo                = @"/user/info";
/***********************************************************************************/





/***********************************************************************************/
/********************************     上传相关    ***********************************/
NSString * const _Nonnull PT_PROJECT_UploadAppID                  = @"1003";

//图片上传服务器
//内网  http://upload.dev.putaocloud.com/upload
//外网  http://upload.putaocloud.com/upload

//获取图片服务器地址
//内网    http://weidu.file.dev.putaocloud.com/file/
//外网    http://weidu.file.putaocdn.com/file

//获取 上传 Token
NSString * const _Nonnull PT_PROJECT_UploadGetToken               = @"/get/upload/token";
//SHA1 校验
NSString * const _Nonnull PT_PROJECT_UploadCheckExist             = @"/fileinfo";
//图片上传
NSString * const _Nonnull PT_PROJECT_UploadTrueUpload             = @"/upload";

/***********************************************************************************/



