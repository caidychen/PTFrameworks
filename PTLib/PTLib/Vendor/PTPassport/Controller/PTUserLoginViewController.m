//
//  PTUserLoginViewController.m
//  PTLatitude
//
//  Created by LiLiLiu on 15/11/30.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTUserLoginViewController.h"

//Model
#import "PTPassport.h"
#import "PassportUtilTool.h"
#import "PTUserManager.h"
#import "PTUserEditInfoItem.h"  //用户头像、昵称、简介信息

//View
#import "UIColor+Help.h"
#import "SOAutoHideMessageView.h"
#import "PTLoginNavView.h"
#import "PTLoginNormalTextField.h"
#import "PTLoginImageTextField.h"
#import "PassportMacro.h"

//Controller
#import "PTUserRegisterViewController.h"
#import "PTUserForgetPasswordViewController.h"
#import "PTUserAddInfoViewController.h"
#import "PTNavigationController.h"

#import "JPUSHService.h"        // JPush


PTUserLoginViewController * PTPresentLoginViewControllerAnimated(UIViewController *baseViewController, BOOL animated, void(^resultBlock)(BOOL success, PTPassportResponseItem *responseItem)) {
    PTUserLoginViewController *loginVC = [[PTUserLoginViewController alloc] init];
    loginVC.actionBlock = ^(BOOL isLoginSuccess, PTPassportResponseItem *responseItem){
        if(resultBlock) {
            resultBlock(isLoginSuccess, responseItem);
        }
    };
    PTNavigationController *nav = [[PTNavigationController alloc] initWithRootViewController:loginVC];
    if(!baseViewController || ![baseViewController isKindOfClass:[UIViewController class]]) {
        baseViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    }
    [baseViewController presentViewController:nav animated:animated completion:^{
        
    }];
    return (loginVC);
}



static CGFloat const LoginVCInsets = 20.0f;

@interface PTUserLoginViewController ()<UITextFieldDelegate>

@property (nonatomic , strong) UIImageView *backgroundImage;
@property (nonatomic , strong) PTLoginNavView *navView;

@property (nonatomic,strong)PTLoginNormalTextField *phoneField;
@property (nonatomic,strong)PTLoginNormalTextField *passwordField;
@property (nonatomic,strong)PTLoginImageTextField *imageCodeField;
@property (nonatomic,strong)UIButton *btnLogin;
@property (nonatomic,strong)UIButton *btnRegister;
@property (nonatomic,strong)UIButton *btnForgetPassword;

@property (nonatomic, assign) BOOL isShowImageCode;     //密码输错 3 次 要求输入图形验证码

@property (nonatomic, strong) PTPassportResponseItem *loginResponseItem;  //纪录登录返回的信息
@property (strong, nonatomic, readonly) UIActivityIndicatorView *activityView;
@end

@implementation PTUserLoginViewController{
    CGFloat passortStartTime;
    CGFloat passortEndTime;
    
    CGFloat infoStartTime;
    CGFloat infoEndTime;
}

@synthesize backgroundImage = _backgroundImage;
@synthesize navView = _navView;
@synthesize phoneField = _phoneField;
@synthesize passwordField = _passwordField;
@synthesize imageCodeField = _imageCodeField;
@synthesize btnLogin = _btnLogin;
@synthesize activityView = _activityView;
@synthesize btnRegister = _btnRegister;
@synthesize btnForgetPassword = _btnForgetPassword;

