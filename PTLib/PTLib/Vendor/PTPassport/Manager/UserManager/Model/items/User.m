//
//  User.m
//  PTLatitude
//
//  Created by LiLiLiu on 15/12/6.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "User.h"

@interface User()
@property(strong, nonatomic)NSNumber* systemMillisecondNumber;
@end

@implementation User


#pragma mark - getter
-(NSNumber*)systemMillisecondNumber
{
    if(!_systemMillisecondNumber){
        _systemMillisecondNumber = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]*1000];
    }
    return _systemMillisecondNumber;
}
#pragma mark - getter
-(void)setServerMillisecondNumber:(NSNumber *)serverMillisecondNumber
{
    
    _serverMillisecondNumber = serverMillisecondNumber;
    //需要重新同步
    _systemMillisecondNumber = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]*1000];
    
}

//调试的时候输出自定义对象信息
- (NSString*) description
{
    NSMutableString* res = [NSMutableString stringWithFormat:@"uid = %@\n", self.userID];
    [res appendFormat:@"userName = %@ \n",self.userName];
    [res appendFormat:@"userToken = %@ \n",self.userToken];
    
    return res ;
    
}

#pragma mark - <NSCopying>
- (id)copyWithZone:(nullable NSZone *)zone{
    User *item = [[[self class] allocWithZone:zone] init];
    item.userToken = self.userToken;
    item.userPassword = self.userPassword;
    item.userDeviceID = self.userDeviceID;
    item.userID = self.userID;
    item.userName = self.userName;
    item.userNick = self.userNick;
    item.userAvatar = self.userAvatar;
    return (item);
}
#pragma mark -


#pragma mark - <NSCoding>
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.userToken forKey:@"userToken"];
    [aCoder encodeObject:self.userPassword forKey:@"userPassword"];
    [aCoder encodeObject:self.userDeviceID forKey:@"userDeviceID"];
    [aCoder encodeObject:self.userID forKey:@"userID"];
    [aCoder encodeObject:self.userName forKey:@"userName"];
    [aCoder encodeObject:self.userNick forKey:@"userNick"];
    [aCoder encodeObject:self.userAvatar forKey:@"userAvatar"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    _userToken = [aDecoder decodeObjectForKey:@"userToken"];
    _userPassword = [aDecoder decodeObjectForKey:@"userPassword"];
    _userDeviceID = [aDecoder decodeObjectForKey:@"userDeviceID"];
    _userID = [aDecoder decodeObjectForKey:@"userID"];
    _userName = [aDecoder decodeObjectForKey:@"userName"];
    _userNick = [aDecoder decodeObjectForKey:@"userNick"];
    _userAvatar = [aDecoder decodeObjectForKey:@"userAvatar"];
    return (self);
}
#pragma mark -
@end
