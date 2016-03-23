//
//  PTPassport.h
//  kidsPlay
//
//  Created by so on 15/10/30.
//  Copyright (c) 2015年 so. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTPassportError.h"
#import "PTPassportResponseItem.h"

static NSString *PassportLoginNotification = @"PassportLoginNotification";
static NSString *PassportLogoutNotification = @"PassportLogoutNotification";

typedef void (^PTPassportSuccessBlock)(PTPassportResponseItem *responseItem);
typedef void (^PTPassportFailureBlock)(NSError *error);

@interface PTPassport : NSObject

/**
 *  @brief  设置通用参数，必须在其他方法前调用
 *          该初始化方法适合用于完全从 Passport 获取所有信息
 *          uid、token、nike_name、profile、avatar
 */
+ (void)setUpPassportWithClientType:(NSString *)clientType
                         platformID:(NSString *)platformID
                           deviceID:(NSString *)deviceID
                              appID:(NSString *)appid
                            version:(NSString *)version
                          secretKey:(NSString *)secretKey
                      baseURLString:(NSString *)baseURLString
                     isUploadAvatar:(BOOL) isUpload;

//返回上传相关属性值
+ (BOOL)getIsUploadAvatar;
+ (NSString *)getUploadAppID;
+ (NSString *)getuploadServiceBaseURLString;
+ (NSString *)getuploadBaseURLString;
+ (NSString *)getUploadCheckExistURLString;
+ (NSString *)getUploadGetTokenURLString;
+ (NSString *)getUploadTrueUplpadURLString;


/**
 *  @brief  设置上传头像参数，在需要上传头像的注册流程中使用方法前调用
 *          该初始化方法适合用设置上传图片相关接口信息
 */
+ (void)setUpPassportWithUploadAppID:(NSString *)uploadAppID
                uploadServiceBaseURL:(NSString *)serviceBaseUrl
                       uploadBaseURL:(NSString *)baseUrl
                 uploadCheckExistURL:(NSString *)checkExistUrl
                   uploadGetTokenURL:(NSString *)getTokenUrl
                       trueUploadURL:(NSString *)trueUploadUrl;


/**
 *  @brief  验证手机号是否已经注册
 */
+ (NSURLSession *)passportVerifyPhoneNumberExistWithPhoneNumber:(NSString *)phoneNumber
                                                        success:(PTPassportSuccessBlock)success
                                                        failure:(PTPassportFailureBlock)failure;

/**
 *  @brief  获取图形验证码
 *          register|forget|changephone|checkoldphone|login
 */
+ (NSString *)passportSendImageVerifyCodeWithAction:(NSString *)action;

/**
 *  @brief  发送验证码
 */
+ (NSURLSession *)passportSendVerifyCodeWithPhoneNumber:(NSString *)phoneNumber
                                                 action:(NSString *)action
                                                success:(PTPassportSuccessBlock)success
                                                failure:(PTPassportFailureBlock)failure;

/**
 *  @brief  发送安全验证码(带图形验证码的短信发送接口)
 */
+ (NSURLSession *)passportSafeSendVerifyCodeWithPhoneNumber:(NSString *)phoneNumber
                                                     verify:(NSString *)verify
                                                     action:(NSString *)action
                                                    success:(PTPassportSuccessBlock)success
                                                    failure:(PTPassportFailureBlock)failure;

/**
 *  @brief  注册
 */
+ (NSURLSession *)passportRegisterWithPhoneNumber:(NSString *)phoneNumber
                                         password:(NSString *)password
                                             code:(NSString *)code
                                          success:(PTPassportSuccessBlock)success
                                          failure:(PTPassportFailureBlock)failure;

/**
 *  @brief  登录
 */
+ (NSURLSession *)passportLoginWithPhoneNumber:(NSString *)phoneNumber
                                      password:(NSString *)password
                                       success:(PTPassportSuccessBlock)success
                                       failure:(PTPassportFailureBlock)failure;


/**
 *  @brief  安全登录(输入密码错误超过3次,需要输入图形验证码)
 */
+ (NSURLSession *)passportSafeLoginWithPhoneNumber:(NSString *)phoneNumber
                                          password:(NSString *)password
                                            verify:(NSString *)verify
                                           success:(PTPassportSuccessBlock)success
                                           failure:(PTPassportFailureBlock)failure;


/**
 *  @brief  修改密码
 */
+ (NSURLSession *)passportChangePasswordWithUid:(NSString *)uid
                                          token:(NSString *)token
                                    oldPassword:(NSString *)oldPassword
                                       password:(NSString *)password
                                        success:(PTPassportSuccessBlock)success
                                        failure:(PTPassportFailureBlock)failure;

/**
 *  @brief  忘记密码
 */
+ (NSURLSession *)passportForgotPasswordWithPhoneNumber:(NSString *)phoneNumber
                                               password:(NSString *)password
                                                   code:(NSString *)code
                                                success:(PTPassportSuccessBlock)success
                                                failure:(PTPassportFailureBlock)failure;

/**
 *  @brief  验证 Token
 */
+ (NSURLSession *)passportCheckTokenWithUid:(NSString *)uid
                                      token:(NSString *)token
                                    success:(PTPassportSuccessBlock)success
                                    failure:(PTPassportFailureBlock)failure;


/**
 *  @brief  获取昵称
 */
+ (NSURLSession *)passportGetNickNameWithUid:(NSString *)uid
                                       token:(NSString *)token
                                     success:(PTPassportSuccessBlock)success
                                     failure:(PTPassportFailureBlock)failure;

/**
 *  @brief  设置昵称
 */
+ (NSURLSession *)passportSetNickNameWithNickName:(NSString *)nickName
                                              uid:(NSString *)uid
                                            token:(NSString *)token
                                          success:(PTPassportSuccessBlock)success
                                          failure:(PTPassportFailureBlock)failure;


/**
 *  @brief  获取头像
 */
+ (NSURLSession *)passportGetUserAvatarWithUid:(NSString *)uid
                                         token:(NSString *)token
                                       success:(PTPassportSuccessBlock)success
                                       failure:(PTPassportFailureBlock)failure;

/**
 *  @brief  设置头像
 */
+ (NSURLSession *)passportSetUserAvatarWithHash:(NSString *)hash
                                            ext:(NSString *)ext
                                            uid:(NSString *)uid
                                          token:(NSString *)token
                                        success:(PTPassportSuccessBlock)success
                                        failure:(PTPassportFailureBlock)failure;

/**
 *  @brief  取消所有任务
 */
+ (void)cancelAllOperate;

@end
