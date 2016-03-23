//
//  User.h
//  PTLatitude
//
//  Created by LiLiLiu on 15/12/6.
//  Copyright © 2015年 PT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject<NSCopying,NSCoding>

//自动登陆等信息，只用来保存在本地客户端，跟服务端无关
@property (assign, nonatomic) BOOL isRemeberPassword;
@property (assign, nonatomic) BOOL isAutoLogin;
@property (assign, nonatomic) BOOL isLogin;
@property (assign, nonatomic) BOOL isAgreeAgreement;

@property (strong, nonatomic) NSString *userToken;
@property (strong, nonatomic) NSString *userPassword;
@property (strong, nonatomic) NSString *userDeviceID;

@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userNick;
@property (strong, nonatomic) NSString *userAvatar;

//系统时间控制 1399966315050
@property(readonly, nonatomic)NSNumber* systemMillisecondNumber;
@property(strong, nonatomic)NSNumber* serverMillisecondNumber;



- (NSString*)description;

@end
