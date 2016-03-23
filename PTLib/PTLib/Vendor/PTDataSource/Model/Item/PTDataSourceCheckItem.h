//
//  PTDataSourceCheckItem.h
//  PTLatitude
//
//  Created by so on 15/12/18.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTDataSourceBaseItem.h"

@interface PTDataSourceCheckItem : PTDataSourceBaseItem <NSCopying>


/**
 *  @brief  状态码
 */
@property (assign, nonatomic) NSInteger status;

/**
 *  @brief  错误信息
 */
@property (copy, nonatomic) NSString *msg;


/**
 *  @brief  最新版本
 */
@property (copy, nonatomic) NSString *last_version;

/**
 *  @brief  最新版本
 */
@property (copy, nonatomic) NSString *last_resource_version;


/**
 *  @brief  资源服务地址
 */
@property (copy, nonatomic) NSString *resource_server;

/**
 *  @brief  资源服务地址，备份地址
 */
@property (copy, nonatomic) NSString *resource_server_bak;

/**
 *  @brief  资源服务地址，备份IP
 */
@property (copy, nonatomic) NSString *resource_ip;

@end
