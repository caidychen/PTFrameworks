//
//  PTLoginPasswordTextField.m
//  PTLatitude
//
//  Created by LiLiLiu on 15/11/30.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTLoginPasswordTextField.h"
#import "PassportMacro.h"

static CGFloat const PPT_EyeViewWH  = 40.0f;
static CGFloat const PPT_EyeButtonWH = 20.0f;


@interface PTLoginPasswordTextField ()<UITextFieldDelegate>
@property (nonatomic,strong) UIView *line;
@property (nonatomic,strong) UIView *eyeView;
@property (nonatomic,strong) UIImageView *eyeIcon;

@property (nonatomic,assign) BOOL isClickEye;
@end


@implementation PTLoginPasswordTextField
@synthesize textField = _textField;
@synthesize line = _line;
@synthesize eyeView = _eyeView;
@synthesize eyeIcon = _eyeIcon;

- (void)dealloc {
    PPTRELEASE(_textField);
    PPTRELEASE(_line);
    PPTRELEASE(_eyeView);
    PPTRELEASE(_eyeIcon);
    PPTSUPERDEALLOC();
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        _isClickEye = NO;
        
        [self addSubview:self.textField];
        [self addSubview:self.line];
        [self addSubview:self.eyeView];
        [self.eyeView addSubview:self.eyeIcon];
        
    }
    return (self);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textField.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds)-PPT_EyeViewWH-PPT_EyeButtonWH, CGRectGetHeight(self.bounds)-0.5);
    self.line.frame = CGRectMake(0, CGRectGetMaxY(self.textField.frame), CGRectGetWidth(self.bounds), 0.5);
    
    CGFloat yPoint = ceilf((CGRectGetHeight(self.bounds)-PPT_EyeViewWH)*0.5 );
    
    self.eyeView.frame = CGRectMake(CGRectGetWidth(self.bounds)-PPT_EyeViewWH-4, yPoint, PPT_EyeViewWH, PPT_EyeViewWH);
    self.eyeIcon.frame = CGRectMake(10, 10, PPT_EyeButtonWH, PPT_EyeButtonWH);
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
        _textField.returnKeyType = UIReturnKeyNext;
        _textField.secureTextEntry = YES;
        _textField.keyboardType = UIKeyboardTypeDefault;
        
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

- (UIView *)eyeView{
    if (!_eyeView) {
        _eyeView = [[UIView alloc] initWithFrame:CGRectZero];
        _eyeView.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer *eyeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(eyeTapEvent:)];
        [_eyeView addGestureRecognizer:eyeTap];
    }
    return _eyeView;
}

- (UIImageView *)eyeIcon{
    if (!_eyeIcon) {
        _eyeIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _eyeIcon.image = [UIImage imageNamed:@"icon_20_11"];
    }
    return _eyeIcon;
}

#pragma mark -

#pragma mark - setter
- (void)setDelegate:(id<UITextFieldDelegate>)delegate{
    if (delegate) {
        self.textField.delegate = delegate;
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


#pragma mark - action
- (void)eyeTapEvent:(UITapGestureRecognizer *) recongnizer{
    self.isClickEye = self.isClickEye?NO:YES;
    self.textField.secureTextEntry = self.isClickEye;
    
    if (self.isClickEye) {
        [self.eyeIcon setImage:[UIImage imageNamed:@"icon_20_11"]];
    }else{
        [self.eyeIcon setImage:[UIImage imageNamed:@"icon_20_10"]];
    }
    
}
#pragma mark -




#pragma mark - <UITextFieldDelegate>
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    BOOL flag = YES;
    
    if (textField == self.textField) {
        //得到真正当前输入的内容
         NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (toBeString.length >= Passport_passwordMinLength && toBeString.length <= Passport_passwordMaxLength) {
            if (self.actionBlock) {
                self.actionBlock(YES);
            }
        }else{
            if (self.actionBlock) {
                self.actionBlock(NO);
            }
            if (toBeString.length > Passport_passwordMaxLength) {
                flag = NO;
            }
        }
    }
    
    return flag;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //成为第一响应者
    if (self.actionBlock) {
        self.actionBlock(NO);
    }
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

//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//
//    if (textField == self.textField) {
//        if (textField.text.length >= passwordMinLength-1 && textField.text.length <= passwordMaxLength-1) {
//            if (self.actionBlock) {
//                self.actionBlock(YES);
//            }
//        }else{
//            if (self.actionBlock) {
//                self.actionBlock(NO);
//            }
//        }
//    }
//
//    
//    return YES;
//}



@end
