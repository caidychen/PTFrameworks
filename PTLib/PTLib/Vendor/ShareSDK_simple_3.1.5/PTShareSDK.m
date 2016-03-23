//
//  PTShareSDK.m
//  PTLib
//
//  Created by zhangyi on 16/3/14.
//  Copyright © 2016年 putao. All rights reserved.
//

#import "PTShareSDK.h"

@implementation PTShareSDK

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (void)registerAppForShareSDK:(NSString *)appKey
              registerForWeibo:(NSString *)weiboAppKey
                weiboAppSecret:(NSString *)weiboSecret
              weiboRedirectUri:(NSString *)weiboRedirectUri
                   weChatAppId:(NSString *)weChatAppId
               weChatAppSecret:(NSString *)weChatAppSecret
                       QQAppid:(NSString *)QQAppId
                      QQAppKey:(NSString *)QQAppKey
                      delegate:(id)delegate {
    
    // shareSDK
    [ShareSDK registerApp:appKey activePlatforms:@[
                                                            @(SSDKPlatformTypeSinaWeibo),
                                                            @(SSDKPlatformTypeCopy),
                                                            @(SSDKPlatformTypeWechat),
                                                            @(SSDKPlatformTypeQQ)
                                                            ]
                 onImport:^(SSDKPlatformType platformType) {
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class] delegate:delegate];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                             break;
                         case SSDKPlatformTypeSinaWeibo:
                             [WeiboSDK enableDebugMode:YES];
                             [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                             break;
                             
                         default:
                             break;
                     }
                 } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                     switch (platformType)
                     {
                         case SSDKPlatformTypeSinaWeibo:
                             //                设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                             [appInfo SSDKSetupSinaWeiboByAppKey:weiboAppKey
                                                       appSecret:weiboSecret
                                                     redirectUri:weiboRedirectUri
                                                        authType:SSDKAuthTypeBoth];
                             break;
                         case SSDKPlatformTypeWechat:
                             [appInfo SSDKSetupWeChatByAppId:weChatAppId
                                                   appSecret:weChatAppSecret];
                             break;
                         case SSDKPlatformTypeQQ:
                             [appInfo SSDKSetupQQByAppId:QQAppId
                                                  appKey:QQAppKey
                                                authType:SSDKAuthTypeBoth];
                             break;
                         default:
                             break;
                     }
                 }];
    
    
}

@end
