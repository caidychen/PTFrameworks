//
//  PTUserForgetPasswordViewController.m
//  PTLatitude
//
//  Created by LiLiLiu on 15/11/30.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTUserForgetPasswordViewController.h"

//Model
#import "PTPassport.h"
#import "PassportUtilTool.h"
#import "PTUserManager.h"


//View
#import "PPTAutoHideMessageView.h"
#import "PTLoginNormalTextField.h"
#import "PTLoginImageTextField.h"
#import "PTLoginCodeTextField.h"
#import "PTLoginPasswordTextField.h"
#import "PassportMacro.h"

static CGFloat const ForgetPasswordViewInsets = 10.0f;

@interface PTUserForgetPasswordViewController (){
    NSTimer         *_showTimer;            //动画展示
}


@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) PTLoginNormalTextField *phoneTextField;
@property (nonatomic, strong) PTLoginImageTextField *imageCodeField;   //图形验证码
@property (nonatomic, strong) PTLoginCodeTextField *messageCodeField;
@property (nonatomic, strong) PTLoginPasswordTextField *passwordField;
@property (nonatomic, strong) UIButton *finishStepButton;

@property (nonatomic, assign) BOOL isShowImageCode;     //是否显示图形验证码
@property (strong, nonatomic, readonly) UIActivityIndicatorView *activityView;
@end

@implementation PTUserForgetPasswordViewController
@synthesize backgroundView = _backgroundView;
@synthesize phoneTextField = _phoneTextField;
@synthesize imageCodeField = _imageCodeField;
@synthesize messageCodeField = _messageCodeField;
@synthesize passwordField = _passwordField;
@synthesize finishStepButton = _finishStepButton;
@synthesize activityView = _activityView;

- (void)dealloc {
    PPTRELEASE(_backgroundView);
    PPTRELEASE(_phoneTextField);
    PPTRELEASE(_imageCodeField);
    PPTRELEASE(_messageCodeField);
    PPTRELEASE(_finishStepButton);
    PPTRELEASE(_activityView);
    PPTSUPERDEALLOC();
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        _isShowImageCode = NO;  //是否输入过 图形验证码
        _showTimer = nil;
    }
    return (self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ptLoadingView.alpha = 0.4f;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"EBEBEB"];
    [self setTitle:@"忘记密码" color:[UIColor colorWithHexString:@"313131"] font:[UIFont systemFontOfSize:18.0f] selector:nil];
    
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.phoneTextField];
    
    [self.view addSubview:self.messageCodeField];
    [self.view addSubview:self.passwordField];
    [self.view addSubview:self.finishStepButton];
    [self.view addSubview:self.activityView];
    
    [self.view addSubview:self.imageCodeField];
    
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat textFieldWidth = Passport_Screenwidth-10*2;
    CGFloat textFieldHeight = 44.0f;
    CGFloat yPoint = Passport_HEIGHT_STATUS+Passport_HEIGHT_NAV+ForgetPasswordViewInsets;
    
    
    self.phoneTextField.frame = CGRectMake(10, yPoint, textFieldWidth , textFieldHeight);
    
    self.backgroundView.frame = CGRectMake(0, yPoint, CGRectGetWidth(self.view.bounds), 44.0f*4);
    self.imageCodeField.frame = CGRectMake(10, CGRectGetMaxY(self.phoneTextField.frame), textFieldWidth, textFieldHeight);
    self.messageCodeField.frame = CGRectMake(10, CGRectGetMaxY(self.imageCodeField.frame), textFieldWidth, textFieldHeight);
    
    self.passwordField.frame = CGRectMake(10, CGRectGetMaxY(self.messageCodeField.frame), textFieldWidth, textFieldHeight);
    
    self.finishStepButton.frame = CGRectMake(0, 0, Passport_Screenwidth-32, textFieldHeight);
    self.finishStepButton.center = CGPointMake(Passport_Screenwidth/2, CGRectGetMaxY(self.passwordField.frame)+ForgetPasswordViewInsets*4);
    
    self.activityView.center = self.finishStepButton.center;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.phoneTextField.textField becomeFirstResponder];
    
    //将倒计时清空,恢复按钮状态
    if (_showTimer && [_showTimer isValid]) {
        [_showTimer invalidate];
    }
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self resignAllResponder];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}


