//
//  PTDataSourceParseRegionOperation.m
//  PTLatitude
//
//  Created by so on 15/12/29.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTDataSourceParseRegionOperation.h"
#import "PTDataSourceHelper.h"

@implementation PTDataSourceParseRegionOperation

- (instancetype)init {
    self = [super init];
    if(self) {
        _regionItems = nil;
    }
    return (self);
}

- (void)main {
    @autoreleasepool {
        
        NSString *filePath = PTDataSourceFilePath();
        if(!filePath || filePath.length == 0) {
            return;
        }
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if(![fileManager isExecutableFileAtPath:filePath]) {
            return;
        }
        
        NSString *unZipFilePath = [filePath stringByAppendingPathComponent:PTDataSourceCurrentVersion()];
        if(!unZipFilePath || unZipFilePath.length == 0) {
            return;
        }
        
        if(![fileManager isExecutableFileAtPath:unZipFilePath]) {
            return;
        }
        
        NSString *regionPath = [unZipFilePath stringByAppendingPathComponent:@"region"];
        if(!regionPath || regionPath.length == 0) {
            return;
        }
        
        if(![fileManager isExecutableFileAtPath:regionPath]) {
            return;
        }
        
        NSString *jsonPath = [regionPath stringByAppendingPathComponent:@"region.json"];
        if(!jsonPath || jsonPath.length == 0) {
            return;
        }
        
        NSData *jsonData = [[NSData alloc] initWithContentsOfFile:jsonPath];
        if([NSJSONSerialization isValidJSONObject:jsonData]) {
            return;
        }
        NSError *jsonError = nil;
        NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithDictionary:[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError]];
        if(jsonError) {
            jsonDict = nil;
            return;
        }
        jsonData = nil;
        
        if(!jsonDict || ![jsonDict isKindOfClass:[NSDictionary class]]) {
            return;
        }
        
        NSString *pKey = @"100000";
        NSArray *pArr = [jsonDict objectForKey:pKey];
        if(!pArr || [pArr count] == 0) {
            return;
        }
        [jsonDict removeObjectForKey:pKey];
        
        NSMutableArray *pItems = [NSMutableArray array];
        for(NSDictionary *pDict in pArr) {
            @autoreleasepool {
                
                PTRegionItem *pItem = [PTRegionItem itemWithDictionary:pDict];
                [pItems addObject:pItem];
                
                NSMutableArray *cItems = [NSMutableArray array];
                NSArray *cArr = [jsonDict objectForKey:pItem.itemID];
                for(NSDictionary *cDict in cArr) {
                    
                    @autoreleasepool {
                        PTRegionItem *cItem = [PTRegionItem itemWithDictionary:cDict];
                        [cItems addObject:cItem];
                        
                        NSMutableArray *aItems = [NSMutableArray array];
                        NSArray *aArr = [jsonDict objectForKey:cItem.itemID];
                        for(NSDictionary *aDict in aArr) {
                            PTRegionItem *aItem = [PTRegionItem itemWithDictionary:aDict];
                            [aItems addObject:aItem];
                        }
                        
                        cItem.items = [aItems copy];
                    }
                    
                }
                
                pItem.items = [cItems copy];
                
            }
        }
        
        self.regionItems = [pItems copy];
    }
}

@end
