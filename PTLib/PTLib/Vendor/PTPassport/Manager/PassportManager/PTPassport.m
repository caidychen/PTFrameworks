//
//  PTPassport.m
//  kidsPlay
//
//  Created by so on 15/10/30.
//  Copyright (c) 2015年 so. All rights reserved.
//

#import "PTPassport.h"
#import <Security/Security.h>
#import <CommonCrypto/CommonCrypto.h>
#import "NSString+OAURLEncodingAdditions.h"     //登录计算 sign 转码使用
#import "NSString+PPTAdditions.h"

static NSString * const PTPassportAPICheckModile        = @"/api/checkMobile";
static NSString * const PTPassportAPISendMsg            = @"/api/sendMsg";
static NSString * const PTPassportAPISafeSendMsg        = @"/api/safeSendMsg";
static NSString * const PTPassportAPIImageCode          = @"/api/verification";
static NSString * const PTPassportAPIRegister           = @"/api/register";
static NSString * const PTPassportAPILogin              = @"/api/login";
static NSString * const PTPassportAPISafeLogin          = @"/api/safeLogin";
static NSString * const PTPassportAPIChangePassword     = @"/api/changePasswd";
static NSString * const PTPassportAPIForget             = @"/api/forget";

static NSString * const PTPassportAPICheckToken         = @"/api/checkToken";
static NSString * const PTPassportAPIGetNickName        = @"/api/getNickName";
static NSString * const PTPassportAPISetNickName        = @"/api/setNickName";
static NSString * const PTPassportAPIGetUserAvatar      = @"/api/getUserAvatar";
static NSString * const PTPassportAPISetUserAvatar      = @"/api/setUserAvatar";

static NSString * const PTPassportErrorDomain      = @"PTPassportErrorDomain";

void PTDictionarySetStringForKey(NSMutableDictionary *dict, NSString *str, id key) {
    if(!dict || ![dict isKindOfClass:[NSMutableDictionary class]] || !key || !str || ![str isKindOfClass:[NSString class]] || [str length] == 0) {
        return;
    }
    [dict setObject:str forKey:key];
}

