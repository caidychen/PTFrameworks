//
//  PTLoginCodeTextField.m
//  PTLatitude
//
//  Created by LiLiLiu on 15/11/30.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTLoginCodeTextField.h"
#import "PassportMacro.h"

static CGFloat const PPT_codeButtonWidth = 80.0f;
static CGFloat const PPT_codeButtonHeight = 24.0f;


@interface PTLoginCodeTextField ()<UITextFieldDelegate>{
//    NSTimer         *_showTimer;            //动画展示
    int              _timeCount;            //超时时间
}
@property (nonatomic,strong) UIView *line;
@property (nonatomic,strong) UIView *vline;   //垂直分隔线
@property (nonatomic,strong) UIButton *btnGetCode;           //发送验证码按钮
@property (nonatomic,strong) UILabel *btnMessage; //倒计时提示

@end


@implementation PTLoginCodeTextField


@synthesize textField = _textField;
@synthesize line = _line;
@synthesize vline = _vline;
@synthesize btnGetCode = _btnGetCode;
@synthesize btnMessage = _btnMessage;

- (void)dealloc {
    PPTRELEASE(_textField);
    PPTRELEASE(_line);
    PPTRELEASE(_vline);
    PPTRELEASE(_btnGetCode);
    PPTRELEASE(_btnMessage);
    PPTSUPERDEALLOC();
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        _timeCount = 60;
        _timeOut = NO;
        
        [self addSubview:self.textField];
        [self addSubview:self.line];
        [self addSubview:self.vline];
        [self addSubview:self.btnGetCode];
    }
    return (self);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textField.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds)-PPT_codeButtonWidth, CGRectGetHeight(self.bounds)-0.5);
    self.line.frame = CGRectMake(0, CGRectGetMaxY(self.textField.frame), CGRectGetWidth(self.bounds), 0.5);
    CGFloat vlineY = ceilf((CGRectGetHeight(self.bounds)-PPT_codeButtonHeight)*0.5);
    self.vline.frame = CGRectMake(CGRectGetMaxX(self.textField.frame), vlineY, 0.5, PPT_codeButtonHeight);
    
    self.btnGetCode.frame = CGRectMake(CGRectGetMaxX(self.vline.frame), vlineY, PPT_codeButtonWidth, PPT_codeButtonHeight);
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
        _textField.secureTextEntry = NO;
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

- (UIView *)vline{
    if (!_vline) {
        _vline = [[UIView alloc] initWithFrame:CGRectZero];
        _vline.backgroundColor = Passport_TEXT_INPUT_LINE_COLOR;
    }
    return _vline;
}


- (UIButton *)btnGetCode{
    if (!_btnGetCode) {
        _btnGetCode = [[UIButton alloc] initWithFrame:CGRectZero];
        [_btnGetCode setTitleColor:[UIColor colorWithHexString:@"b57de4"] forState:UIControlStateHighlighted];
        [_btnGetCode setTitleColor:Passport_THEME_COLOR forState:UIControlStateNormal];
        
        [_btnGetCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        _btnGetCode.titleLabel.font = [UIFont systemFontOfSize:12];
        _btnGetCode.userInteractionEnabled = YES;
        [_btnGetCode addTarget:self action:@selector(onGetCodeButtonPress) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnGetCode;
}

- (UILabel *)btnMessage{
    if (!_btnMessage) {
        _btnMessage =  [[UILabel alloc] initWithFrame:CGRectZero];
        _btnMessage.textAlignment = NSTextAlignmentLeft;
        _btnMessage.textColor = [UIColor colorWithHexString:@"c2c2c2"];
        _btnMessage.font = [UIFont systemFontOfSize:12.0f];
        _btnMessage.numberOfLines = 0;
    }
    return _btnMessage;
}

- (BOOL)isTimeOut{
    return _timeOut;
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

- (void)setButtonUseable:(BOOL)buttonUseable{
    _buttonUseable = buttonUseable;
    
    if (_buttonUseable) {
        [_btnGetCode setTitleColor:Passport_THEME_COLOR forState:UIControlStateNormal];
        [_btnGetCode setTitleColor:[UIColor colorWithHexString:@"b57de4"] forState:UIControlStateHighlighted];
        _btnGetCode.enabled = YES;
        _btnGetCode.userInteractionEnabled = YES;
    }else{
        [_btnGetCode setTitleColor:[UIColor colorWithHexString:@"c2c2c2"] forState:UIControlStateNormal];
        _btnGetCode.enabled = NO;
        _btnGetCode.userInteractionEnabled = NO;
    }
}
#pragma mark -


#pragma mark - action
- (void)onGetCodeButtonPress{
    //如果按钮能够点击改变按钮状态
//    [self showTimeCount];
    
    //把倒计时控制放在 控制器中
    if (self.actionBlock) {
        self.actionBlock(self.timeOut);
    }
}


#pragma mark - <UITextFieldDelegate>
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.firstResponderActionBlock) {
        self.firstResponderActionBlock();
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
#pragma mark -


//显示倒计时
//- (void)showTimeCount
//{
//    //验证码相应
//    [self.textField becomeFirstResponder];
//    
//    _showTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(Timing) userInfo:nil repeats:YES];
//    [_showTimer fire];
//}

//读秒
- (void)Timing{
   
    //倒计时到了,结束计时器,恢复前面状态
    if (_timeCount == 0) {
        
//        [_showTimer invalidate];
        _timeCount = 60;
        self.timeOut = YES;  //超时了
        
        self.btnGetCode.hidden = NO;
        [self.btnMessage removeFromSuperview];
        
        return;
    }

    self.btnGetCode.hidden = YES;
    NSString *buttonTitle = [NSString stringWithFormat:@"获取验证码\n(%lds后重发)", (long)_timeCount--];
    self.btnMessage.text = buttonTitle;
    CGSize textSize = [buttonTitle soSizeWithFont:self.btnMessage.font constrainedToWidth:PPT_codeButtonWidth];
    CGFloat vlineY = ceilf((CGRectGetHeight(self.bounds)-PPT_codeButtonHeight)*0.5);
    self.btnMessage.frame = CGRectMake(CGRectGetMaxX(self.vline.frame)+10.0f, vlineY, textSize.width, textSize.height);
    [self addSubview:self.btnMessage];
}
#pragma mark -

@end
