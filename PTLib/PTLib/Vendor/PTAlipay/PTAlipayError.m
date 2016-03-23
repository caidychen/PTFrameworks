//
//  PTAlipayError.m
//  PTLatitude
//
//  Created by LiLiLiu on 15/12/16.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTAlipayError.h"


NSString *PTAlipayErrorCodeDescription(PTAlipayErrorCode errorCode){
    switch (errorCode) {
        case PTAlipayErrorCodePaySuccess:{ return (@"订单支付成功"); }break;
        case PTAlipayErrorCodePayInHand:{ return (@"正在处理中"); }break;
        case PTAlipayErrorCodePayFaile:{ return (@"订单支付失败"); }break;
        case PTAlipayErrorCodePayCancel:{ return (@"用户中途取消"); }break;
        case PTAlipayErrorCodeNetworkFaile:{ return (@"网络连接出错"); }break;
        default:{ return (@"未定义的错误码"); }break;
    }
}