- (void)dealloc {
    SORELEASE(_backgroundImage);
    SORELEASE(_navView);
    SORELEASE(_phoneField);
    SORELEASE(_passwordField);
    SORELEASE(_imageCodeField);
    SORELEASE(_btnLogin);
    SORELEASE(_activityView);
    SORELEASE(_btnRegister);
    SORELEASE(_btnForgetPassword);
    SOSUPERDEALLOC();
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        self.hidesBottomBarWhenPushed = YES;
        _isShowImageCode = NO;
        _loginResponseItem = nil;
        
    }
    return (self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ptLoadingView.alpha = 0.4f;
    
    [self.view addSubview:self.backgroundImage];
    [self.view addSubview:self.navView];
    
    [self.view addSubview:self.phoneField];
    [self.view addSubview:self.passwordField];
    [self.view addSubview:self.imageCodeField];
    [self.view addSubview:self.btnLogin];
    [self.view addSubview:self.btnRegister];
    [self.view addSubview:self.btnForgetPassword];
    [self.view addSubview:self.activityView];
    
    
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.backgroundImage.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    //这里是自定义导航栏宽高设置
    self.navView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), Passport_HEIGHT_NAV+Passport_HEIGHT_STATUS);
    
    CGFloat textFieldWidth = Passport_Screenwidth-10*2;
    CGFloat textFieldHeight = 44.0f;
    self.phoneField.frame = CGRectMake(10, CGRectGetMaxY(self.navView.frame)+LoginVCInsets, textFieldWidth , textFieldHeight);
    self.passwordField.frame = CGRectMake(10, CGRectGetMaxY(self.phoneField.frame), textFieldWidth, textFieldHeight);
    
    
    if (self.isShowImageCode) {
        self.imageCodeField.hidden = NO;
        self.imageCodeField.frame = CGRectMake(10, CGRectGetMaxY(self.passwordField.frame), textFieldWidth, textFieldHeight);
        
        self.btnLogin.frame = CGRectMake(0, 0, Passport_Screenwidth-32, 44);
        self.btnLogin.center = CGPointMake(Passport_Screenwidth/2, CGRectGetMaxY(self.imageCodeField.frame)+LoginVCInsets*2);
    }else{
        self.imageCodeField.hidden = YES;
        
        self.btnLogin.frame = CGRectMake(0, 0, Passport_Screenwidth-32, 44);
        self.btnLogin.center = CGPointMake(Passport_Screenwidth/2, CGRectGetMaxY(self.passwordField.frame)+LoginVCInsets*2);
    }
    
    self.activityView.center = self.btnLogin.center;
    
    self.btnRegister.frame = CGRectMake(0, 0, 100, 44);
    self.btnRegister.center = CGPointMake(58, CGRectGetMaxY(self.btnLogin.frame)+LoginVCInsets+6); //+8
    
    self.btnForgetPassword.frame = CGRectMake(0, 0, 100, 44);
    self.btnForgetPassword.center = CGPointMake(Passport_Screenwidth-50, CGRectGetMaxY(self.btnLogin.frame)+LoginVCInsets+6); //+8
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self.phoneField.textField becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


#pragma mark - getter
- (UIImageView *)backgroundImage{
    if (!_backgroundImage) {
        _backgroundImage = [[UIImageView alloc] initWithFrame:CGRectZero ];
        if ([@"4" isEqualToString:[PassportUtilTool getCurrentDrive]]) {
            _backgroundImage.image = [UIImage imageNamed:@"img_bg_signup@2x.png"];
        }else{
            _backgroundImage.image = [UIImage imageNamed:@"img_bg_signup@3x.png"];
        }
    }
    return _backgroundImage;
}


- (PTLoginNavView *)navView{
    if (!_navView) {
        _navView = [[PTLoginNavView alloc] initWithFrame:CGRectZero];
        _navView.backType = PTLoginNavBackTextType;
        _navView.title = @"登录葡萄账户";
        
        __weak typeof(self) weakSelf = self;
        _navView.leftActionBlock = ^(){
            //点击取消按钮
            [weakSelf leftItemTouched];
        };
    }
    return _navView;
}


- (PTLoginNormalTextField *)phoneField{
    if (!_phoneField) {
        _phoneField = [[PTLoginNormalTextField alloc] initWithFrame:CGRectZero];
        _phoneField.type = PhoneTextFieldType;
        _phoneField.placeholder = @"手机号码";
        _phoneField.actionBlock = ^(NSString *text,BOOL isSuccess){
            //回调
        };
    }
    return _phoneField;
}

