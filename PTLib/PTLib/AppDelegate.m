//
//  AppDelegate.m
//  PTLib
//
//  Created by LiLiLiu on 16/3/11.
//  Copyright © 2016年 putao. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "PTNavigationController.h"


#import "PTShareSDK.h"      // shareSDK
#import "WXApi.h"           //微信SDK头文件(微信支付需要在shareSDK后面，再注册一次)
#import "JPUSHService.h"    // 极光推送
#import <AlipaySDK/AlipaySDK.h> // alipay

//Passport 登录
//#import "PTPassport.h"


@interface AppDelegate ()<WXApiDelegate, WeiboSDKDelegate>

@end

@implementation AppDelegate

- (instancetype)init {
    self = [super init];
    if(self) {
//        [self startApp];
//        [self passportSetting];
        
        //设置页面布局时使用
        [self setPlaceHolderConfig];
    }
    return (self);
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    ViewController *homeVC = [[ViewController alloc] init];
    self.window.rootViewController = [[PTNavigationController alloc] initWithRootViewController:homeVC];
    [self.window makeKeyAndVisible];
    
    // 注册 shareSDK  有微信支付时，一定要先注册shareSDK
    [PTShareSDK registerAppForShareSDK:@"e3fd4f4e6278"
                      registerForWeibo:@"1380419830"
                        weiboAppSecret:@"085b86b08d2d71056c73c314a8e1034b"
                      weiboRedirectUri:@"http://www.putao.com"
                           weChatAppId:@"wx46c90751eea478fe"
                       weChatAppSecret:@"64020361b8ec4c99936c0e3999a9f249"
                               QQAppid:@"1104918347"
                              QQAppKey:@"PsfCbfCGvgmRU6Ge"
                              delegate:self
     ];
    
    
    //注册微信(为了使用微信支付)
    [WXApi registerApp:@"wx46c90751eea478fe" withDescription:@"weidu"];

    // 注册JPush
    //jpush设置
    [JPUSHService setupWithOption:launchOptions
                           appKey:@"JPushAppKey"
                          channel:@"appStore"
                 apsForProduction:YES];
    [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                      UIUserNotificationTypeSound |
                                                      UIUserNotificationTypeAlert)
                                          categories:nil];
    
    [JPUSHService handleRemoteNotification:[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]];
    [JPUSHService setDebugMode];    // 打开Jpush日志
//    [JPUSHService setLogOFF];       // 关闭Jpush日志
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // 在app进入时候，把角标清零
    [UIApplication sharedApplication].applicationIconBadgeNumber =0;
    [JPUSHService resetBadge];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -- 布局全局设置代码
- (void)setPlaceHolderConfig{
    //using it for size debug
    [MMPlaceHolderConfig defaultConfig].lineColor = [UIColor orangeColor];  //内部尺寸线颜色
    [MMPlaceHolderConfig defaultConfig].lineWidth = 0.5;                   //内部尺寸线宽
    [MMPlaceHolderConfig defaultConfig].arrowSize = 5;                     //内部箭头尺寸
    [MMPlaceHolderConfig defaultConfig].backColor = [UIColor clearColor];  //内部遮罩色
    [MMPlaceHolderConfig defaultConfig].frameWidth = 0.5;                  //外边框宽度
    
    //using it to control global visible
    [MMPlaceHolderConfig defaultConfig].visible = YES;                    //是否有效
}

#pragma mark - PTPassport
- (void)passportSetting{
//    [PTPassport setUpPassportWithClientType:@"1"
//                                 platformID:@"1"
//                                   deviceID:[PTUtilTool getDeviceID]
//                                      appID:PTLatitudePassportAppID
//                                    version:[PTUtilTool getAppVersion]
//                                  secretKey:PTLatitudePassportAppSecretKey
//                              baseURLString:PTLatitudePassportServiceBaseURL];
}

#pragma mark -- 跳回App
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    if ([url.scheme isEqualToString:@"wx46c90751eea478fe"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    if ([url.scheme isEqualToString:@"wb1380419830"]) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    if ([url.scheme isEqualToString:@"QQ41DBB74B"]) {
        
    }
    return NO;
}

- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options {
    // iOS 9.0
    if ([url.scheme isEqualToString:@"wx46c90751eea478fe"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    if ([url.scheme isEqualToString:@"wb1380419830"]) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    if ([url.scheme isEqualToString:@"QQ41DBB74B"]) {
        
    }
    
    return NO;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    //如果极简开发包不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给开 发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic) {
                                                      //                                                      NSLog(@"AppDelegate safepay Result = %@",resultDic);
                                                  }]; }
    if ([url.host isEqualToString:@"platformapi"]){ //支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //            NSLog(@"AppDelegate platformapi Result = %@",resultDic);
        }];
    }
    
    if ([url.scheme isEqualToString:@"wx46c90751eea478fe"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    if ([url.scheme isEqualToString:@"wb1380419830"]) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    if ([url.scheme isEqualToString:@"QQ41DBB74B"]) {
        
    }
    
    return NO;
}
#pragma mark -

#pragma mark -- 微信支付
- (void)onResp:(BaseResp*)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *respone = (PayResp *)resp;
        NSDictionary *userInfoDic = [NSDictionary dictionaryWithObject:respone forKey:@"info"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PayRespCallBack" object:nil userInfo:userInfoDic];
        
        switch (respone.errCode) {
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                break;
            case WXErrCodeUserCancel:
                
                NSLog(@"用户取消");
                break;
                
            default:
                NSLog(@"支付失败，retcode=%d", respone.errCode);
                break;
        }
    }
}
#pragma mark -

#pragma mark -- JPush
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
    [JPUSHService setAlias:@"uid"
          callbackSelector:nil
                    object:nil];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [JPUSHService handleRemoteNotification:userInfo];
    //    NSLog(@"收到通知:%@", [self logDic:userInfo]);
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler: (void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    //    NSLog(@"收到通知:%@", [self logDic:userInfo]);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"JPushRecevieRemoteNotification" object:nil userInfo:userInfo];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    // 通过地理位置接收的推送
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}
#pragma mark -

@end