#pragma mark - getters
- (UIView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        _backgroundView.backgroundColor = [UIColor whiteColor];
    }
    return _backgroundView;
}

- (PTLoginNormalTextField *)phoneTextField{
    if (!_phoneTextField) {
        _phoneTextField = [[PTLoginNormalTextField alloc] initWithFrame:CGRectZero];
        _phoneTextField.type = PhoneTextFieldType;
        _phoneTextField.placeholder = @"手机号码";
        _phoneTextField.actionBlock = ^(NSString *text ,BOOL isSuccess){
            //回调
        };
    }
    return _phoneTextField;
}

- (PTLoginImageTextField *)imageCodeField{
    if (!_imageCodeField) {
        _imageCodeField = [[PTLoginImageTextField alloc] initWithFrame:CGRectZero];
        _imageCodeField.placeholder = @"图形验证码";
        _imageCodeField.codeImageUrl = [PTPassport passportSendImageVerifyCodeWithAction:@"forget"];
        
        __weak typeof(self) weak_self = self;
        _imageCodeField.imageTapActionBlock = ^(){
            [weak_self getNewImageCode];
        };
        
        _imageCodeField.inputActionBlock = ^(NSString *text,BOOL isSuccess){
            if (isSuccess) {
                weak_self.messageCodeField.buttonUseable = YES;
            }else{
                weak_self.messageCodeField.buttonUseable = NO;
            }
        };
    }
    return _imageCodeField;
}


- (PTLoginCodeTextField *)messageCodeField{
    if (!_messageCodeField) {
        _messageCodeField = [[PTLoginCodeTextField alloc] initWithFrame:CGRectZero];
        _messageCodeField.placeholder = @"短信验证码";
        _messageCodeField.buttonUseable = NO;    //默认禁用 获取验证码按钮
        
        __weak typeof(self) weakSelf = self;
        //成为第一响应者后回调
        _messageCodeField.firstResponderActionBlock = ^(){
            weakSelf.messageCodeField.buttonUseable = YES;
        };
        
        //点击 获取验证码 后回调
        _messageCodeField.actionBlock = ^(BOOL isSuccess){
            [weakSelf checkPhoneNumber];
        };
    }
    return _messageCodeField;
}


- (PTLoginPasswordTextField *)passwordField{
    if (!_passwordField) {
        _passwordField = [[PTLoginPasswordTextField alloc] initWithFrame:CGRectZero];
        _passwordField.placeholder = @"新密码(6-18位)";
        
        __weak typeof(self) weakSelf = self;
        _passwordField.actionBlock = ^(BOOL flag){
            if (flag) {
                [weakSelf.finishStepButton setBackgroundImage:[UIImage imageNamed:@"btn_big_nor"] forState:UIControlStateNormal];
                [weakSelf.finishStepButton setBackgroundImage:[UIImage imageNamed:@"btn_big_nor"] forState:UIControlStateHighlighted];
                weakSelf.finishStepButton.userInteractionEnabled = YES;
            }else{
                [weakSelf.finishStepButton setBackgroundImage:[UIImage imageNamed:@"btn_big_dis"] forState:UIControlStateNormal];
                [weakSelf.finishStepButton setBackgroundImage:[UIImage imageNamed:@"btn_big_dis"] forState:UIControlStateHighlighted];
                weakSelf.finishStepButton.userInteractionEnabled = NO;
                
                //这里验证验证码是否输入正确
                [weakSelf checkCodeNumber];
            }
            
        };
    }
    return _passwordField;
}


