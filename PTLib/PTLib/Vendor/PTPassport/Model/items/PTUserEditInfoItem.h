//
//  PTUserEditInfoItem.h
//  PTLatitude
//
//  Created by LiLiLiu on 15/12/9.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PPTBaseItem.h"

/**
 * @brief 接口中返回的用户可编辑的信息
 * 4.1.2 查询用户个人信息
 */
@interface PTUserEditInfoItem : PPTBaseItem<NSCopying,NSCoding>

@property (copy , nonatomic) NSString *nick_name;      //昵称
@property (copy , nonatomic) NSString *head_img;       //头像地址
@property (copy , nonatomic) NSString *profile;        //个人简介


- (NSString*)description;

@end
