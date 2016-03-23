//
//  PPTPassport.h
//  PTLib
//
//  Created by LiLiLiu on 16/3/17.
//  Copyright © 2016年 putao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPTPassport : NSObject

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




@end