NSString * PTPassportMD516(NSString *signString) {
    const char * cStr =[signString UTF8String];
    unsigned char result[16];
    memset(result, 0, sizeof(result));
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

/**
 * @brief sign 生成规则:一个接口如果需要 sign 值，那么把该接口其他所有参数按照 字母表 顺序拼接组合生成 sign
 *        拼接顺序必须为 appid, client_type, device_id, mobile, passwd, platform_id, version
 */
//登录接口
NSString * PTPassportLoginSign(NSString *appid,
                          NSString *clientType,
                          NSString *deviceID,
                          NSString *phoneNumber,
                          NSString *password,
                          NSString *platformID,
                          NSString *version,
                          NSString *secretKey) {
    NSMutableArray *mtlArray = [NSMutableArray array];
    if(appid && [appid length] > 0) {
        [mtlArray addObject:[NSString stringWithFormat:@"appid=%@", appid]];
    }
    if(clientType && [clientType length] > 0) {
        [mtlArray addObject:[NSString stringWithFormat:@"client_type=%@", clientType]];
    }
    if(deviceID && [deviceID length] > 0) {
        [mtlArray addObject:[NSString stringWithFormat:@"device_id=%@", deviceID]];
    }
    if(phoneNumber && [phoneNumber length] > 0) {
        [mtlArray addObject:[NSString stringWithFormat:@"mobile=%@", phoneNumber]];
    }
    if(password && [password length] > 0) {
        [mtlArray addObject:[NSString stringWithFormat:@"passwd=%@", password]];
    }
    if(platformID && [platformID length] > 0) {
        [mtlArray addObject:[NSString stringWithFormat:@"platform_id=%@", platformID]];
    }
    if(version && [version length] > 0) {
        [mtlArray addObject:[NSString stringWithFormat:@"version=%@", version]];
    }
    NSString *sign = [mtlArray componentsJoinedByString:@"&"];
    if(secretKey && [secretKey length] > 0) {
        sign = [sign stringByAppendingString:secretKey];
    }
    sign = [sign stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    sign = [sign stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    sign = PTPassportMD516(sign);
    if(sign) {
        sign = [sign lowercaseString];
    }
    return (sign);
}


/**
 * @brief 带图形验证码的 安全登录接口 sign 生成规则
 *        拼接顺序必须为 appid, client_type, device_id, mobile, passwd, platform_id,verify, version
 */
NSString * PTPassportSafeLoginSign(NSString *action,
                              NSString *appid,
                              NSString *clientType,
                              NSString *deviceID,
                              NSString *phoneNumber,
                              NSString *password,
                              NSString *platformID,
                              NSString *verify,
                              NSString *version,
                              NSString *secretKey) {
    NSMutableArray *mtlArray = [NSMutableArray array];
    if(action && [action length] > 0) {
        [mtlArray addObject:[NSString stringWithFormat:@"action=%@", action]];
    }
    if(appid && [appid length] > 0) {
        [mtlArray addObject:[NSString stringWithFormat:@"appid=%@", appid]];
    }
    if(clientType && [clientType length] > 0) {
        [mtlArray addObject:[NSString stringWithFormat:@"client_type=%@", clientType]];
    }
    if(deviceID && [deviceID length] > 0) {
        [mtlArray addObject:[NSString stringWithFormat:@"device_id=%@", deviceID]];
    }
    if(phoneNumber && [phoneNumber length] > 0) {
        [mtlArray addObject:[NSString stringWithFormat:@"mobile=%@", phoneNumber]];
    }
    if(password && [password length] > 0) {
        [mtlArray addObject:[NSString stringWithFormat:@"passwd=%@", password]];
    }
    if(platformID && [platformID length] > 0) {
        [mtlArray addObject:[NSString stringWithFormat:@"platform_id=%@", platformID]];
    }
    if(verify && [verify length] > 0) {
        [mtlArray addObject:[NSString stringWithFormat:@"verify=%@", verify]];
    }
    if(version && [version length] > 0) {
        [mtlArray addObject:[NSString stringWithFormat:@"version=%@", version]];
    }
    NSString *sign = [mtlArray componentsJoinedByString:@"&"];
    if(secretKey && [secretKey length] > 0) {
        sign = [sign stringByAppendingString:secretKey];
    }
    sign = [sign stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    sign = [sign stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    sign = PTPassportMD516(sign);
    if(sign) {
        sign = [sign lowercaseString];
    }
    return (sign);
}


/**
 * @brief checkToken sign 生成规则
 */
NSString * PTPassportChekcTokenSign(NSString *appid,
                                   NSString *serverid,
                                    NSString *token,
                                    NSString *uid,
                                    NSString *secretKey) {
    NSMutableArray *mtlArray = [NSMutableArray array];
    if(appid && [appid length] > 0) {
        [mtlArray addObject:[NSString stringWithFormat:@"appid=%@", appid]];
    }
    if(serverid && [serverid length] > 0) {
        [mtlArray addObject:[NSString stringWithFormat:@"serverid=%@", serverid]];
    }
    if(token && [token length] > 0) {
        [mtlArray addObject:[NSString stringWithFormat:@"token=%@", token]];
    }
    if(uid && [uid length] > 0) {
        [mtlArray addObject:[NSString stringWithFormat:@"uid=%@", uid]];
    }
    
    NSString *sign = [mtlArray componentsJoinedByString:@"&"];
    if(secretKey && [secretKey length] > 0) {
        sign = [sign stringByAppendingString:secretKey];
    }
    sign = [sign stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    sign = [sign stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    sign = PTPassportMD516(sign);
    if(sign) {
        sign = [sign lowercaseString];
    }
    return (sign);
}

/**
 * @brief 获取昵称 sign 生成规则
 */
NSString * PTPassportGetNickNameTokenSign(NSString *appid,
                                    NSString *serverid,
                                    NSString *token,
                                    NSString *uid,
                                    NSString *secretKey) {
    NSMutableArray *mtlArray = [NSMutableArray array];
    if(appid && [appid length] > 0) {
        [mtlArray addObject:[NSString stringWithFormat:@"appid=%@", appid]];
    }
    if(serverid && [serverid length] > 0) {
        [mtlArray addObject:[NSString stringWithFormat:@"serverid=%@", serverid]];
    }
    if(token && [token length] > 0) {
        [mtlArray addObject:[NSString stringWithFormat:@"token=%@", token]];
    }
    if(uid && [uid length] > 0) {
        [mtlArray addObject:[NSString stringWithFormat:@"uid=%@", uid]];
    }
    
    NSString *sign = [mtlArray componentsJoinedByString:@"&"];
    if(secretKey && [secretKey length] > 0) {
        sign = [sign stringByAppendingString:secretKey];
    }
    sign = [sign stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    sign = [sign stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    sign = PTPassportMD516(sign);
    if(sign) {
        sign = [sign lowercaseString];
    }
    return (sign);
}

/**
 * @brief 设置昵称 sign 生成规则
 */
NSString * PTPassportSetNickNameTokenSign(NSString *appid,
                                          NSString *nick_name,
                                          NSString *serverid,
                                          NSString *token,
                                          NSString *uid,
                                          NSString *secretKey) {
    NSMutableArray *mtlArray = [NSMutableArray array];
    if(appid && [appid length] > 0) {
        [mtlArray addObject:[NSString stringWithFormat:@"appid=%@", appid]];
    }
    if(nick_name && [nick_name length] > 0) {
        [mtlArray addObject:[NSString stringWithFormat:@"nick_name=%@", nick_name]];
    }
    if(serverid && [serverid length] > 0) {
        [mtlArray addObject:[NSString stringWithFormat:@"serverid=%@", serverid]];
    }
    if(token && [token length] > 0) {
        [mtlArray addObject:[NSString stringWithFormat:@"token=%@", token]];
    }
    if(uid && [uid length] > 0) {
        [mtlArray addObject:[NSString stringWithFormat:@"uid=%@", uid]];
    }
    
    NSString *sign = [mtlArray componentsJoinedByString:@"&"];
    if(secretKey && [secretKey length] > 0) {
        sign = [sign stringByAppendingString:secretKey];
    }
    sign = [sign stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    sign = [sign stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    sign = PTPassportMD516(sign);
    if(sign) {
        sign = [sign lowercaseString];
    }
    return (sign);
}


@interface PTPassport ()
//网络请求对象
@property (strong, nonatomic, readonly) NSURLSession *requestSessionManager;
//Passport 相关
@property (copy, nonatomic) NSString *clientType;
@property (copy, nonatomic) NSString *platformID;
@property (copy, nonatomic) NSString *deviceID;
@property (copy, nonatomic) NSString *appid;
@property (copy, nonatomic) NSString *version;
@property (copy, nonatomic) NSString *secretKey;
@property (copy, nonatomic) NSString *baseURLString;
//Upload上传头像 相关
@property (assign, nonatomic) BOOL isUploadAvatar;        //是否上传用户头像
@property (copy, nonatomic) NSString *uploadAppID;
@property (copy, nonatomic) NSString *uploadServiceBaseURLString;  //服务端后台地址,用于获取上传 Token
@property (copy, nonatomic) NSString *uploadBaseURLString;
@property (copy, nonatomic) NSString *uploadCheckExistURLString;
@property (copy, nonatomic) NSString *uploadGetTokenURLString;
@property (copy, nonatomic) NSString *uploadTrueUplpadURLString;

@end


@implementation PTPassport
@synthesize requestSessionManager = _requestSessionManager;

+ (void)setUpPassportWithClientType:(NSString *)clientType
                         platformID:(NSString *)platformID
                           deviceID:(NSString *)deviceID
                              appID:(NSString *)appid
                            version:(NSString *)version
                          secretKey:(NSString *)secretKey
                      baseURLString:(NSString *)baseURLString
                     isUploadAvatar:(BOOL) isUpload {
    [[self passport] setClientType:clientType];
    [[self passport] setPlatformID:platformID];
    [[self passport] setDeviceID:deviceID];
    [[self passport] setAppid:appid];
    [[self passport] setVersion:version];
    [[self passport] setSecretKey:secretKey];
    [[self passport] setBaseURLString:baseURLString];
    [[self passport] setIsUploadAvatar:isUpload];
}

+ (BOOL)getIsUploadAvatar{
    return  ([[self passport] isUploadAvatar]);
}

+ (NSString *)getUploadAppID{
    return ([[self passport] uploadAppID]);
}

+ (NSString *)getuploadServiceBaseURLString{
    return ([[self passport] uploadServiceBaseURLString]);
}

+ (NSString *)getuploadBaseURLString{
    return ([[self passport] uploadBaseURLString]);
}

+ (NSString *)getUploadCheckExistURLString{
    return ([[self passport] uploadCheckExistURLString]);
}

+ (NSString *)getUploadGetTokenURLString{
    return ([[self passport] uploadGetTokenURLString]);
}

+ (NSString *)getUploadTrueUplpadURLString{
    return ([[self passport] uploadTrueUplpadURLString]);
}


+ (void)setUpPassportWithUploadAppID:(NSString *)uploadAppID
                uploadServiceBaseURL:(NSString *)serviceBaseUrl
                       uploadBaseURL:(NSString *)baseUrl
                 uploadCheckExistURL:(NSString *)checkExistUrl
                   uploadGetTokenURL:(NSString *)getTokenUrl
                       trueUploadURL:(NSString *)trueUploadUrl{
    [[self passport] setUploadAppID:uploadAppID];
    [[self passport] setUploadServiceBaseURLString:serviceBaseUrl];
    [[self passport] setUploadBaseURLString:baseUrl];
    [[self passport] setUploadCheckExistURLString:checkExistUrl];
    [[self passport] setUploadGetTokenURLString:getTokenUrl];
    [[self passport] setUploadTrueUplpadURLString:trueUploadUrl];
}


+ (NSURLSession *)passportVerifyPhoneNumberExistWithPhoneNumber:(NSString *)phoneNumber
                                                                  success:(PTPassportSuccessBlock)success
                                                                  failure:(PTPassportFailureBlock)failure {
    return ([[self passport] passportVerifyPhoneNumberExistWithPhoneNumber:phoneNumber
                                                                   success:success
                                                                   failure:failure]);
}

+ (NSString *)passportSendImageVerifyCodeWithAction:(NSString *)action{
    return ([[self passport] passportSendImageVerifyCodeWithAction:action]);
}

+ (NSURLSession *)passportSendVerifyCodeWithPhoneNumber:(NSString *)phoneNumber
                                                           action:(NSString *)action
                                                          success:(PTPassportSuccessBlock)success
                                                          failure:(PTPassportFailureBlock)failure {
    return ([[self passport] passportSendVerifyCodeWithPhoneNumber:phoneNumber
                                                            action:action
                                                           success:success
                                                           failure:failure]);
}


+ (NSURLSession *)passportSafeSendVerifyCodeWithPhoneNumber:(NSString *)phoneNumber
                                                               verify:(NSString *)verify
                                                               action:(NSString *)action
                                                              success:(PTPassportSuccessBlock)success
                                                              failure:(PTPassportFailureBlock)failure{
    return ([[self passport] passportSafeSendVerifyCodeWithPhoneNumber:phoneNumber
                                                                verify:verify
                                                                action:action
                                                               success:success
                                                               failure:failure]);
}


+ (NSURLSession *)passportRegisterWithPhoneNumber:(NSString *)phoneNumber
                                                   password:(NSString *)password
                                                       code:(NSString *)code
                                                    success:(PTPassportSuccessBlock)success
                                                    failure:(PTPassportFailureBlock)failure {
    return ([[self passport] passportRegisterWithPhoneNumber:phoneNumber
                                                    password:password
                                                        code:code
                                                     success:success
                                                     failure:failure]);
}


+ (NSURLSession *)passportLoginWithPhoneNumber:(NSString *)phoneNumber
                                                password:(NSString *)password
                                                 success:(PTPassportSuccessBlock)success
                                                 failure:(PTPassportFailureBlock)failure {
    return ([[self passport] passportLoginWithPhoneNumber:phoneNumber
                                                 password:password
                                                  success:success
                                                  failure:failure]);
}

+ (NSURLSession *)passportSafeLoginWithPhoneNumber:(NSString *)phoneNumber
                                          password:(NSString *)password
                                            verify:(NSString *)verify
                                           success:(PTPassportSuccessBlock)success
                                           failure:(PTPassportFailureBlock)failure{
    return ([[self passport] passportSafeLoginWithPhoneNumber:phoneNumber
                                                     password:password
                                                       verify:verify
                                                      success:success
                                                      failure:failure]);
}

+ (NSURLSession *)passportChangePasswordWithUid:(NSString *)uid
                                                    token:(NSString *)token
                                              oldPassword:(NSString *)oldPassword
                                                 password:(NSString *)password
                                                  success:(PTPassportSuccessBlock)success
                                                  failure:(PTPassportFailureBlock)failure {
    return ([[self passport] passportChangePasswordWithUid:uid
                                                     token:token
                                               oldPassword:oldPassword
                                                  password:password
                                                   success:success
                                                   failure:failure]);
}

+ (NSURLSession *)passportForgotPasswordWithPhoneNumber:(NSString *)phoneNumber
                                                         password:(NSString *)password
                                                             code:(NSString *)code
                                                          success:(PTPassportSuccessBlock)success
                                                          failure:(PTPassportFailureBlock)failure {
    return ([[self passport] passportForgotPasswordWithPhoneNumber:phoneNumber
                                                          password:password
                                                              code:code
                                                           success:success
                                                           failure:failure]);
}

+ (NSURLSession *)passportCheckTokenWithUid:(NSString *)uid
                                      token:(NSString *)token
                                    success:(PTPassportSuccessBlock)success
                                    failure:(PTPassportFailureBlock)failure{
    return ([[self passport] passportCheckTokenWithUid:uid token:token success:success failure:failure]);
}


+ (NSURLSession *)passportGetNickNameWithUid:(NSString *)uid
                                       token:(NSString *)token
                                     success:(PTPassportSuccessBlock)success
                                     failure:(PTPassportFailureBlock)failure{
    return ([[self passport] passportGetNickNameWithUid:uid token:token success:success failure:failure]);
}

+ (NSURLSession *)passportSetNickNameWithNickName:(NSString *)nickName
                                              uid:(NSString *)uid
                                            token:(NSString *)token
                                          success:(PTPassportSuccessBlock)success
                                          failure:(PTPassportFailureBlock)failure{
    return ([[self passport] passportSetNickNameWithNickName:nickName uid:uid token:token success:success failure:failure]);
}

+ (NSURLSession *)passportGetUserAvatarWithUid:(NSString *)uid
                                         token:(NSString *)token
                                       success:(PTPassportSuccessBlock)success
                                       failure:(PTPassportFailureBlock)failure{
    return ([[self passport] passportGetUserAvatarWithUid:uid token:token success:success failure:failure]);
}


+ (NSURLSession *)passportSetUserAvatarWithHash:(NSString *)hash
                                            ext:(NSString *)ext
                                            uid:(NSString *)uid
                                          token:(NSString *)token
                                        success:(PTPassportSuccessBlock)success
                                        failure:(PTPassportFailureBlock)failure{
    return ([[self passport] passportSetUserAvatarWithHash:hash ext:ext uid:uid token:token success:success failure:failure]);
}


+ (void)cancelAllOperate {
    [[self passport] cancelAllOperate];
}

+ (instancetype)passport {
    static PTPassport *ppt = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ppt = [[PTPassport alloc] init];
    });
    return (ppt);
}

#pragma mark - getter
- (NSURLSession *)requestSessionManager{
    if (!_requestSessionManager) {
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfig.discretionary = YES; //根据系统推荐最佳选择 允许请求使用蜂巢或者WIFI网络
        sessionConfig.timeoutIntervalForResource = 15.0f; //整体资源超时的总时间
        sessionConfig.HTTPAdditionalHeaders = @{@"Accept": @"application/json"};
        
        _requestSessionManager = [NSURLSession sessionWithConfiguration:sessionConfig delegate: nil delegateQueue: [NSOperationQueue mainQueue]];;
    }
    
    return _requestSessionManager;
}


- (NSString *)requestURLStringWithSubURLString:(NSString *)subURLString {
    return ([self.baseURLString stringByAppendingString:subURLString]);
    
}
#pragma mark -

#pragma mark - action
- (NSURLSession *)passportVerifyPhoneNumberExistWithPhoneNumber:(NSString *)phoneNumber
                                                                  success:(PTPassportSuccessBlock)success
                                                                  failure:(PTPassportFailureBlock)failure {
    
    NSString *urlString = [self requestURLStringWithSubURLString:PTPassportAPICheckModile];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSMutableString *paramString = [[NSMutableString alloc] init];
    if(self.platformID && [self.platformID length] > 0) {
        [paramString appendString:[NSString stringWithFormat:@"platform_id=%@",self.platformID]];
    }
    if(phoneNumber && [phoneNumber length] > 0) {
        [paramString appendString:[NSString stringWithFormat:@"&mobile=%@",phoneNumber]];
    }
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[paramString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *defaultSession = [self requestSessionManager];
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           if(error == nil)
                                                           {
                                                               NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                                               if (httpResp.statusCode == 200) {
                                                                   NSDictionary* json = [NSJSONSerialization
                                                                                         JSONObjectWithData:data
                                                                                         options:kNilOptions
                                                                                         error:&error];
                                                                   if(success) {
                                                                       success([PTPassportResponseItem itemWithDictionary:json]);
                                                                   }
                                                                   
                                                               }
                                                           }else{
                                                               if(failure) {
                                                                   failure(error);
                                                               }
                                                           }
                                                           
                                                       }];
    [dataTask resume];
    return defaultSession;

}


- (NSString *)passportSendImageVerifyCodeWithAction:(NSString *)action{
    NSString *url = [self requestURLStringWithSubURLString:PTPassportAPIImageCode];
    
    long randomNumber = random();   //随机数
    NSString *imageUrl = [NSString stringWithFormat:@"%@?device_id=%@&action=%@&appid=%@&t=%@",url,self.deviceID,action,self.appid,[NSString stringWithFormat:@"%ld",randomNumber]];
    
    return imageUrl;
}


- (NSURLSession *)passportSendVerifyCodeWithPhoneNumber:(NSString *)phoneNumber
                                                           action:(NSString *)action
                                                          success:(PTPassportSuccessBlock)success
                                                          failure:(PTPassportFailureBlock)failure {
    
    NSString *urlString = [self requestURLStringWithSubURLString:PTPassportAPISendMsg];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSMutableString *paramString = [[NSMutableString alloc] init];
    
    [paramString appendString:[NSString stringWithFormat:@"appid=%@&mobile=%@&action=%@",self.appid,phoneNumber,action]];

    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[paramString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *defaultSession = [self requestSessionManager];
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           if(error == nil)
                                                           {
                                                               NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                                               if (httpResp.statusCode == 200) {
                                                                   NSDictionary* json = [NSJSONSerialization
                                                                                         JSONObjectWithData:data
                                                                                         options:kNilOptions
                                                                                         error:&error];
                                                                   if(success) {
                                                                       success([PTPassportResponseItem itemWithDictionary:json]);
                                                                   }
                                                                   
                                                               }
                                                           }else{
                                                               if(failure) {
                                                                   failure(error);
                                                               }
                                                           }
                                                           
                                                       }];
    [dataTask resume];
    return defaultSession;
}


- (NSURLSession *)passportSafeSendVerifyCodeWithPhoneNumber:(NSString *)phoneNumber
                                                               verify:(NSString *)verify
                                                               action:(NSString *)action
                                                              success:(PTPassportSuccessBlock)success
                                                              failure:(PTPassportFailureBlock)failure{
    //计算 sign
    NSString *sign = PTPassportSafeLoginSign(action,self.appid, nil, self.deviceID, phoneNumber, nil, nil,[verify trim], nil, self.secretKey);
    
    NSString *urlString = [self requestURLStringWithSubURLString:PTPassportAPISafeSendMsg];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSMutableString *paramString = [[NSMutableString alloc] init];
    [paramString appendString:[NSString stringWithFormat:@"appid=%@&action=%@&device_id=%@&mobile=%@",self.appid,action,self.deviceID,phoneNumber]];
    if (verify && verify.length > 0) {
        [paramString appendString:[NSString stringWithFormat:@"&verify=%@",verify]];
    }
    if(sign && [sign length] > 0) {
        [paramString appendString:[NSString stringWithFormat:@"&sign=%@",sign]];
    }
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[paramString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *defaultSession = [self requestSessionManager];
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           if(error == nil)
                                                           {
                                                               NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                                               if (httpResp.statusCode == 200) {
                                                                   NSDictionary* json = [NSJSONSerialization
                                                                                         JSONObjectWithData:data
                                                                                         options:kNilOptions
                                                                                         error:&error];
                                                                   if(success) {
                                                                       success([PTPassportResponseItem itemWithDictionary:json]);
                                                                   }
                                                                   
                                                               }
                                                           }else{
                                                               if(failure) {
                                                                   failure(error);
                                                               }
                                                           }
                                                           
                                                       }];
    [dataTask resume];
    return defaultSession;
}


- (NSURLSession *)passportRegisterWithPhoneNumber:(NSString *)phoneNumber
                                                   password:(NSString *)password
                                                       code:(NSString *)code
                                                    success:(PTPassportSuccessBlock)success
                                                    failure:(PTPassportFailureBlock)failure {
    NSString *urlString = [self requestURLStringWithSubURLString:PTPassportAPIRegister];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSMutableString *paramString = [[NSMutableString alloc] init];
    [paramString appendString:[NSString stringWithFormat:@"appid=%@&client_type=%@&device_id=%@&mobile=%@&passwd_once=%@&passwd_twice=%@&platform_id=%@&version=%@&code=%@",self.appid,self.clientType,self.deviceID,phoneNumber,password,password,self.platformID,self.version,code]];
    
    NSLog(@"registerURL : %@/%@",urlString,paramString);
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[paramString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSDate *date1 = [NSDate date];
    NSURLSession *defaultSession = [self requestSessionManager];
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           printf("\n%f\n",[[NSDate date] timeIntervalSinceDate:date1]);
                                                           if(error == nil)
                                                           {
                                                               NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                                               if (httpResp.statusCode == 200) {
                                                                   NSDictionary* json = [NSJSONSerialization
                                                                                         JSONObjectWithData:data
                                                                                         options:kNilOptions
                                                                                         error:&error];
                                                                   
                                                                   if(success) {
                                                                       success([PTPassportResponseItem itemWithDictionary:json]);
                                                                   }
                                                                   
                                                               }
                                                           }else{
                                                               if(failure) {
                                                                   failure(error);
                                                               }
                                                           }
                                                           
                                                       }];
    [dataTask resume];
    return defaultSession;
}

- (NSURLSession *)passportLoginWithPhoneNumber:(NSString *)phoneNumber
                                                password:(NSString *)password
                                                 success:(PTPassportSuccessBlock)success
                                                 failure:(PTPassportFailureBlock)failure {
    //计算 sign 需要把密码转码
    NSString *passwordURLEncoding = [password URLEncodedToString];
    NSString *sign = PTPassportLoginSign(self.appid, self.clientType, self.deviceID, phoneNumber, passwordURLEncoding, self.platformID, self.version, self.secretKey);

    NSString *urlString = [self requestURLStringWithSubURLString:PTPassportAPILogin];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSMutableString *paramString = [[NSMutableString alloc] init];
    [paramString appendString:[NSString stringWithFormat:@"appid=%@&client_type=%@&device_id=%@&mobile=%@&passwd=%@&platform_id=%@&version=%@",self.appid,self.clientType,self.deviceID,phoneNumber,password,self.platformID,self.version]];
    if(sign && [sign length] > 0) {
        [paramString appendString:[NSString stringWithFormat:@"&sign=%@",sign]];
    }
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[paramString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *defaultSession = [self requestSessionManager];
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           if(error == nil)
                                                           {
                                                               NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                                               if (httpResp.statusCode == 200) {
                                                                   NSDictionary* json = [NSJSONSerialization
                                                                                         JSONObjectWithData:data
                                                                                         options:kNilOptions
                                                                                         error:&error];
                                                                   if(success) {
                                                                       success([PTPassportResponseItem itemWithDictionary:json]);
                                                                   }
                                                                   
                                                               }
                                                           }else{
                                                               if(failure) {
                                                                   failure(error);
                                                               }
                                                           }
                                                           
                                                       }];
    [dataTask resume];
    return defaultSession;
}


- (NSURLSession *)passportSafeLoginWithPhoneNumber:(NSString *)phoneNumber
                                          password:(NSString *)password
                                            verify:(NSString *)verify
                                           success:(PTPassportSuccessBlock)success
                                           failure:(PTPassportFailureBlock)failure{
    
    //计算 sign 需要把密码转码
    NSString *passwordURLEncoding = [password URLEncodedToString];
    NSString *sign = PTPassportSafeLoginSign(nil,self.appid, self.clientType, self.deviceID, phoneNumber, passwordURLEncoding, self.platformID,verify, self.version, self.secretKey);
    
    
    NSString *urlString = [self requestURLStringWithSubURLString:PTPassportAPISafeLogin];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    //    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSMutableString *paramString = [[NSMutableString alloc] init];
    [paramString appendString:[NSString stringWithFormat:@"appid=%@&client_type=%@&device_id=%@&mobile=%@&passwd=%@&platform_id=%@&version=%@",self.appid,self.clientType,self.deviceID,phoneNumber,password,self.platformID,self.version]];
    if (verify && verify.length > 0) {
        [paramString appendString:[NSString stringWithFormat:@"&verify=%@",verify]];
    }
    if(sign && [sign length] > 0) {
        [paramString appendString:[NSString stringWithFormat:@"&sign=%@",sign]];
    }
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[paramString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *defaultSession = [self requestSessionManager];
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           if(error == nil)
                                                           {
                                                               NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                                               if (httpResp.statusCode == 200) {
                                                                   NSDictionary* json = [NSJSONSerialization
                                                                                         JSONObjectWithData:data
                                                                                         options:kNilOptions
                                                                                         error:&error];
                                                                   if(success) {
                                                                       success([PTPassportResponseItem itemWithDictionary:json]);
                                                                   }
                                                                   
                                                               }
                                                           }else{
                                                               if(failure) {
                                                                   failure(error);
                                                               }
                                                           }
                                                           
                                                       }];
    [dataTask resume];
    return defaultSession;
}


- (NSURLSession *)passportChangePasswordWithUid:(NSString *)uid
                                                    token:(NSString *)token
                                              oldPassword:(NSString *)oldPassword
                                                 password:(NSString *)password
                                                  success:(PTPassportSuccessBlock)success
                                                  failure:(PTPassportFailureBlock)failure {
    NSString *urlString = [self requestURLStringWithSubURLString:PTPassportAPIChangePassword];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSMutableString *paramString = [[NSMutableString alloc] init];
    [paramString appendString:[NSString stringWithFormat:@"appid=%@&device_id=%@&old_passwd=%@&passwd_once=%@&passwd_twice=%@&platform_id=%@&version=%@&uid=%@&token=%@",self.appid,self.deviceID,oldPassword,password,password,self.platformID,self.version,uid,token]];

    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[paramString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *defaultSession = [self requestSessionManager];
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           if(error == nil)
                                                           {
                                                               NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                                               if (httpResp.statusCode == 200) {
                                                                   NSDictionary* json = [NSJSONSerialization
                                                                                         JSONObjectWithData:data
                                                                                         options:kNilOptions
                                                                                         error:&error];
                                                                   if(success) {
                                                                       success([PTPassportResponseItem itemWithDictionary:json]);
                                                                   }
                                                                   
                                                               }
                                                           }else{
                                                               if(failure) {
                                                                   failure(error);
                                                               }
                                                           }
                                                           
                                                       }];
    [dataTask resume];
    return defaultSession;
}

- (NSURLSession *)passportForgotPasswordWithPhoneNumber:(NSString *)phoneNumber
                                                         password:(NSString *)password
                                                             code:(NSString *)code
                                                          success:(PTPassportSuccessBlock)success
                                                          failure:(PTPassportFailureBlock)failure {
    
    NSString *urlString = [self requestURLStringWithSubURLString:PTPassportAPIForget];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSMutableString *paramString = [[NSMutableString alloc] init];
    [paramString appendString:[NSString stringWithFormat:@"appid=%@&code=%@&mobile=%@&passwd_once=%@&passwd_twice=%@",self.appid,code,phoneNumber,password,password]];
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[paramString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *defaultSession = [self requestSessionManager];
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           if(error == nil)
                                                           {
                                                               NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                                               if (httpResp.statusCode == 200) {
                                                                   NSDictionary* json = [NSJSONSerialization
                                                                                         JSONObjectWithData:data
                                                                                         options:kNilOptions
                                                                                         error:&error];
                                                                   if(success) {
                                                                       success([PTPassportResponseItem itemWithDictionary:json]);
                                                                   }
                                                                   
                                                               }
                                                           }else{
                                                               if(failure) {
                                                                   failure(error);
                                                               }
                                                           }
                                                           
                                                       }];
    [dataTask resume];
    return defaultSession;
}


- (NSURLSession *)passportCheckTokenWithUid:(NSString *)uid
                                      token:(NSString *)token
                                    success:(PTPassportSuccessBlock)success
                                    failure:(PTPassportFailureBlock)failure{
    
    NSString *sign = PTPassportChekcTokenSign(self.appid, self.appid, token, uid, self.secretKey);
    
    NSString *urlString = [self requestURLStringWithSubURLString:PTPassportAPICheckToken];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSMutableString *paramString = [[NSMutableString alloc] init];
    [paramString appendString:[NSString stringWithFormat:@"appid=%@&serverid=%@&uid=%@&token=%@",self.appid,self.appid,uid,token]];
    if(sign && [sign length] > 0) {
        [paramString appendString:[NSString stringWithFormat:@"&sign=%@",sign]];
    }
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[paramString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *defaultSession = [self requestSessionManager];
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           if(error == nil)
                                                           {
                                                               NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                                               if (httpResp.statusCode == 200) {
                                                                   NSDictionary* json = [NSJSONSerialization
                                                                                         JSONObjectWithData:data
                                                                                         options:kNilOptions
                                                                                         error:&error];
                                                                   if(success) {
                                                                       success([PTPassportResponseItem itemWithDictionary:json]);
                                                                   }
                                                                   
                                                               }
                                                           }else{
                                                               if(failure) {
                                                                   failure(error);
                                                               }
                                                           }
                                                           
                                                       }];
    [dataTask resume];
    return defaultSession;
}


