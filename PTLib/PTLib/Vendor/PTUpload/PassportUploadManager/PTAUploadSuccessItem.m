//
//  PTAUploadSuccessItem.m
//  PTLatitude
//
//  Created by LiLiLiu on 15/12/9.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTAUploadSuccessItem.h"

@implementation PTAUploadSuccessItem

#pragma mark - 解析服务器返回 JSON 数据的方法
+ (instancetype)itemWithDict:(NSDictionary *)dict {
    PTAUploadSuccessItem *item = [super itemWithDict:dict];
    if(!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return (item);
    }
    item.ext = [dict safeStringForKey:@"ext"];
    item.filename = [dict safeStringForKey:@"filename"];
    item.filehash = [dict safeStringForKey:@"hash"];
    item.height = [dict safeStringForKey:@"height"];
    item.width = [dict safeStringForKey:@"width"];
    
    return (item);
}

- (instancetype)init {
    self = [super init];
    if(self) {
        _ext = _filehash = _filename = _height = _width = nil;
    }
    return (self);
}


#pragma mark - <NSCopying>
- (id)copyWithZone:(nullable NSZone *)zone{
    PTAUploadSuccessItem *item = [super copyWithZone:zone];
    item.ext = self.ext;
    item.filehash = self.filehash;
    item.filename = self.filename;
    item.height = self.height;
    item.width = self.width;
    
    return (item);
}
#pragma mark -

@end
