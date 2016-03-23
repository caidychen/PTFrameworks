//
//  PTDataSourceCheckItem.m
//  PTLatitude
//
//  Created by so on 15/12/18.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTDataSourceCheckItem.h"

@implementation PTDataSourceCheckItem

+ (instancetype)itemWithDictionary:(NSDictionary *)dict {
    PTDataSourceCheckItem *item = [super itemWithDictionary:dict];
    item.status = [PTDataSourceStringObjectFromDictionary(dict, @"status") integerValue];
    item.msg = PTDataSourceStringObjectFromDictionary(dict, @"msg");
    NSDictionary *data = [dict objectForKey:@"data"];
    item.last_version = PTDataSourceStringObjectFromDictionary(data, @"last_version");
    item.last_resource_version = PTDataSourceStringObjectFromDictionary(data, @"last_resource_version");
    item.resource_server = PTDataSourceStringObjectFromDictionary(data, @"resource_server");
    item.resource_server_bak = PTDataSourceStringObjectFromDictionary(data, @"resource_server_bak");
    item.resource_ip = PTDataSourceStringObjectFromDictionary(data, @"resource_ip");
    return (item);
}

- (instancetype)init {
    self = [super init];
    if(self) {
        _status = 0;
        _msg = nil;
        _last_version = _last_resource_version = nil;
        _resource_server = _resource_server_bak = _resource_ip = nil;
    }
    return (self);
}

- (NSString *)description {
    NSMutableString *mtlStr = [NSMutableString stringWithString:[super description]];
    [mtlStr replaceOccurrencesOfString:@"\n}" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, mtlStr.length)];
    
    [mtlStr appendFormat:@"\n\tstatus = %@; ", @(self.status)];
    [mtlStr appendFormat:@"\n\tmsg = %@; ", self.msg];
    [mtlStr appendFormat:@"\n\tlast_version = %@; ", self.last_version];
    [mtlStr appendFormat:@"\n\tlast_resource_version = %@; ", self.last_resource_version];
    [mtlStr appendFormat:@"\n\tresource_server = %@; ", self.resource_server];
    [mtlStr appendFormat:@"\n\tresource_server_bak = %@; ", self.resource_server_bak];
    [mtlStr appendFormat:@"\n\tresource_ip = %@;", self.resource_ip];
    [mtlStr appendFormat:@"\n}"];
    return (mtlStr);
}

#pragma mark - <NSCopying>
- (id)copyWithZone:(NSZone *)zone {
    PTDataSourceCheckItem *item = [super copyWithZone:zone];
    item.status = self.status;
    item.msg = self.msg;
    item.last_version = self.last_version;
    item.last_resource_version = self.last_resource_version;
    item.resource_server = self.resource_server;
    item.resource_server_bak = self.resource_server_bak;
    item.resource_ip = self.resource_ip;
    return (item);
}
#pragma mark -

@end
