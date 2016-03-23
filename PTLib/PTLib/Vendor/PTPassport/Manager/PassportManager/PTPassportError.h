//
//  PTPassportError.h
//  kidsPlay
//
//  Created by so on 15/10/30.
//  Copyright (c) 2015年 so. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, PTPassportErrorCode) {
    PTPassportErrorCodeArgument             = 61000,                //参数有误
    PTPassportErrorCodeExistUser            = 61001,                //用户名已存在
    PTPassportErrorCodeNotExistUser         = 61002,                //用户名不存在
    PTPassportErrorCodePasswordError        = 61003,                //密码错误
    PTPassportErrorCodePasswordNotSame      = 61004,                //密码不一致
    PTPassportErrorCodeExistPhone           = 61005,                //手机号已存在
    PTPassportErrorCodeTimeOut              = 61006,                //操作超时
    PTPassportErrorCodeNoPremission         = 61007,                //无权限
    PTPassportErrorCodeWrongVerify          = 61008,                //验证码错误
    PTPassportErrorCodePhoneIsEmpty         = 61009,                //手机号为空
    PTPassportErrorCodeWrongNumber          = 61010,                //手机号错误
    PTPassportErrorCodeMailIsEmpty          = 61011,                //邮箱为空
    PTPassportErrorCodeWrongMail            = 61012,                //邮箱错误
    PTPassportErrorCodePasswordTooLongOrTooShort    = 61013,        //密码过长或过短
    PTPassportErrorCodeHandleFailed         = 61014,                //操作失败
    PTPassportErrorCodeRemindExpire         = 61015,                //重置过期
    PTPassportErrorCodeSamePhoneNumber      = 61016,                //号码未改变
    PTPassportErrorCodeExistEmail           = 61017,                //邮箱已存在
    PTPassportErrorCodeIllegalNickName      = 61018,                //非法的昵称
    PTPassportErrorCodeNickNameExist        = 61019,                //昵称已存在
    PTPassportErrorCodeAppidError           = 61020,                //appid错误
    PTPassportErrorCodeRefreshTokenError    = 61021,                //refreshToken错误
    PTPassportErrorCodeUnknow               = 61022,                //未知错误
    PTPassportErrorCodeExistDeviceID        = 61023,                //设备号已存在
    PTPassportErrorCodeServerIDError        = 61024,                //serverID错误
    PTPassportErrorCodeLoginErrorThreeTimes        = 61025,         //登录错误3次
    PTPassportErrorCodeIllegalFrom          = 60101,                //发送来源不正确
    PTPassportErrorCodeTooManyTimes         = 60103,                //发送次数过多
    PTPassportErrorCodeIdError              = 60104                 //UID错误
};

NSString *PTPassportErrorCodeDescription(PTPassportErrorCode errorCode);

