//
//  PTLoginNormalTextField.m
//  PTLatitude
//
//  Created by LiLiLiu on 15/11/30.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTLoginNormalTextField.h"
#import "PassportMacro.h"

@interface PTLoginNormalTextField ()<UITextFieldDelegate>
@property (nonatomic,strong) UIView *line;
@end

@implementation PTLoginNormalTextField
@synthesize textField = _textField;
@synthesize line = _line;

- (void)dealloc {
    PPTRELEASE(_textField);
    PPTRELEASE(_line);
    PPTSUPERDEALLOC();
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self addSubview:self.textField];
        [self addSubview:self.line];
    }
    return (self);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textField.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds) , CGRectGetHeight(self.bounds)-0.5);
    self.line.frame = CGRectMake(0, CGRectGetMaxY(self.textField.frame), CGRectGetWidth(self.bounds), 0.5);
}

#pragma mark - getter
- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.textColor = [UIColor blackColor];
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.font = [UIFont systemFontOfSize:16];
        _textField.textAlignment = NSTextAlignmentLeft;
        
        _textField.delegate = self;
    }
    return _textField;
}

- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectZero];
        _line.backgroundColor = Passport_TEXT_INPUT_LINE_COLOR;
    }
    return _line;
}
#pragma mark -

#pragma mark - setter
- (void)setType:(PTLoginNormalTextFieldType)type{
    _type = type;
    
    switch (_type) {
        case PhoneTextFieldType:{
            _textField.returnKeyType = UIReturnKeyNext;
            _textField.secureTextEntry = NO;
            _textField.keyboardType = UIKeyboardTypePhonePad;
        }break;
        case NumberTextFieldType:
        {
            _textField.returnKeyType = UIReturnKeyNext;
            _textField.secureTextEntry = NO;
            _textField.keyboardType = UIKeyboardTypeNumberPad;
        }
            break;
        case PasswordTextFieldType:
        {
            _textField.returnKeyType = UIReturnKeyNext;
            _textField.secureTextEntry = YES;
            _textField.keyboardType = UIKeyboardTypeDefault;
        }
            break;
        case CharacterTextFieldType:
        {
            _textField.returnKeyType = UIReturnKeyNext;
            _textField.secureTextEntry = NO;
            _textField.keyboardType = UIKeyboardTypeDefault;
        }
            break;
        default:
            break;
    }
}


- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    
    if (!_placeholder) {
        return;
    }
    
    self.textField.placeholder = _placeholder;
}
#pragma mark -


#pragma mark - <UITextFieldDelegate>
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //成为第一响应者
    switch (self.type) {
        case PhoneTextFieldType:{}break;
        case NumberTextFieldType:{}break;
        case PasswordTextFieldType:{
            //密码框获取焦点, 验证手机号码输入框是否正确
            if (self.actionBlock) {
                self.actionBlock(@"responder",NO);
            }
            
        }break;
        case CharacterTextFieldType:{}break;
        default:break;
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //对输入手机号码进行各种验证
    //正则验证
    switch (self.type) {
        case PhoneTextFieldType:{
            //对手机号码长度进行验证
            if (toBeString.length > Passport_phoneNumberMaxLength && range.length!=1){
                textField.text = [toBeString substringToIndex:Passport_phoneNumberMaxLength];
                return NO;
            }
        }break;
        case NumberTextFieldType:{}break;
        case PasswordTextFieldType:{
            //对密码长度进行验证
            if (toBeString.length >= Passport_passwordMinLength && toBeString.length <= Passport_passwordMaxLength) {
                if (self.actionBlock) {
                    self.actionBlock(@"password",YES);
                }
            }else{
                if (self.actionBlock) {
                    self.actionBlock(@"password",NO);
                }
                
                if (toBeString.length > Passport_passwordMaxLength) {
                    return NO;
                }
            }
            
        }break;
        case CharacterTextFieldType:{}break;
        default:break;
    }
    
    
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (self.textField == textField) {
        NSString *textInput =  self.textField.text;
        if (0 == textInput.length) {
            self.textField.placeholder = self.placeholder;
        }else{
            self.textField.placeholder = @"";
        }
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    NSLog(@"回车");
//    NSString *toBeString = textField.text;
    switch (self.type) {
        case PhoneTextFieldType:{}break;
        case NumberTextFieldType:{}break;
        case PasswordTextFieldType:{
            //密码输入完毕,点击 Next 按钮直接可以登录
            if (textField == self.textField) {
                if (textField.text.length >= Passport_passwordMinLength-1 && textField.text.length <= Passport_passwordMaxLength-1) {
                    if (self.actionBlock) {
                        self.actionBlock(@"login",YES);
                    }
                }
            }
            
        }break;
        case CharacterTextFieldType:{}break;
        default:break;
    }
    
    return YES;
}


@end
