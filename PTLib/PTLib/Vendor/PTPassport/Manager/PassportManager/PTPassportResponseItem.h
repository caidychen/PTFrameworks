//
//  PTPassportResponseItem.h
//  kidsPlay
//
//  Created by so on 15/10/30.
//  Copyright (c) 2015年 so. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTPassportResponseItem : NSObject <NSCopying>

/**
 *  @brief  错误码
 */
@property (assign, nonatomic) NSInteger errorCode;

/**
 *  @brief  错误信息
 */
@property (copy, nonatomic) NSString *msg;

/**
 *  @brief  用户ID
 */
@property (copy, nonatomic) NSString *uid;

/**
 *  @brief  用户昵称
 */
@property (copy, nonatomic) NSString *nickName;


/**
 *  @brief  用户头像
 */
@property (copy, nonatomic) NSString *avatar;


/**
 *  @brief  令牌
 */
@property (copy, nonatomic) NSString *token;

/**
 *  @brief  刷新令牌
 */
@property (copy, nonatomic) NSString *refreshToken;

/**
 *  @brief  过期时间
 */
@property (copy, nonatomic) NSString *expireTime;

/**
 *  @brief  便利方法
 *
 *  @return 返回自身实例
 */
+ (instancetype)item;

/**
 *  @brief  便利方法，从dictionary初始化
 *
 *  @return 返回自身实例
 */
+ (instancetype)itemWithDictionary:(NSDictionary *)dictionary;

@end
