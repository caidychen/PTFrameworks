//
//  PTReachability.h
//  PTReachability
//
//  Created by KangYang on 16/3/14.
//  Copyright © 2016年 KangYang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PTSharedReachability [PTReachability sharedInstance]

typedef NS_ENUM(NSInteger, PTReachabilityStatus) {
    PTReachabilityStatusNotReachable = 0,
    PTReachabilityStatusUnknown = 1,
    PTReachabilityStatusWiFi = 2,
    PTReachabilityStatus4G = 3,
    PTReachabilityStatus3G = 4,
    PTReachabilityStatus2G = 5
};

extern NSString *const kPTReachabilityChangedNotification;

typedef void(^PTReachabilityStatusBlock)(PTReachabilityStatus status);

@interface PTReachability : NSObject

+ (instancetype)sharedInstance;

//检测网络时需要用到的请求地址，默认是www.baidu.com
@property (copy, nonatomic) NSString *reachabilityURL;

- (void)reachabilityWithBlock:(PTReachabilityStatusBlock)block;

//定时检测网络变化的时间间隔，默认30秒，不能少于5秒
@property (assign, nonatomic) float autoCheckInterval;

//开启定时检测，不再需要实时监测时调用finishAutoCheck关闭检测。
- (void)startAutoCheck;
- (void)finishAutoCheck;

@end
