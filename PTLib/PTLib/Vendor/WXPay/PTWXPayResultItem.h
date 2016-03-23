//
//  PTWXPayResultItem.h
//  PTLatitude
//
//  Created by zhangyi on 16/3/1.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "SOBaseItem.h"

@interface PTWXPayResultItem : SOBaseItem

//@property (nonatomic, copy) NSString *appId;
//@property (nonatomic, copy) NSString *nonceStr;
//@property (nonatomic, copy) NSString *package;
//@property (nonatomic, copy) NSString *signType;     // 暂时不需要
//@property (nonatomic, copy) NSString *timeStamp;
//@property (nonatomic, copy) NSString *paySign;

@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *partnerId;
@property (nonatomic, copy) NSString *prepayId;
@property (nonatomic, copy) NSString *package;
@property (nonatomic, copy) NSString *nonceStr;
@property (nonatomic, copy) NSString *timeStamp;
@property (nonatomic, copy) NSString *sign;



@end
