//
//  PTPassportAPI.h
//  PTLib
//
//  Created by LiLiLiu on 16/3/14.
//  Copyright © 2016年 putao. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @brief  打包类型, 0:内网测试  1.外网测试  2.发布AppStore
 */
#define PT_PASSPORT_API_TYPE         (0)

/***********************************************************************************/
/********************************   Passport相关  ***********************************/
/**
 *  @brief  Passport AppID
 *          线上线下相同
 */
extern NSString * const _Nonnull PT_PROJECT_PassportAppID;
/**
 *  @brief  Passport SecretKey
 */
extern NSString * const _Nonnull PT_PROJECT_PassportAppSecretKey;
/**
 *  @brief  Passport 服务地址
 */
extern NSString * const _Nonnull PT_PROJECT_PassportServiceBaseURL;
/***********************************************************************************/




/***********************************************************************************/
/******************************* 后台修改头像、昵称 ***********************************/
/**
 * @brief 后台服务地址，获取上传 Token 使用
 */
extern NSString * const _Nonnull PT_PROJECT_UserServiceBaseURL;
/**
 *  @brief 注册完善用户信息,头像、昵称、个人简介
 */
extern NSString * const _Nonnull PT_PROJECT_UserRegisterEdit;
/**
 * @brief 查询个人信息 (昵称、头像、个人简介)
 */
extern NSString * const _Nonnull PT_PROJECT_UserEditInfo;




/********************************   图片上传相关   ***********************************/
extern NSString * const _Nonnull PT_PROJECT_UploadAppID;
extern NSString * const _Nonnull PT_PROJECT_UploadBaseURL;

extern NSString * const _Nonnull PT_PROJECT_UploadCheckExist;
extern NSString * const _Nonnull PT_PROJECT_UploadGetToken;
extern NSString * const _Nonnull PT_PROJECT_UploadTrueUpload;
/***********************************************************************************/




