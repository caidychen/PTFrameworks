//
//  PTUserManager.h
//  PTLatitude
//
//  Created by LiLiLiu on 15/12/6.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "UserManager.h"
#import "PTUserEditInfoItem.h"

#define PTSHARE_USER [PTUserManager sharedInstance]
#define PTCURRENT_USER [PTUserManager sharedInstance].user
#define PTCURRENT_USERINFO [PTUserManager sharedInstance].userInfo

@interface PTUserManager : UserManager

@property (nonatomic,strong) PTUserEditInfoItem *userInfo;

@end
