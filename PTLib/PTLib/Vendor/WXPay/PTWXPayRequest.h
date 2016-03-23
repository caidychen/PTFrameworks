//
//  PTWXPayRequest.h
//  PTLatitude
//
//  Created by zhangyi on 16/3/1.
//  Copyright © 2016年 PT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTWXPayCallBackItem.h"

/**
 *  @brief  调用成功返回的item，有enum值判断状态
 */
typedef void (^PTWXPayRequestSuccessBlock)(PTWXPayCallBackItem *resultItem);
/**
 *  @brief  接口请求失败,返回错误信息。（未调用微信API）
 *
 *  @pram   请求失败返回NSError;   请求成功状态码失败，返回@"msg"。
 */
typedef void (^PTWXPayRequestFailureBlock)(id error);

/**
 *  @brief  外界调微信接口，先通过自己的服务器拿到参数，在调用微信支付
 */
@interface PTWXPayRequest : NSOperation

/**
 *  @brief  使用之前！需要判断用户是否是已登录！需要把baseurl传入 如:http://api-store.putao.com/pay/mobile/toPay 以及用户信息作为参数
 */
+ (void)payWithBaseUrl:(NSString *)baseUrl
               orderId:(NSString *)orderId
                   uid:(NSString *)uid
             userToken:(NSString *)token
               success:(PTWXPayRequestSuccessBlock)success
               failure:(PTWXPayRequestFailureBlock)failure;


@end
