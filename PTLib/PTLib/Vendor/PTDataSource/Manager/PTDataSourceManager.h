//
//  PTDataSourceManager.h
//  PTLatitude
//
//  Created by so on 15/12/18.
//  Copyright © 2015年 PT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTFaceItem.h"
#import "PTRegionItem.h"

typedef void(^PTDataSourceManagerBlock)(BOOL success, NSString *filePath);

@interface PTDataSourceManager : NSObject

/**
 *  @brief  回调block
 */
@property (copy, nonatomic) PTDataSourceManagerBlock block;

/**
 *  @brief  单例
 */
+ (instancetype)manager;

/**
 *  @brief  设置资源更新需要的参数
 */
- (void)setUpDataSourceWithBundleFileName:(NSString *)bundleFileName
                        bundleFileVersion:(NSString *)bundleFileVersion
                           checkURLString:(NSString *)checkURLString
                                   gameID:(NSString *)gameID
                                     opID:(NSString *)opID
                                 clientID:(NSString *)clientID
                             clientSecret:(NSString *)clientSecret;

/**
 *  @brief  开始检查资源任务
 */
- (void)start;

/**
 *  @brief  取消任务
 */
- (void)cancel;

/**
 *  @brief  解析表情
 */
- (void)parseFacesWithBlock:(void(^)(NSArray <PTFaceItem *> *items))parseBlock;

/**
 *  @brief  解析省、市、区
 */
- (void)parseRegionWithBlock:(void(^)(NSArray <PTRegionItem *> *items))parseBlock;

- (NSArray <PTFaceItem *> *)faceItems;
- (NSArray <PTRegionItem *> *)regionItems;

@end