- (UIButton *)finishStepButton{
    if (!_finishStepButton) {
        _finishStepButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _finishStepButton.clipsToBounds = YES;
        _finishStepButton.layer.cornerRadius = 4;
        [_finishStepButton setTitleColor:[UIColor colorWithHexString:@"FFFFFF"] forState:UIControlStateNormal];
        [_finishStepButton setTitleColor:[UIColor colorWithHexString:@"FFFFFF"] forState:UIControlStateHighlighted];
        [_finishStepButton setBackgroundImage:[UIImage imageNamed:@"btn_big_dis"] forState:UIControlStateNormal];
        [_finishStepButton setBackgroundImage:[UIImage imageNamed:@"btn_big_dis"] forState:UIControlStateHighlighted];
        [_finishStepButton setTitle:@"完成" forState:UIControlStateNormal];
        _finishStepButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_finishStepButton addTarget:self action:@selector(onFinishButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _finishStepButton.userInteractionEnabled = NO;
    }
    
    return _finishStepButton;
}

/**
 * @brief 点击登录按钮时，启动加载
 */
- (UIActivityIndicatorView *)activityView {
    if(!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityView.color = [UIColor colorWithHexString:@"985ec9"];
        _activityView.hidesWhenStopped = YES;
    }
    return (_activityView);
}
#pragma mark -



#pragma mark - setter
- (void)showLoading:(BOOL)loading {
    if(loading) {
        [self.activityView startAnimating];
    } else {
        [self.activityView stopAnimating];
    }
    self.finishStepButton.enabled = !loading;
    [self.view setNeedsLayout];
}
#pragma mark -



#pragma mark - action
//验证手机号码
- (void)checkPhoneNumber{
    [self resignAllResponder];
    
    NSString *phone = self.phoneTextField.textField.text;
    NSString *imageCode = self.imageCodeField.textField.text;
    
    NSMutableString *message = [[NSMutableString alloc] init];
    if ([PassportUtilTool isEmpty:phone]) {
        [message appendString:@"手机号码不能为空"];
        [self.phoneTextField.textField becomeFirstResponder];
        [PPTAutoHideMessageView showMessage:[NSString stringWithString:message] inView:self.view];
        return;
    }
    
    if(![PassportUtilTool isMobileNumber:phone]){
        [message appendString:@"请输入完整手机号码"];
        [self.phoneTextField.textField becomeFirstResponder];
        [PPTAutoHideMessageView showMessage:[NSString stringWithString:message] inView:self.view];
        return;
    }
    
    if ([PassportUtilTool isEmpty:imageCode]) {
        [message appendString:@"图形验证码不能为空"];
        [self.imageCodeField.textField becomeFirstResponder];
        [PPTAutoHideMessageView showMessage:[NSString stringWithString:message] inView:self.view];
        return;
    }
    
    //Passport 手机注册与否验证
    __weak typeof(self) weak_self = self;
    [PTPassport passportVerifyPhoneNumberExistWithPhoneNumber:[phone trim] success:^(PTPassportResponseItem *responseItem) {
        if (responseItem.errorCode == 61005 ){
            //OK,无任何返回描述，手机号码存在
            [weak_self sendCodeNumber];
        }else if (responseItem.errorCode == 61001 || responseItem.errorCode == 61009 || responseItem.errorCode == 61010) {
            //手机号码已存在,手机号为空,手机号错误
            //这里不进行提示
            NSString *errorMessage = [NSString stringWithFormat:@"%@",PTPassportErrorCodeDescription(responseItem.errorCode)];
            [PPTAutoHideMessageView showMessage:[NSString stringWithString:errorMessage] inView:self.view];
            
            [weak_self getNewImageCode];
            
            weak_self.phoneTextField.textField.text = @"";
            weak_self.imageCodeField.textField.text = @"";
            weak_self.messageCodeField.textField.text = @"";
            
            weak_self.phoneTextField.textField.placeholder = @"手机号码";
            [weak_self.phoneTextField.textField becomeFirstResponder];
        }else {
            //这里是未针对手机号码定义的状态码
            NSString *errorMessage = @"号码不存在,请输入正确的手机号码";
            [PPTAutoHideMessageView showMessage:[NSString stringWithString:errorMessage] inView:weak_self.view];
            
            [weak_self getNewImageCode];
            
            weak_self.phoneTextField.textField.text = @"";
            weak_self.imageCodeField.textField.text = @"";
            weak_self.messageCodeField.textField.text = @"";
            
            weak_self.phoneTextField.textField.placeholder = @"手机号码";
            [weak_self.phoneTextField.textField becomeFirstResponder];
        }
        
    } failure:^(NSError *error) {
        [PPTAutoHideMessageView showMessage:@"您的网络不给力" inView:weak_self.view];
        
        [weak_self getNewImageCode];
        
        weak_self.phoneTextField.textField.text = @"";
        weak_self.imageCodeField.textField.text = @"";
        weak_self.messageCodeField.textField.text = @"";
        
        weak_self.phoneTextField.textField.placeholder = @"手机号码";
        [weak_self.phoneTextField.textField becomeFirstResponder];
    }];
    return;
    
    
}


//验证验证码
- (void)checkCodeNumber{
    NSString *codeNumber = self.messageCodeField.textField.text;
    NSMutableString *message = [[NSMutableString alloc] init];
    if ([PassportUtilTool isEmpty:codeNumber]) {
        [message appendString:@"验证码不能为空"];
        [self.messageCodeField.textField becomeFirstResponder];
        [PPTAutoHideMessageView showMessage:[NSString stringWithString:message] inView:self.view];
    }
}


//发送验证码
- (void)sendCodeNumber{
    [self resignAllResponder];
    
    NSString *phone = self.phoneTextField.textField.text;
    NSString *imageCode = self.imageCodeField.textField.text;

    __weak typeof(self)weakSelf = self;
    [PTPassport passportSafeSendVerifyCodeWithPhoneNumber:[phone trim] verify:[imageCode trim] action:@"forget" success:^(PTPassportResponseItem *responseItem) {
        if (responseItem.errorCode == 0) {
            [weakSelf showTimeCount]; //开始倒计时
            [PPTAutoHideMessageView showMessage:@"短信已发送，请查收!" inView:weakSelf.view];
        }else {
            NSString *errorMessage = [NSString stringWithFormat:@"%@",PTPassportErrorCodeDescription(responseItem.errorCode)];
            [PPTAutoHideMessageView showMessage:[NSString stringWithString:errorMessage] inView:weakSelf.view];
            
            //刷新图形验证码
            [weakSelf getNewImageCode];     //刷新验证码
            
            //光标会到图形验证码输入框
            weakSelf.imageCodeField.textField.text = @"";
            weakSelf.messageCodeField.textField.text = @"";
            weakSelf.imageCodeField.textField.placeholder = @"图形验证码";
            [weakSelf.imageCodeField.textField becomeFirstResponder];
        }
        
    } failure:^(NSError *error) {
        [PPTAutoHideMessageView showMessage:@"您的网络不给力" inView:weakSelf.view];
       
        //刷新图形验证码
        [weakSelf getNewImageCode];     //刷新验证码
        
        //光标会到图形验证码输入框
        weakSelf.imageCodeField.textField.text = @"";
        weakSelf.messageCodeField.textField.text = @"";
        weakSelf.imageCodeField.textField.placeholder = @"图形验证码";
        [weakSelf.imageCodeField.textField becomeFirstResponder];
    }];
    
}


- (void)onFinishButtonClick{
    //先释放键盘
    [self resignAllResponder];
    
    NSString *phone = self.phoneTextField.textField.text;
    NSString *imageCode = self.imageCodeField.textField.text;
    NSString *messageCode = self.messageCodeField.textField.text;
    NSString *password = self.passwordField.textField.text;
    
    NSMutableString *message = [[NSMutableString alloc] init];
    if ([PassportUtilTool isEmpty:phone]) {
        [message appendString:@"手机号码不能为空"];
        [self.phoneTextField.textField becomeFirstResponder];
        
        [self.finishStepButton setBackgroundImage:[UIImage imageNamed:@"btn_big_dis"] forState:UIControlStateNormal];
        [self.finishStepButton setBackgroundImage:[UIImage imageNamed:@"btn_big_dis"] forState:UIControlStateHighlighted];
        self.finishStepButton.userInteractionEnabled = NO;
        
        [PPTAutoHideMessageView showMessage:[NSString stringWithString:message] inView:self.view];
        return;
    }else if(![PassportUtilTool isMobileNumber:phone]){
        [message appendString:@"请输入完整手机号码"];
        [self.phoneTextField.textField becomeFirstResponder];
        
        [self.finishStepButton setBackgroundImage:[UIImage imageNamed:@"btn_big_dis"] forState:UIControlStateNormal];
        [self.finishStepButton setBackgroundImage:[UIImage imageNamed:@"btn_big_dis"] forState:UIControlStateHighlighted];
        self.finishStepButton.userInteractionEnabled = NO;
        
        [PPTAutoHideMessageView showMessage:[NSString stringWithString:message] inView:self.view];
        return;
    }else if ([PassportUtilTool isEmpty:imageCode]) {
        [message appendString:@"验证码不能为空"];
        [self.imageCodeField.textField becomeFirstResponder];
        
        [self.finishStepButton setBackgroundImage:[UIImage imageNamed:@"btn_big_dis"] forState:UIControlStateNormal];
        [self.finishStepButton setBackgroundImage:[UIImage imageNamed:@"btn_big_dis"] forState:UIControlStateHighlighted];
        self.finishStepButton.userInteractionEnabled = NO;
        
        [PPTAutoHideMessageView showMessage:[NSString stringWithString:message] inView:self.view];
        return;
    }
    
 
    if ([PassportUtilTool isEmpty:messageCode]) {
        [message appendString:@"验证码不能为空"];
        [self.messageCodeField.textField becomeFirstResponder];
        
        [self.finishStepButton setBackgroundImage:[UIImage imageNamed:@"btn_big_dis"] forState:UIControlStateNormal];
        [self.finishStepButton setBackgroundImage:[UIImage imageNamed:@"btn_big_dis"] forState:UIControlStateHighlighted];
        self.finishStepButton.userInteractionEnabled = NO;
        
        [PPTAutoHideMessageView showMessage:[NSString stringWithString:message] inView:self.view];
        return;
    }
    

    if ([PassportUtilTool isEmpty:password]){
        [message appendString:@"密码不能为空"];
        [self.passwordField.textField becomeFirstResponder];
        
        [self.finishStepButton setBackgroundImage:[UIImage imageNamed:@"btn_big_dis"] forState:UIControlStateNormal];
        [self.finishStepButton setBackgroundImage:[UIImage imageNamed:@"btn_big_dis"] forState:UIControlStateHighlighted];
        self.finishStepButton.userInteractionEnabled = NO;
        
        [PPTAutoHideMessageView showMessage:[NSString stringWithString:message] inView:self.view];
        return;
    }
    
    
    [self startLoadAnimation];
    [self showLoading:YES];
    
    __weak typeof(self) weak_self = self;
    [PTPassport passportForgotPasswordWithPhoneNumber:[phone trim] password:[password trim] code:[messageCode trim] success:^(PTPassportResponseItem *responseItem) {
        if (responseItem.errorCode == 0) {
            [PPTAutoHideMessageView showMessage:@"密码修改成功" inView:weak_self.view];
            
            //重写登录,更新本地保存密码信息、token
            [weak_self useLoginToGetTokenAndUid];
        }else {
            [weak_self showLoading:NO];
            [weak_self stopLoadAnimation];
            
            NSString *errorMessage = [NSString stringWithFormat:@"%@",PTPassportErrorCodeDescription(responseItem.errorCode)];
            [PPTAutoHideMessageView showMessage:[NSString stringWithString:errorMessage] inView:weak_self.view];
            
            [weak_self getNewImageCode];     //刷新验证码
            //清空图形验证码和短信验证码
            weak_self.imageCodeField.textField.text = @"";
            weak_self.messageCodeField.textField.text = @"";
            weak_self.imageCodeField.textField.placeholder = @"图形验证码";
            [weak_self.imageCodeField.textField becomeFirstResponder];
        }
    }failure:^(NSError *error) {
        [weak_self showLoading:NO];
        [weak_self stopLoadAnimation];
        [PPTAutoHideMessageView showMessage:@"您的网络不给力" inView:weak_self.view];
        
        [weak_self getNewImageCode];     //刷新验证码
        //清空图形验证码和短信验证码
        weak_self.imageCodeField.textField.text = @"";
        weak_self.messageCodeField.textField.text = @"";
        weak_self.imageCodeField.textField.placeholder = @"图形验证码";
        [weak_self.imageCodeField.textField becomeFirstResponder];
    }];
    
}


//重新登录
- (void)useLoginToGetTokenAndUid {
    NSString *phone = self.phoneTextField.textField.text;
    NSString *password = self.passwordField.textField.text;
    NSString *verify = self.imageCodeField.textField.text;
    
    __weak typeof(self) weak_self = self;
    [PTPassport passportSafeLoginWithPhoneNumber:[phone trim] password:[password trim] verify:[verify trim] success:^(PTPassportResponseItem *responseItem) {
        [weak_self showLoading:NO];
        [weak_self stopLoadAnimation];
        
        if (responseItem.errorCode == 0) {
            //登录
            [weak_self saveUserInfo:responseItem];
            
            if ([PTSHARE_USER canAutoLogin]) {
#warning 应用内消息通知
                //登录成功,应用内消息通知
//                [PTMTManager setUpManager];
            }
            
            //回到进入的页面
            [weak_self dismissViewControllerAnimated:YES completion:^{
            }];
            
        }else {
            NSString *errorMessage = [NSString stringWithFormat:@"%@",PTPassportErrorCodeDescription(responseItem.errorCode)];
            [PPTAutoHideMessageView showMessage:[NSString stringWithString:errorMessage] inView:weak_self.view];
            
            [weak_self getNewImageCode];     //刷新验证码
            //清空图形验证码和短信验证码
            weak_self.imageCodeField.textField.text = @"";
            weak_self.messageCodeField.textField.text = @"";
            weak_self.imageCodeField.textField.placeholder = @"图形验证码";
            [weak_self.imageCodeField.textField becomeFirstResponder];
        }
        
        
    } failure:^(NSError *error) {
        [weak_self showLoading:NO];
        [weak_self stopLoadAnimation];
        [PPTAutoHideMessageView showMessage:@"您的网络不给力" inView:weak_self.view];
        
        [weak_self getNewImageCode];     //刷新验证码
        //清空图形验证码和短信验证码
        weak_self.imageCodeField.textField.text = @"";
        weak_self.messageCodeField.textField.text = @"";
        weak_self.imageCodeField.textField.placeholder = @"图形验证码";
        [weak_self.imageCodeField.textField becomeFirstResponder];
    }];
    
    
}



- (void)saveUserInfo:(PTPassportResponseItem *)item {
    PTSHARE_USER.user.userID = item.uid;
    PTSHARE_USER.user.userToken = item.token;
    PTSHARE_USER.user.userNick = item.nickName;
    PTSHARE_USER.user.userName = self.phoneTextField.textField.text;
    PTSHARE_USER.user.userPassword = self.passwordField.textField.text;
    PTSHARE_USER.user.userDeviceID = [PassportUtilTool getDeviceID];
    [PTSHARE_USER updateToDisk];
}


//显示倒计时
- (void)showTimeCount
{
    //验证码相应
    [self.messageCodeField.textField becomeFirstResponder];
    
    if (!_showTimer) {
        self.messageCodeField.timeOut = NO;
        _showTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(Timing) userInfo:nil repeats:YES];
        [self Timing];
    }
}

//读秒
- (void)Timing{
    if (self.messageCodeField.isTimeOut) {
        [_showTimer invalidate];
        _showTimer = nil;
        return;
    }
    [self.messageCodeField Timing];
}

//获取图形验证码路径
- (void)getNewImageCode{
    self.imageCodeField.codeImageUrl = [PTPassport passportSendImageVerifyCodeWithAction:@"forget"];
}

- (void)resignAllResponder{
    if ([self.phoneTextField.textField isFirstResponder]) {
        [self.phoneTextField.textField resignFirstResponder];
    }
    if ([self.imageCodeField.textField isFirstResponder]) {
        [self.imageCodeField.textField resignFirstResponder];
    }
    if ([self.messageCodeField.textField isFirstResponder]) {
        [self.messageCodeField.textField resignFirstResponder];
    }
    if ([self.passwordField.textField isFirstResponder]) {
        [self.passwordField.textField resignFirstResponder];
    }
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    [self resignAllResponder];
}
#pragma mark -




#pragma mark - <SOViewControllerProtocol>
- (void)setParameters:(id)parameters {
    [super setParameters:parameters];
    
}
#pragma mark -

@end
