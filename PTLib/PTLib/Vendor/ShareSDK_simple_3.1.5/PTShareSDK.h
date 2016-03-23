//
//  PTShareSDK.h
//  PTLib
//
//  Created by zhangyi on 16/3/14.
//  Copyright © 2016年 putao. All rights reserved.
//

#import <Foundation/Foundation.h>

// shareSDK
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>     //腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"                           //微信SDK头文件
#import "WeiboSDK.h"                        //新浪微博SDK头文件

@interface PTShareSDK : NSObject

/**
 *  @brief  参数依次为:shareSDK的appkey;微博的appKey,微博的Secret,微博的redirecturi;微信appid,微信appSecret,QQ的appid,QQ的Appkey
 */
+ (void)registerAppForShareSDK:(NSString *)appKey
              registerForWeibo:(NSString *)weiboAppKey
                weiboAppSecret:(NSString *)weiboSecret
              weiboRedirectUri:(NSString *)weiboRedirectUri
                   weChatAppId:(NSString *)weChatAppId
               weChatAppSecret:(NSString *)weChatAppSecret
                       QQAppid:(NSString *)QQAppId
                      QQAppKey:(NSString *)QQAppKey
                      delegate:(id)delegate ;

@end