- (NSURLSession *)passportGetNickNameWithUid:(NSString *)uid
                                       token:(NSString *)token
                                     success:(PTPassportSuccessBlock)success
                                     failure:(PTPassportFailureBlock)failure{
    
    NSString *sign = PTPassportGetNickNameTokenSign(self.appid, self.appid, token, uid, self.secretKey);
    
    NSString *urlString = [self requestURLStringWithSubURLString:PTPassportAPIGetNickName];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSMutableString *paramString = [[NSMutableString alloc] init];
    [paramString appendString:[NSString stringWithFormat:@"appid=%@&serverid=%@&uid=%@&token=%@",self.appid,self.appid,uid,token]];
    if(sign && [sign length] > 0) {
        [paramString appendString:[NSString stringWithFormat:@"&sign=%@",sign]];
    }
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[paramString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *defaultSession = [self requestSessionManager];
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           if(error == nil)
                                                           {
                                                               NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                                               if (httpResp.statusCode == 200) {
                                                                   NSDictionary* json = [NSJSONSerialization
                                                                                         JSONObjectWithData:data
                                                                                         options:kNilOptions
                                                                                         error:&error];
                                                                   if(success) {
                                                                       success([PTPassportResponseItem itemWithDictionary:json]);
                                                                   }
                                                                   
                                                               }
                                                           }else{
                                                               if(failure) {
                                                                   failure(error);
                                                               }
                                                           }
                                                           
                                                       }];
    [dataTask resume];
    return defaultSession;
}


