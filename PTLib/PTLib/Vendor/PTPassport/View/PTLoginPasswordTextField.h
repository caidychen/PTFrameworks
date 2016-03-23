//
//  PTLoginPasswordTextField.h
//  PTLatitude
//
//  Created by LiLiLiu on 15/11/30.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PPTKit.h"


typedef void(^PTLoginPasswordTextFieldActionBlock)(BOOL flag);



/**
 * @brief 注册页面使用的 登录密码 (带眼睛,查看密码功能)
 */
@interface PTLoginPasswordTextField : PPTBaseView

@property (nonatomic,strong)UITextField *textField;
@property (nonatomic,strong)NSString *placeholder;
@property (nonatomic,copy) PTLoginPasswordTextFieldActionBlock actionBlock;

@end
