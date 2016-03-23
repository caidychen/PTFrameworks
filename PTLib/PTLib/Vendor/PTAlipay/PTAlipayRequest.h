//
//  PTAlipayRequest.h
//  PTLatitude
//
//  Created by LiLiLiu on 15/12/18.
//  Copyright © 2015年 PT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTAlipayResultItem.h"

typedef void (^PTAlipayRequestSuccessBlock)(PTAlipayResultItem *resultItem);
typedef void (^PTAlipayRequestFailureBlock)(NSError *error);


//外界调用阿里支付的方法
@interface PTAlipayRequest : NSOperation

//调用该方法前提、用户必须已经登录成功过
+ (void)payWithBaseUrl:(NSString *)baseUrl
               orderId:(NSString *)orderId
                   uid:(NSString *)uid
             userToken:(NSString *)token
               success:(PTAlipayRequestSuccessBlock)success
               failure:(PTAlipayRequestFailureBlock)failure;

@end
