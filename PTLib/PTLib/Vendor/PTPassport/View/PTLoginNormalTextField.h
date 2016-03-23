//
//  PTLoginNormalTextField.h
//  PTLatitude
//
//  Created by LiLiLiu on 15/11/30.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PPTKit.h"

typedef NS_ENUM(NSUInteger, PTLoginNormalTextFieldType) {
    PhoneTextFieldType,
    NumberTextFieldType,
    PasswordTextFieldType,
    CharacterTextFieldType
};

/**
 *  @return isSuccess 输入验证是否成功
 */
typedef void(^PTLoginNormalTextFieldActionBlock)(NSString *text,BOOL isSuccess);



/**
 * @brief 登录页面用到的普通输入框
 */
@interface PTLoginNormalTextField : PPTBaseView

@property (nonatomic,assign) PTLoginNormalTextFieldType type;
@property (nonatomic,strong)UITextField *textField;
@property (nonatomic,strong)NSString *placeholder;

@property (nonatomic,copy) PTLoginNormalTextFieldActionBlock actionBlock;

@end
