//
//  PTPassportError.m
//  kidsPlay
//
//  Created by so on 15/10/30.
//  Copyright (c) 2015年 so. All rights reserved.
//

#import "PTPassportError.h"

NSString *PTPassportErrorCodeDescription(PTPassportErrorCode errorCode) {
    switch (errorCode) {
        case PTPassportErrorCodeArgument:{ return (@"参数有误"); }break;
        case PTPassportErrorCodeExistUser:{ return (@"用户名已存在"); }break;
        case PTPassportErrorCodeNotExistUser:{ return (@"用户名不存在"); }break;
        case PTPassportErrorCodePasswordError:{ return (@"密码错误"); }break;
        case PTPassportErrorCodePasswordNotSame:{ return (@"密码不一致"); }break;
        case PTPassportErrorCodeExistPhone:{ return (@"手机号已存在"); }break;
        case PTPassportErrorCodeTimeOut:{ return (@"操作超时"); }break;
        case PTPassportErrorCodeNoPremission:{ return (@"无权限"); }break;
        case PTPassportErrorCodeWrongVerify:{ return (@"验证码错误"); }break;
        case PTPassportErrorCodePhoneIsEmpty:{ return (@"手机号为空"); }break;
        case PTPassportErrorCodeWrongNumber:{ return (@"手机号错误"); }break;
        case PTPassportErrorCodeMailIsEmpty:{ return (@"邮箱为空"); }break;
        case PTPassportErrorCodeWrongMail:{ return (@"邮箱错误"); }break;
        case PTPassportErrorCodePasswordTooLongOrTooShort:{ return (@"密码过长或过短"); }break;
        case PTPassportErrorCodeHandleFailed:{ return (@"操作失败"); }break;
        case PTPassportErrorCodeRemindExpire:{ return (@"重置过期"); }break;
        case PTPassportErrorCodeSamePhoneNumber:{ return (@"号码未改变"); }break;
        case PTPassportErrorCodeExistEmail:{ return (@"邮箱已存在"); }break;
        case PTPassportErrorCodeIllegalNickName:{ return (@"非法的昵称"); }break;
        case PTPassportErrorCodeNickNameExist:{ return (@"昵称已存在"); }break;
        case PTPassportErrorCodeAppidError:{ return (@"appid错误"); }break;
        case PTPassportErrorCodeRefreshTokenError:{ return (@"refreshToken错误"); }break;
        case PTPassportErrorCodeUnknow:{ return (@"未知错误"); }break;
        case PTPassportErrorCodeExistDeviceID:{ return (@"设备号已存在"); }break;
        case PTPassportErrorCodeServerIDError:{ return (@"serverID错误"); }break;
        case PTPassportErrorCodeLoginErrorThreeTimes:{ return (@"登录密码错误超过3次"); }break;
        case PTPassportErrorCodeIllegalFrom:{ return (@"发送来源不正确"); }break;
        case PTPassportErrorCodeTooManyTimes:{ return (@"发送次数过多"); }break;
        case PTPassportErrorCodeIdError:{ return (@"UID错误"); }break;
        default:{ return (@"未定义的错误码"); }break;
    }
}

