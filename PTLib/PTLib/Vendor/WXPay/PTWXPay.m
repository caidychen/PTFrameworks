//
//  PTWXPay.m
//  PTLatitude
//
//  Created by zhangyi on 16/3/1.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTWXPay.h"
#import "WXApi.h"

@implementation PTWXPay

+ (void)payWithOrderString:(PTWXPayResultItem *)item
                    result:(PTWXPayResultBlock)resultBolck{
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = item.partnerId;
    request.prepayId = item.prepayId;
    request.package = item.package;
    request.nonceStr = item.nonceStr;
    request.timeStamp = [item.timeStamp intValue];
    request.sign= item.sign;

    PTWXPayCallBackItem *backItem = [[PTWXPayCallBackItem alloc] init];
    
    if (![WXApi isWXAppInstalled]) {
        NSLog(@"您的手机未安装手机微信");
        backItem.backType = callBackTypeForNoInstalled;
        resultBolck(backItem);
        return;
    }
    if (![WXApi isWXAppSupportApi]) {
        NSLog(@"微信版本过低，不支持支付");
        backItem.backType = callBackTypeForNoSupport;
        resultBolck(backItem);
        return;
    }
    
    if ([WXApi sendReq:request]) {
        NSLog(@"调用微信支付成功");
        backItem.backType = callBackTypeForSuccess;
        resultBolck(backItem);
    }else{
        NSLog(@"调用微信支付失败");
        backItem.backType = callBackTypeForFailure;
        resultBolck(backItem);
    }

}

@end
