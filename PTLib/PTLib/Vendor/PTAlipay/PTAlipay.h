//
//  PTAlipay.h
//  PTLatitude
//
//  Created by LiLiLiu on 15/12/16.
//  Copyright © 2015年 PT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTAlipayError.h"
#import "PTAlipayResultItem.h"

typedef void (^PTAlipayResultBlock)(PTAlipayResultItem *resultItem);

@interface PTAlipay : NSObject


/**
 *  @brief  支付方法调用
 */
+ (void)payWithOrderString:(NSString *)orderString
                   result:(PTAlipayResultBlock)resultBolck;

@end
