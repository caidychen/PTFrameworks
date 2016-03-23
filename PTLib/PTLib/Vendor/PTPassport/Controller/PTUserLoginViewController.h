//
//  PTUserLoginViewController.h
//  PTLatitude
//
//  Created by LiLiLiu on 15/11/30.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PassportBaseViewController.h"
#import "PTPassportResponseItem.h"

typedef void(^PTUserLoginViewControllerActionBlock)(BOOL isLoginSuccess,PTPassportResponseItem *responseItem);


@class PTUserLoginViewController;

/**
 *  @brief  弹出登录视图
 *
 *  @return 返回登录控制器
 */
PTUserLoginViewController * PTPresentLoginViewControllerAnimated(UIViewController *baseViewController, BOOL animated, void(^resultBlock)(BOOL success, PTPassportResponseItem *responseItem));


/**
 * @brief 登录页面
 */
@interface PTUserLoginViewController : PassportBaseViewController

@property (nonatomic,copy)PTUserLoginViewControllerActionBlock actionBlock;

@end