- (PTLoginNormalTextField *)passwordField{
    if (!_passwordField) {
        _passwordField = [[PTLoginNormalTextField alloc] initWithFrame:CGRectZero];
        _passwordField.type = PasswordTextFieldType;
        _passwordField.placeholder = @"登录密码(6-18位)";
        
        __weak typeof(self) weakSelf = self;
        _passwordField.actionBlock = ^(NSString *text ,BOOL isSuccess){
            if ([@"password" isEqualToString:text]) {
                if (isSuccess) {
                    [weakSelf.btnLogin setBackgroundImage:[UIImage imageNamed:@"btn_big_nor"] forState:UIControlStateNormal];
                    [weakSelf.btnLogin setBackgroundImage:[UIImage imageNamed:@"btn_big_nor"] forState:UIControlStateHighlighted];
                    weakSelf.btnLogin.userInteractionEnabled = YES;
                }else{
                    [weakSelf.btnLogin setBackgroundImage:[UIImage imageNamed:@"btn_big_dis"] forState:UIControlStateNormal];
                    [weakSelf.btnLogin setBackgroundImage:[UIImage imageNamed:@"btn_big_dis"] forState:UIControlStateHighlighted];
                    weakSelf.btnLogin.userInteractionEnabled = NO;
                }
                
            }else if([@"responder" isEqualToString:text]){
                //获取到焦点,开始验证手机号码
                [weakSelf checkPhoneNumber];
            }else if([@"login" isEqualToString:text]){
                //输入完毕,可以直接登录了
                [weakSelf onLoginBtnClick];
            }
        };
        
    }
    return _passwordField;
}


- (PTLoginImageTextField *)imageCodeField{
    if (!_imageCodeField) {
        _imageCodeField = [[PTLoginImageTextField alloc] initWithFrame:CGRectZero];
        _imageCodeField.placeholder = @"图形验证码";
        _imageCodeField.delegate = self;
//        _imageCodeField.codeImageUrl = @"http://fmn.rrfmn.com/fmn047/20110217/1605/b_large_KPPN_5c09000116fc5c44.jpg";
        
        __weak typeof(self) weak_self = self;
        _imageCodeField.imageTapActionBlock = ^(){
            [weak_self getNewImageCode];
        };
        
        _imageCodeField.hidden = YES;
    }
    return _imageCodeField;
}


