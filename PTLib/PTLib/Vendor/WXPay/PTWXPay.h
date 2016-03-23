//
//  PTWXPay.h
//  PTLatitude
//
//  Created by zhangyi on 16/3/1.
//  Copyright © 2016年 PT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTWXPayResultItem.h"
#import "PTWXPayCallBackItem.h"

typedef void (^PTWXPayResultBlock)(PTWXPayCallBackItem *item);
@interface PTWXPay : NSObject

/**
 *  @brief  支付方法调用
 */
+ (void)payWithOrderString:(PTWXPayResultItem *)item
                    result:(PTWXPayResultBlock)resultBolck;

@end
