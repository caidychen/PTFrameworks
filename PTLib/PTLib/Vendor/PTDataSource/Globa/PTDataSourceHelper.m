//
//  PTDataSourceHelper.m
//  PTLatitude
//
//  Created by so on 15/12/18.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTDataSourceHelper.h"
#import "PTDataSourceCheckItem.h"

NSString * PTDataSourceStringObjectFromDictionary(NSDictionary *dict, NSString *key) {
    if(!dict || !key || ![dict isKindOfClass:[NSDictionary class]]) {
        return (@"");
    }
    id value = [dict objectForKey:key];
    if(!value) {
        return (@"");
    }
    if(![value isKindOfClass:[NSString class]]) {
        return ([NSString stringWithFormat:@"%@", value]);
    }
    return (value);
}


NSString * PTDataSourceFilePath() {
    //避免提交出现 错误
    /*
     Your app has the UIFileSharingEnabled key set to true in the info.plist, but the Documents folder includes files and folders not intended for file sharing.
     解决方案
     
     修改重要文件(用户看不懂的文件)的存储路径 .
     关闭UIFileSharingEnabled
     
     */
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Datasource"];
    //    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Datasource"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]) {
        return (path);
    }
    NSError *error = nil;
    BOOL createDirectoryResult = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    if(!createDirectoryResult) {
        NSLog(@">>>create directory failed with error:%@", [error description]);
        return (nil);
    }
    return (path);
}

static NSString * const KeyPTDataSourceVersion = @"KeyPTDataSourceVersion";
static NSString * const PTDataSourceMinVersion = @"10000";

NSString * PTDataSourceCurrentVersion() {
    NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:KeyPTDataSourceVersion];
    if(!version || [version length] == 0) {
        version = PTDataSourceMinVersion;
    }
    return (version);
}

void PTDataSourceSetVersion(NSString *version) {
    [[NSUserDefaults standardUserDefaults] setObject:version forKey:KeyPTDataSourceVersion];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

NSString * PTDataSourceURLStringWithItemAndLevel(PTDataSourceCheckItem *item, PTDataSourceURLLevel level) {
    if(!item || ![item isKindOfClass:[PTDataSourceCheckItem class]]) {
        return (nil);
    }
    if(item.status != 200) {
        return (nil);
    }
    NSString *last_version = item.last_version;
    if(!last_version || last_version.length == 0) {
        return (nil);
    }
    NSString *currentVersion = PTDataSourceCurrentVersion();
    if([last_version integerValue] <= [currentVersion integerValue]) {
        return (nil);
    }
    switch (level) {
        case PTDataSourceURLLevel2:{
            if(!item.resource_server_bak) {
                return (nil);
            }
            NSString *URLString = [item.resource_server_bak stringByAppendingFormat:@"/patch_%@_%@.zip", currentVersion, last_version];
            return (URLString);
        }break;
        case PTDataSourceURLLevel3:{
            if(!item.resource_ip) {
                return (nil);
            }
            NSString *URLString = [item.resource_ip stringByAppendingFormat:@"/patch_%@_%@.zip", currentVersion, last_version];
            return (URLString);
        }break;
        case PTDataSourceURLLevel1:
        default:{
            if(!item.resource_server) {
                return (nil);
            }
            NSString *URLString = [item.resource_server stringByAppendingFormat:@"/patch_%@_%@.zip", currentVersion, last_version];
            return (URLString);
        }break;
    }
    return (nil);
}

