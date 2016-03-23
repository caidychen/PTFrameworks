//
//  PTWXPayCallBackItem.h
//  PTLatitude
//
//  Created by zhangyi on 16/3/1.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "SOBaseItem.h"

typedef NS_ENUM(NSInteger, callBackType) {
    callBackTypeForSuccess = 1,     // 调用成功
    callBackTypeForNoSupport = 2,   // 不支持微信版本
    callBackTypeForFailure = 3,      // 调用失败
    callBackTypeForNoInstalled = 4      // 未安装微信
};

@interface PTWXPayCallBackItem : SOBaseItem

@property (nonatomic, assign) callBackType  backType;

@end