- (NSURLSession *)passportSetNickNameWithNickName:(NSString *)nickName
                                              uid:(NSString *)uid
                                            token:(NSString *)token
                                          success:(PTPassportSuccessBlock)success
                                          failure:(PTPassportFailureBlock)failure{
    
    NSString *encodedNickName = [nickName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *sign = PTPassportSetNickNameTokenSign(self.appid, encodedNickName, self.appid, token, uid, self.secretKey);
    
    NSString *urlString = [self requestURLStringWithSubURLString:PTPassportAPISetNickName];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSMutableString *paramString = [[NSMutableString alloc] init];
    [paramString appendString:[NSString stringWithFormat:@"appid=%@&serverid=%@&uid=%@&token=%@&nick_name=%@",self.appid,self.appid,uid,token,encodedNickName]];
    if(sign && [sign length] > 0) {
        [paramString appendString:[NSString stringWithFormat:@"&sign=%@",sign]];
    }
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[paramString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *defaultSession = [self requestSessionManager];
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           if(error == nil)
                                                           {
                                                               NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                                               if (httpResp.statusCode == 200) {
                                                                   NSDictionary* json = [NSJSONSerialization
                                                                                         JSONObjectWithData:data
                                                                                         options:kNilOptions
                                                                                         error:&error];
                                                                   if(success) {
                                                                       success([PTPassportResponseItem itemWithDictionary:json]);
                                                                   }
                                                                   
                                                               }
                                                           }else{
                                                               if(failure) {
                                                                   failure(error);
                                                               }
                                                           }
                                                           
                                                       }];
    [dataTask resume];
    return defaultSession;

}

