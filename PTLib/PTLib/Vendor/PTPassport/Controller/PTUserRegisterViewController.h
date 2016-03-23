//
//  PTUserRegisterViewController.h
//  PTLatitude
//
//  Created by LiLiLiu on 15/11/30.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PassportBaseViewController.h"
#import "PTPassportResponseItem.h"

typedef void(^PTUserRegisterViewControllerActionBlock)(BOOL isLoginSuccess,PTPassportResponseItem *responseItem);

/**
 * @brief 注册页面
 */
@interface PTUserRegisterViewController : PassportBaseViewController

@property (nonatomic,copy)PTUserRegisterViewControllerActionBlock actionBlock;

@end
