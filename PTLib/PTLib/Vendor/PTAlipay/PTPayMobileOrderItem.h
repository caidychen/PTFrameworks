//
//  PTPayMobileOrderItem.h
//  PTLatitude
//
//  Created by LiLiLiu on 15/12/15.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "SOBaseItem.h"

/**
 * @brief 调用支付接口返回数据
 */
@interface PTPayMobileOrderItem : SOBaseItem<NSCopying>

@property (nonatomic, copy) NSString *code;

@end
