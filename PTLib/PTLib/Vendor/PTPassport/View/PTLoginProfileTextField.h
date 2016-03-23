//
//  PTLoginProfileTextField.h
//  PTLatitude
//
//  Created by LiLiLiu on 15/12/9.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PPTKit.h"

typedef void(^PTLoginProfileTextFieldActionBlock)(CGRect textViewFrame);    //改变输入框高度的回调
typedef void(^PTLoginProfileTextFieldRequestActionBlock)(NSString *text);   //输入<发送>按钮提交输入内容

/**
 * @brief 完善用户信息页面,用户个人信息输入框，能够随输入文字动态改变高度
 */
@interface PTLoginProfileTextField : PPTBaseView

@property (nonatomic,strong)UITextField *textField;
@property (nonatomic,strong)NSString *placeholder;

@property (nonatomic,copy)PTLoginProfileTextFieldActionBlock actionBlock;
@property (nonatomic,copy)PTLoginProfileTextFieldRequestActionBlock requestActionBlock;


@end
