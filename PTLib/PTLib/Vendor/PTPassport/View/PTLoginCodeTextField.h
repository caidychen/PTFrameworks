//
//  PTLoginCodeTextField.h
//  PTLatitude
//
//  Created by LiLiLiu on 15/11/30.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PPTKit.h"

typedef void(^PTLoginCodeTextFieldBeFirstResponderAction)();
typedef void(^PTLoginCodeTextFieldActionBlock)(BOOL isSuccess);

/**
 * @brief 注册页面使用的 验证码输入框
 */
@interface PTLoginCodeTextField : PPTBaseView

@property (nonatomic,strong)UITextField *textField;
@property (nonatomic,strong)NSString *placeholder;
@property (nonatomic,assign)BOOL buttonUseable;    //获取验证码按钮是否可用

@property (nonatomic,assign,getter=isTimeOut) BOOL timeOut;  //是否正在进行倒计时


@property (nonatomic,copy)PTLoginCodeTextFieldBeFirstResponderAction firstResponderActionBlock;
@property (nonatomic,copy)PTLoginCodeTextFieldActionBlock actionBlock;


- (void)Timing;

@end