- (NSURLSession *)passportGetUserAvatarWithUid:(NSString *)uid
                                         token:(NSString *)token
                                       success:(PTPassportSuccessBlock)success
                                       failure:(PTPassportFailureBlock)failure{
   
    NSString *urlString = [self requestURLStringWithSubURLString:PTPassportAPIGetUserAvatar];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSMutableString *paramString = [[NSMutableString alloc] init];
    [paramString appendString:[NSString stringWithFormat:@"appid=%@&uid=%@&token=%@",self.appid,uid,token]];
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[paramString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *defaultSession = [self requestSessionManager];
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           if(error == nil)
                                                           {
                                                               NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                                               if (httpResp.statusCode == 200) {
                                                                   NSDictionary* json = [NSJSONSerialization
                                                                                         JSONObjectWithData:data
                                                                                         options:kNilOptions
                                                                                         error:&error];
                                                                   if(success) {
                                                                       success([PTPassportResponseItem itemWithDictionary:json]);
                                                                   }
                                                                   
                                                               }
                                                           }else{
                                                               if(failure) {
                                                                   failure(error);
                                                               }
                                                           }
                                                           
                                                       }];
    [dataTask resume];
    return defaultSession;
}

- (NSURLSession *)passportSetUserAvatarWithHash:(NSString *)hash
                                            ext:(NSString *)ext
                                            uid:(NSString *)uid
                                          token:(NSString *)token
                                        success:(PTPassportSuccessBlock)success
                                        failure:(PTPassportFailureBlock)failure{
    NSString *urlString = [self requestURLStringWithSubURLString:PTPassportAPISetUserAvatar];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSMutableString *paramString = [[NSMutableString alloc] init];
    [paramString appendString:[NSString stringWithFormat:@"appid=%@&uid=%@&token=%@&hash=%@&ext=%@",self.appid,uid,token,hash,ext]];
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[paramString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *defaultSession = [self requestSessionManager];
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           if(error == nil)
                                                           {
                                                               NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                                               if (httpResp.statusCode == 200) {
                                                                   NSDictionary* json = [NSJSONSerialization
                                                                                         JSONObjectWithData:data
                                                                                         options:kNilOptions
                                                                                         error:&error];
                                                                   if(success) {
                                                                       success([PTPassportResponseItem itemWithDictionary:json]);
                                                                   }
                                                                   
                                                               }
                                                           }else{
                                                               if(failure) {
                                                                   failure(error);
                                                               }
                                                           }
                                                           
                                                       }];
    [dataTask resume];
    return defaultSession;
}


- (void)cancelAllOperate {
    [[self requestSessionManager] invalidateAndCancel];
}
#pragma mark -

@end
