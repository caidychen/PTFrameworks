//
//  PTUserEditInfoItem.m
//  PTLatitude
//
//  Created by LiLiLiu on 15/12/9.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTUserEditInfoItem.h"
#import "PPTKit.h"

@implementation PTUserEditInfoItem


+ (instancetype)itemWithDict:(NSDictionary *)dict {
    PTUserEditInfoItem *item = [super itemWithDict:dict];
    if(!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return (item);
    }
    item.nick_name = [dict safeStringForKey:@"nick_name"];
    item.head_img = [dict safeStringForKey:@"head_img"];
    item.profile = [dict safeStringForKey:@"profile"];

    return (item);
}


- (instancetype)init {
    self = [super init];
    if(self) {
        _nick_name = _head_img = _profile = nil;
    }
    return (self);
}

//调试的时候输出自定义对象信息
- (NSString*) description
{
    NSMutableString* res = [NSMutableString stringWithFormat:@"nick_name = %@\n", self.nick_name];
    [res appendFormat:@"head_img = %@ \n",self.head_img];
    [res appendFormat:@"profile = %@ \n",self.profile];
    
    return res ;
}


#pragma mark - <NSCopying>
- (id)copyWithZone:(NSZone *)zone {
    PTUserEditInfoItem *item = [super copyWithZone:zone];
    item.nick_name = self.nick_name;
    item.head_img = self.head_img;
    item.profile = self.profile;
    
    return (self);
}
#pragma mark -



#pragma mark - <NSCoding>
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.nick_name forKey:@"nick_name"];
    [aCoder encodeObject:self.head_img forKey:@"head_img"];
    [aCoder encodeObject:self.profile forKey:@"profile"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    _nick_name = [aDecoder decodeObjectForKey:@"nick_name"];
    _head_img = [aDecoder decodeObjectForKey:@"head_img"];
    _profile = [aDecoder decodeObjectForKey:@"profile"];
    return (self);
}
#pragma mark -

@end
