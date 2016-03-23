//
//  PTUserManager.m
//  PTLatitude
//
//  Created by LiLiLiu on 15/12/6.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTUserManager.h"

@implementation PTUserManager

/*！
 *@method updateToDisk
 *@abstract 保存数据到硬盘
 *@discussion 每次更新成员属性，需要手工调用此函数，将更新内容持久化到磁盘。
 */
- (void)updateToDisk {
    // Encoding User 类要实现 NSCopying NSCoding 协议
    NSString *docFile  = [self getUserInfoDocumentsPath];
    if([NSKeyedArchiver archiveRootObject:self.userInfo toFile:docFile]) {
//        NSLog(@"保存用户详情信息 Success");
    }
    else {
//        NSLog(@"保存用户详情信息  Faile");
    }
    
//    [NSKeyedArchiver archiveRootObject:self.userInfo toFile:[self getUserInfoDocumentsPath]];
    [super updateToDisk];
}

/*！
 *@method  initSingletonFromDisk
 *@abstract 从硬盘初始化用户信息
 *@discussion 程序启动时应该首先调用该函数。
 */
-(void)initSingletonFromDisk {
    [super initSingletonFromDisk];

    self.userInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:[self getUserInfoDocumentsPath]];
}


- (NSString*)getUserInfoDocumentsPath {
    NSString *babyInfoSavePath = [[self getDocumentDirectory] stringByAppendingPathComponent:@"userInfo.data"];
    return babyInfoSavePath;
}


/*！
 *@method   clearAllData
 *@abstract 清空所有内存、磁盘文件。
 *@discussion  注销时使用。
 */
- (void) clearAllData;
{
    //清空用户所有保存数据
    self.userInfo = [[PTUserEditInfoItem alloc] init];
    //清空磁盘
    [self updateToDisk];
    
    [super clearAllData];
}


#pragma mark - setter
- (void)setUserInfo:(PTUserEditInfoItem *)userInfo {
    _userInfo = userInfo;
    
    if (!_userInfo) {
        return;
    }
    
//    [[NSUserDefaults standardUserDefaults] setObject:_userInfo forKey:self.user.userID];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self updateToDisk];
}

@end
