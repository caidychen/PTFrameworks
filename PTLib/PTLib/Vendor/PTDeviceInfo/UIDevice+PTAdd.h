//
//  UIDevice+PTAdd.h
//  KangYang
//
//  Created by KangYang on 16/3/15.
//  Copyright © 2016年 KangYang. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef kSystemVersion
#define kSystemVersion [UIDevice systemVersion]
#endif

#ifndef kiOS7Later
#define kiOS7Later (kSystemVersion >= 7)
#endif

#ifndef kiOS8Later
#define kiOS8Later (kSystemVersion >= 8)
#endif

#ifndef kiOS9Later
#define kiOS9Later (kSystemVersion >= 9)
#endif

@interface UIDevice (PTAdd)

//系统版本 (e.g. 9.2.1)
+ (float)systemVersion;

//设备是否为iPad或iPad mini
@property (readonly, nonatomic) BOOL isPad;

//是否模拟器
@property (readonly, nonatomic) BOOL isSimulator;

//是否越狱
@property (readonly, nonatomic) BOOL isJailbroken;

//能不能打电话
@property (readonly, nonatomic) BOOL canMakeCalls;

//设备型号 (e.g. iPhone6,1)
@property (readonly, nonatomic) NSString *machinModel;

//型号名 (e.g. iPhone 6s)
@property (readonly, nonatomic) NSString *machineModelName;

//设备的UUID
@property (readonly, nonatomic) NSString *deviceUUID;

//http请求的头信息userAgent
@property (readonly, nonatomic) NSString *requestHeader;

//WiFi的ip地址
@property (readonly, nonatomic) NSString *ipAddressWiFi;

//WWAN的ip地址
@property (readonly, nonatomic) NSString *ipAddressCell;

//磁盘总空间
@property (readonly, nonatomic) int64_t diskSpace;

//未使用的磁盘
@property (readonly, nonatomic) int64_t diskSpaceFree;

//已使用的磁盘
@property (readonly, nonatomic) int64_t diskSpaceUsed;

@end