- (UIButton *)btnLogin{
    if (!_btnLogin) {
        _btnLogin = [[UIButton alloc] initWithFrame:CGRectZero];
        _btnLogin.clipsToBounds = YES;
        _btnLogin.layer.cornerRadius = 4;
        [_btnLogin setTitleColor:[UIColor colorWithHexString:@"FFFFFF"] forState:UIControlStateNormal];
        [_btnLogin setTitleColor:[UIColor colorWithHexString:@"FFFFFF"] forState:UIControlStateHighlighted];
        [_btnLogin setBackgroundImage:[UIImage imageNamed:@"btn_big_dis"] forState:UIControlStateNormal];
        [_btnLogin setBackgroundImage:[UIImage imageNamed:@"btn_big_dis"] forState:UIControlStateHighlighted];
        [_btnLogin setTitle:@"登录" forState:UIControlStateNormal];
        _btnLogin.titleLabel.font = [UIFont systemFontOfSize:18];
        [_btnLogin addTarget:self action:@selector(onLoginBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        _btnLogin.userInteractionEnabled = NO;
    }
    
    return _btnLogin;
}

/**
 * @brief 点击登录按钮时，启动加载
 */
- (UIActivityIndicatorView *)activityView {
    if(!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityView.color = UIColorFromRGB(0x985ec9);
        _activityView.hidesWhenStopped = YES;
    }
    return (_activityView);
}

- (UIButton *)btnRegister{
    if (!_btnRegister) {
        _btnRegister = [[UIButton alloc] initWithFrame:CGRectZero];
        [_btnRegister setTitleColor:Passport_THEME_COLOR forState:UIControlStateNormal];
        [_btnRegister setTitleColor:[UIColor colorWithHexString:@"b57de4"] forState:UIControlStateHighlighted];
        [_btnRegister setTitle:@"注册新账户" forState:UIControlStateNormal];
        _btnRegister.titleLabel.font = [UIFont systemFontOfSize:16];
        [_btnRegister addTarget:self action:@selector(onRegisterBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnRegister;
}

- (UIButton *)btnForgetPassword{
    if (!_btnForgetPassword) {
        _btnForgetPassword = [[UIButton alloc] initWithFrame:CGRectZero];
        [_btnForgetPassword setTitleColor:Passport_THEME_COLOR forState:UIControlStateNormal];
        [_btnForgetPassword setTitleColor:[UIColor colorWithHexString:@"b57de4"] forState:UIControlStateHighlighted];
        [_btnForgetPassword setTitle:@"忘记密码" forState:UIControlStateNormal];
        _btnForgetPassword.titleLabel.font = [UIFont systemFontOfSize:16];
        [_btnForgetPassword addTarget:self action:@selector(onForgetpasswordBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnForgetPassword;
}
#pragma mark -

#pragma mark - setter
- (void)showLoading:(BOOL)loading {
    if(loading) {
        [self.activityView startAnimating];
    } else {
        [self.activityView stopAnimating];
    }
    self.btnLogin.enabled = !loading;
    [self.view setNeedsLayout];
}
#pragma mark -



#pragma mark - action
- (void)leftItemTouched{
    [self resignAllResponder];

    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


//验证手机号码
- (void)checkPhoneNumber{
    NSString *phone = self.phoneField.textField.text;
    NSMutableString *message = [[NSMutableString alloc] init];
    if ([PassportUtilTool isEmpty:phone]) {
        [message appendString:@"手机号码不能为空"];
        [SOAutoHideMessageView showMessage:[NSString stringWithString:message] inView:self.view];
        return;
    }else if(![PassportUtilTool isMobileNumber:phone]){
        [message appendString:@"请输入完整手机号码"];
        [SOAutoHideMessageView showMessage:[NSString stringWithString:message] inView:self.view];
        return;
    }
    
    
}


//登录
- (void)onLoginBtnClick{
    //先释放键盘,可用确保得到输入的准确内容
    [self resignAllResponder];

    NSString *phoneNumber = self.phoneField.textField.text;
    NSString *password = self.passwordField.textField.text;
    NSString *verify = self.imageCodeField.textField.text;
    
    //再次确认长度
    if (!(phoneNumber.length == 11)) {
        [SOAutoHideMessageView showMessage:@"请输入正确的手机号码" inView:self.view];
        return;
    }
    if (!(password.length >= Passport_passwordMinLength && password.length <= Passport_passwordMaxLength)) {
        [SOAutoHideMessageView showMessage:@"请输入6-18位密码" inView:self.view];
        return;
    }
    if (_isShowImageCode && ([verify trim].length != Passport_verifyLength) ) {
        [SOAutoHideMessageView showMessage:@"请输入4位图形验证码" inView:self.view];
        return;
    }
    
    
    [self showLoading:YES];
    
    
    //这里密码传原来的值,计算 sign 的时候需要转码
    __weak typeof(self) weak_self = self;
    [PTPassport passportSafeLoginWithPhoneNumber:[phoneNumber trim] password:[password trim] verify:[verify trim] success:^(PTPassportResponseItem *responseItem) {
        weak_self.loginResponseItem = responseItem;
        [weak_self showLoading:NO];
        
        if (responseItem.errorCode == 0) {
            //取出用户个人信息 头像、昵称、简介
            [weak_self startLoadAnimation];
            
            __strong typeof(weak_self) strong_weak_self = weak_self;
            [PTPassport passportGetNickNameWithUid:responseItem.uid token:responseItem.token success:^(PTPassportResponseItem *responseItem) {
                [strong_weak_self stopLoadAnimation];
                if (responseItem.errorCode == 0) {
                    strong_weak_self.loginResponseItem.nickName = responseItem.msg;
                    
                    __strong typeof(strong_weak_self) strong_strong_weak_self = strong_weak_self;
                    [PTPassport passportGetUserAvatarWithUid:strong_weak_self.loginResponseItem.uid token:strong_weak_self.loginResponseItem.token success:^(PTPassportResponseItem *responseItem) {
                        
                        if (responseItem.errorCode == 0) {
                            strong_strong_weak_self.loginResponseItem.avatar = responseItem.avatar;
                            
                            [strong_strong_weak_self saveUserInfo:strong_strong_weak_self.loginResponseItem];
                            
                            [strong_strong_weak_self updateUserInfo];
                        }else{
                            NSString *message = responseItem.msg;
                            [SOAutoHideMessageView showMessage:message inView:self.view];
                        }
                        
                    } failure:^(NSError *error) {
                        
                    }];
                }else{
                    NSString *message = responseItem.msg;
                    [SOAutoHideMessageView showMessage:message inView:self.view];
                }
                
                
                
            } failure:^(NSError *error) {
                
            }];
            
        }else {
            
            //登录失败，只提示，还是保持在登录页面
            NSString *errorMessage = [NSString stringWithFormat:@"%@",PTPassportErrorCodeDescription(responseItem.errorCode)];
            
            if (responseItem.errorCode == PTPassportErrorCodeAppidError || responseItem.errorCode == PTPassportErrorCodeWrongNumber || responseItem.errorCode == PTPassportErrorCodeHandleFailed || responseItem.errorCode == PTPassportErrorCodeUnknow || responseItem.errorCode == PTPassportErrorCodeTooManyTimes || responseItem.errorCode == PTPassportErrorCodeIdError) {
                [SOAutoHideMessageView showMessage:@"登录失败,请再次登录!" inView:weak_self.view];
            }else{
                [SOAutoHideMessageView showMessage:[NSString stringWithString:errorMessage] inView:weak_self.view];
            }
            
            //输入密码错误超过 3 次,显示图形验证码
            if (responseItem.errorCode == PTPassportErrorCodeLoginErrorThreeTimes) {
                _isShowImageCode = YES;
                _imageCodeField.codeImageUrl = [PTPassport passportSendImageVerifyCodeWithAction:@"login"];
                
                //提示用户重新输入密码
                weak_self.passwordField.textField.text = @"";
                [weak_self.passwordField.textField becomeFirstResponder];
                [SOAutoHideMessageView showMessage:@"请输入6-18位密码" inView:weak_self.view];
            }
            
            //如果显示图形验证码后，还是登录失败，刷新 图形验证码
            if (_isShowImageCode) {
                _imageCodeField.textField.text = @"";
                _imageCodeField.codeImageUrl = [PTPassport passportSendImageVerifyCodeWithAction:@"login"];
            }
        }
        
        
    } failure:^(NSError *error) {
        [weak_self showLoading:NO];
        [SOAutoHideMessageView showMessage:@"您的网络不给力" inView:weak_self.view];
    }];
    
    
}


- (void)saveUserInfo:(PTPassportResponseItem *)item {
    User *user = PTSHARE_USER.user;
    user.userID = item.uid;
    user.userToken = item.token;
    user.userNick = item.nickName;
    user.userName = self.phoneField.textField.text;
    user.userPassword = self.passwordField.textField.text;
    user.userDeviceID = [PassportUtilTool getDeviceID];
    user.userAvatar = item.avatar;
    [PTSHARE_USER updateToDisk];
}


- (void)onRegisterBtnClick{
    //点击注册按钮
    PTUserRegisterViewController *registerVC = [[PTUserRegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)onForgetpasswordBtnClick{
    //忘记密码
    PTUserForgetPasswordViewController *forgetVC = [[PTUserForgetPasswordViewController alloc] init];
    [self.navigationController pushViewController:forgetVC animated:YES];
}


- (void)getNewImageCode{
    self.imageCodeField.codeImageUrl = [PTPassport passportSendImageVerifyCodeWithAction:@"login"];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    [self resignAllResponder];
}


- (void)resignAllResponder{
    if ([self.phoneField.textField isFirstResponder]) {
        [self.phoneField.textField resignFirstResponder];
    }
    if ([self.passwordField.textField isFirstResponder]) {
        [self.passwordField.textField resignFirstResponder];
    }
    if ([self.imageCodeField.textField isFirstResponder]) {
        [self.imageCodeField.textField resignFirstResponder];
    }
}
#pragma mark -



#pragma mark - <SOViewControllerProtocol>
- (void)setParameters:(id)parameters {
    [super setParameters:parameters];
    
}
#pragma mark -



#pragma mark - private Method
- (void)updateUserInfo{
    if ([PTSHARE_USER canAutoLogin]) {
        //发送广播给所有
        [[NSNotificationCenter defaultCenter] postNotificationName:PassportLoginNotification object:nil userInfo:nil];
        
        //回到进入的页面
        __weak typeof(self) weakSelf = self;
        [self dismissViewControllerAnimated:YES completion:^{
            if (weakSelf.actionBlock) {
                weakSelf.actionBlock(YES,weakSelf.loginResponseItem);
            }
        }];
    }
    
   
    return;
}

@end
