//
//  PassportMacro.h
//  PTLib
//
//  Created by LiLiLiu on 16/3/13.
//  Copyright © 2016年 putao. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Passport_HEIGHT_STATUS                   20
#define Passport_HEIGHT_NAV                      44
#define Passport_HEIGHT_BAR                      49

#define Passport_Screenwidth [UIScreen mainScreen].bounds.size.width
#define Passport_Screenheight [UIScreen mainScreen].bounds.size.height


//葡萄纬度主题色
#define Passport_THEME_COLOR                     [UIColor colorWithHexString:@"985ec9"]
//输入框分隔线颜色
#define Passport_TEXT_INPUT_LINE_COLOR           [UIColor colorWithHexString:@"E1E1E1"]

#define Passport_phoneNumberMaxLength            11
#define Passport_passwordMinLength               6
#define Passport_passwordMaxLength               18
#define Passport_imageCodeLength                 4
#define Passport_verifyLength                    4

//提示语
#define Passport_RESPONSE_ERROR_MSG           @"你的网络不给力哦！"
#define Passport_TEXT_NICKNAME_FAIL              @"设置2-24字内的昵称"
#define Passport_LENGHT_NICK_NOR                 2
#define Passport_LENGHT_NICK_MAX                 24