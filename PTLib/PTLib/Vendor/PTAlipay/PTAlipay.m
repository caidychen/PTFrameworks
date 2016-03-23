//
//  PTAlipay.m
//  PTLatitude
//
//  Created by LiLiLiu on 15/12/16.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTAlipay.h"

#import <AlipaySDK/AlipaySDK.h>


//当前 App 的 appScheme
static NSString * const PTAlipayAPPScheme        = @"PTLatitudeAliPay";

@implementation PTAlipay

/**
 * 返回数据结构
 
 {
 memo = "Error Domain=\U7cfb\U7edf\U7e41\U5fd9\Uff0c\U8bf7\U7a0d\U540e\U518d\U8bd5 Code=1000 \"\U672a\U80fd\U5b8c\U6210\U64cd\U4f5c\U3002\Uff08\U201c\U7cfb\U7edf\U7e41\U5fd9\Uff0c\U8bf7\U7a0d\U540e\U518d\U8bd5\U201d\U9519\U8bef 1000\U3002\Uff09\"";     //提示信息
 result = "";            //订单信息，以及签名验证信息。如果你不想做签名验证，那这个字段可以忽略了
 resultStatus = 4000;    //状态码
 }
 
 */
+ (void)payWithOrderString:(NSString *)orderString
                    result:(PTAlipayResultBlock)resultBolck{
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:PTAlipayAPPScheme callback:^(NSDictionary *resultDic) {
//            NSLog(@"reslut = %@",resultDic);
        if (resultDic) {
            PTAlipayResultItem *item = [PTAlipayResultItem itemWithDict:resultDic];
            if (resultBolck) {
                resultBolck(item);
            }

        }
        
    }];

}

@end
