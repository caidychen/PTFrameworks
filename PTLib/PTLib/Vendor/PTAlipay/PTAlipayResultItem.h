//
//  PTAlipayResultItem.h
//  PTLatitude
//
//  Created by LiLiLiu on 15/12/16.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "SOBaseItem.h"

@interface PTAlipayResultItem : SOBaseItem<NSCopying>

@property (nonatomic, copy) NSString *memo;           //提示信息
@property (nonatomic, copy) NSString *resultStatus;   //状态码
@property (nonatomic, copy) NSString *result;         //订单信息，以及签名验证信息。如果你不想做签名验证，那这个字段可以忽略了

@end
