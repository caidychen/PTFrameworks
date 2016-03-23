//
//  PTAlipayError.h
//  PTLatitude
//
//  Created by LiLiLiu on 15/12/16.
//  Copyright © 2015年 PT. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_OPTIONS(NSUInteger, PTAlipayErrorCode) {
    PTAlipayErrorCodePaySuccess             = 9000,                  //订单支付成功
    PTAlipayErrorCodePayInHand              = 8000,                  //正在处理中
    PTAlipayErrorCodePayFaile               = 4000,                  //订单支付失败
    PTAlipayErrorCodePayCancel              = 6001,                  //用户中途取消
    PTAlipayErrorCodeNetworkFaile           = 6002,                  //网络连接出错
};

NSString *PTAlipayErrorCodeDescription(PTAlipayErrorCode errorCode);

