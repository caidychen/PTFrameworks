//
//  UserManager.m
//  PTLatitude
//
//  Created by LiLiLiu on 15/12/6.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "UserManager.h"
#import "NSObject+PPTSwizzle.h"


@interface UserManager()
@property(nonatomic,strong)User *user;
@end


@implementation UserManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id __singleton__;
    dispatch_once( &once, ^{ __singleton__ = [[self alloc] init]; } );
    return __singleton__;
}

- (instancetype)sharedInstance
{
    return [[self class] sharedInstance];
}




/*!
 *@method  canAutoLogin
 *@abstract 判断是否可以自动登录
 *@discussion 程序启动时，需调用此方法，判断是否可以自动登录。
 */
- (BOOL)canAutoLogin
{
    if (self.user.userID!= nil && self.user.userToken !=nil ) {
        return YES;
    }
    return NO;
}



/*！
 *@method updateToDisk
 *@abstract 保存数据到硬盘
 *@discussion 每次更新成员属性，需要手工调用此函数，将更新内容持久化到磁盘。
 */
- (void) updateToDisk
{
    // Encoding User 类要实现 NSCopying NSCoding 协议
    NSString *docFile  = [self getAccountSaveDocumentsPath];
    if([NSKeyedArchiver archiveRootObject:self.user toFile:docFile]) {
//        NSLog(@"保存用户信息 Success");
    }
    else {
        NSLog(@"保存用户信息  Faile");
    }
    
}

/*！
 *@method  initSingletonFromDisk
 *@abstract 从硬盘初始化用户信息
 *@discussion 程序启动时应该首先调用该函数。
 */
-(void)initSingletonFromDisk;
{
//    NSLog(@"store user Path: %@",[self getAccountSaveDocumentsPath]);
    
    self.user = [NSKeyedUnarchiver unarchiveObjectWithFile:[self getAccountSaveDocumentsPath]];
    NSLog(@"init user \n %@  ",self.user);
}

/*！
 *@method   clearAllData
 *@abstract 清空所有内存、磁盘文件。
 *@discussion  注销时使用。
 */
- (void) clearAllData;
{
    
    [self clearAllDataNotSaveToDisk];
    //清空磁盘
    [self updateToDisk];
}



/*！
 *@method      clearAllDataNotSaveToDisk
 *@abstract    清楚所有数据但是不保存在客户端
 *@discussion  清空所有内存、但是硬盘中的数据并未清除， 注意，需要手动调用一次 updateToDisk
 (注意： 注销时使用)
 */
- (void) clearAllDataNotSaveToDisk;
{
    //清空用户所有保存数据
    self.user = [[User alloc] init];
}


/**
 *  获取应用目录
 *  @return 当前应用目录
 */
-(NSString*)getDocumentDirectory
{
    NSArray *paths =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask, YES);
    return  [paths safeObjectAtIndex:0];
}

- (NSString*)getAccountSaveDocumentsPath;
{
    NSString *userSavePath = [[self getDocumentDirectory] stringByAppendingPathComponent:@"account.data"];
    return userSavePath;
}



#pragma  mark - 调试信息

//调试的时候输出自定义对象信息
- (NSString*) description
{
    NSMutableString* res = [NSMutableString stringWithFormat:@"user info:%@",[self.user description]];
    
    return res ;
    
}


#pragma mark - NSUserDefaults 数据存取,支持多账号
-(void)saveUserDefaultsWithObject:(id)object forKey:(NSString*)key
{
    [[NSUserDefaults standardUserDefaults] setObject:object
                                              forKey:[NSString stringWithFormat:@"%@_%@",self.user.userID,key]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(id)getUserDefaultsDataWithKey:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%@",self.user.userID,key]];
}

-(void)clearUserDefaultsDataWithPrefix:(NSString*)prefix
{
    NSUserDefaults * userDefs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [userDefs dictionaryRepresentation];
    for (id key in dict) {
        if ([key isKindOfClass:[NSString class]] &&
            [key hasPrefix:prefix]) {
            [userDefs removeObjectForKey:key];
        }
    }
    [userDefs synchronize];
}


#pragma mark - getter
- (User*)user{
    
    if(!_user){
        _user = [[User alloc] init];
    }
    return _user;
}



@end
