//
//  PPTBaseModel.h
//  PTLib
//
//  Created by LiLiLiu on 16/3/14.
//  Copyright © 2016年 putao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPTGlobal.h"

/**
 *  @brief  数据状态体的key
 */
#define PPT_KEY_SODEFAULT_RESPONSE_RESP     @"resp"

/**
 *  @brief  数据状态码的key
 */
#define PPT_KEY_SODEFAULT_RESPONSE_CODE     @"http_code"

/**
 *  @brief  数据状态描述的key
 */
#define PPT_KEY_SODEFAULT_RESPONSE_DESC     @"desc"

#define PPT_KEY_SMKDFAULT_ACCESSTOKEN       @"accesstoken"

#define PPT_KEY_PTDEFAULT_STATUS            @"http_code"

#define PPT_KEY_PTDEFAULT_DATA              @"data"
#define PPT_KEY_PTDEFAULT_SUCCESS_CODE      200


@interface PPTBaseModel : NSObject

@end
