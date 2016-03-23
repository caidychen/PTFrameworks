//
//  PTUserAddInfoViewController.h
//  PTLatitude
//
//  Created by LiLiLiu on 15/11/30.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PassportBaseViewController.h"
#import "PTPassportResponseItem.h"

/**
 * @brief 完善用户信息
 */
@interface PTUserAddInfoViewController : PassportBaseViewController

@property (nonatomic, copy) NSString *userPhone;
@property (nonatomic, copy) NSString *userPassword;
@property (nonatomic, copy) PTPassportResponseItem *passportResponseItem;

@end
