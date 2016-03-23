//
//  PTDataSourceHelper.h
//  PTLatitude
//
//  Created by so on 15/12/18.
//  Copyright © 2015年 PT. All rights reserved.
//

#import <Foundation/Foundation.h>


NSString * PTDataSourceStringObjectFromDictionary(NSDictionary *dict, NSString *key);



//资源链接优先级
typedef NS_OPTIONS(NSUInteger, PTDataSourceURLLevel) {
    PTDataSourceURLLevel1       = 0,
    PTDataSourceURLLevel2,
    PTDataSourceURLLevel3
};


/**
 *  @brief  资源目录
 */
NSString * PTDataSourceFilePath();


/**
 *  @brief  当前资源版本
 */
NSString * PTDataSourceCurrentVersion();

/**
 *  @brief  设置当前资源版本
 */
void PTDataSourceSetVersion(NSString *version);


/**
 *  @brief  根据item里获取对应优先级的远程资源地址
 */
@class PTDataSourceCheckItem;
NSString * PTDataSourceURLStringWithItemAndLevel(PTDataSourceCheckItem *item, PTDataSourceURLLevel level);

