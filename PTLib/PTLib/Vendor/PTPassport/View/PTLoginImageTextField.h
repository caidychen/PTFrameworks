//
//  PTLoginImageTextField.h
//  PTLatitude
//
//  Created by LiLiLiu on 15/11/30.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PPTKit.h"

typedef void(^PTLoginImageTextFieldActionBlock)();

typedef void(^PTLoginImageTextFieldInputActionBlock)(NSString *text,BOOL isSuccess);

/**
 * @brief 登录页面 图形验证码输入框
 */
@interface PTLoginImageTextField : PPTBaseView

@property (nonatomic,assign) id<UITextFieldDelegate> delegate;
@property (nonatomic,strong)UITextField *textField;
@property (nonatomic,strong)NSString *placeholder;
@property (nonatomic,strong)NSString *codeImageUrl;

@property (nonatomic,copy) PTLoginImageTextFieldActionBlock imageTapActionBlock;

@property (nonatomic,copy) PTLoginImageTextFieldInputActionBlock inputActionBlock;

@end
