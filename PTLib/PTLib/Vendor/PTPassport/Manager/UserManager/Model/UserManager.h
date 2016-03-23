//
//  UserManager.h
//  PTLatitude
//
//  Created by LiLiLiu on 15/12/6.
//  Copyright © 2015年 PT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserManager : NSObject


@property (nonatomic,strong,readonly)User *user;  //纪录当前登录用户信息
@property (nonatomic, assign) BOOL needUpdateJPushAlias;    // 是否需要更新别名


//Singleton
+ (instancetype)sharedInstance;
- (instancetype)sharedInstance;


/*！
 *@method  initSingletonFromDisk
 *@abstract 从硬盘初始化用户信息
 *@discussion 程序启动时应该首先调用该函数。
 */
-(void) initSingletonFromDisk;


/*！
 *@method updateToDisk
 *@abstract 保存数据到硬盘
 *@discussion 每次更新成员属性，需要手工调用此函数，将更新内容持久化到磁盘。
 */
- (void) updateToDisk;

/*！
 *@method      clearAllDataNotSaveToDisk
 *@abstract    清楚所有数据但是不保存在客户端
 *@discussion  清空所有内存、但是硬盘中的数据并未清除， 主意，需要手动调用一次 updateToDisk
 (注意： 注销时使用)
 */
- (void) clearAllDataNotSaveToDisk;


/*！
 *@method   clearAllData
 *@abstract 清空所有内存、磁盘文件。
 *@discussion  注销时使用。
 */
- (void) clearAllData;


/*!
 *@method  canAutoLogin
 *@abstract 判断是否可以自动登录
 *@discussion 程序启动时，需调用此方法，判断是否可以自动登录。
 */
- (BOOL)canAutoLogin;


/**
 *  获取应用目录
 *  @return 当前应用目录
 */
-(NSString*)getDocumentDirectory;
-(NSString*)getAccountSaveDocumentsPath;


#pragma mark - NSUserDefaults 数据存取,支持多账号
-(void)saveUserDefaultsWithObject:(id)object forKey:(NSString*)key;
-(id)getUserDefaultsDataWithKey:(NSString*)key;
-(void)clearUserDefaultsDataWithPrefix:(NSString*)prefix;


@end
