//
//  PTUserRegisterViewController.m
//  PTLatitude
//
//  Created by LiLiLiu on 15/11/30.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTUserRegisterViewController.h"

//Model
#import "PTPassport.h"
#import "PassportUtilTool.h"
#import "PTUserManager.h"

//View
#import "PPTAutoHideMessageView.h"
#import "PTLoginNavView.h"
#import "PTLoginNormalTextField.h"
#import "PTLoginImageTextField.h"
#import "PTLoginCodeTextField.h"
#import "PTLoginPasswordTextField.h"
#import "PassportMacro.h"

//Controller
#import "PTUserProtocolViewController.h"
#import "PTUserAddInfoViewController.h"

static CGFloat const RegisterVCInsets = 20.0f;
static CGFloat const RegisterNextBtnInsets = 2.0f;

@interface PTUserRegisterViewController (){
    NSTimer         *_showTimer;            //动画展示
}

@property (nonatomic , strong) UIImageView *backgroundImage;
@property (nonatomic , strong) PTLoginNavView *navView;

@property (nonatomic,strong)PTLoginNormalTextField *phoneField;
@property (nonatomic,strong)PTLoginImageTextField *imageCodeField;   //图形验证码
@property (nonatomic,strong)PTLoginCodeTextField *messageCodeField;  //短信验证码
@property (nonatomic,strong)PTLoginPasswordTextField *passwordField; //可见登录密码
@property (nonatomic,strong)UIButton *btnNext;

@property (nonatomic,strong)UILabel *lblServiceProtocol;    //协议显示文字
@property (nonatomic,strong)UIButton *btnServiceProtocol;   //协议点击按钮

@property (nonatomic, assign) BOOL isShowImageCode;     //是否显示图形验证码
@property (strong, nonatomic, readonly) UIActivityIndicatorView *activityView;
@end



@implementation PTUserRegisterViewController

@synthesize backgroundImage = _backgroundImage;
@synthesize navView = _navView;
@synthesize phoneField = _phoneField;
@synthesize imageCodeField = _imageCodeField;
@synthesize messageCodeField = _messageCodeField;
@synthesize passwordField = _passwordField;
@synthesize activityView = _activityView;
@synthesize btnNext = _btnNext;
@synthesize lblServiceProtocol = _lblServiceProtocol;
@synthesize btnServiceProtocol = _btnServiceProtocol;

- (void)dealloc {
    PPTRELEASE(_backgroundImage);
    PPTRELEASE(_navView);
    PPTRELEASE(_phoneField);
    PPTRELEASE(_passwordField);
    PPTRELEASE(_imageCodeField);
    PPTRELEASE(_messageCodeField);
    PPTRELEASE(_btnNext);
    PPTRELEASE(_activityView);
    PPTRELEASE(_lblServiceProtocol);
    PPTRELEASE(_btnServiceProtocol);
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
    
    [self.view addSubview:self.backgroundImage];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.phoneField];
    
    [self.view addSubview:self.messageCodeField];
    [self.view addSubview:self.passwordField];
    [self.view addSubview:self.btnNext];
    [self.view addSubview:self.btnServiceProtocol];
    [self.view addSubview:self.activityView];
    
    [self.view addSubview:self.imageCodeField];
 
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
    self.phoneField.frame = CGRectMake(10, CGRectGetMaxY(self.navView.frame)+RegisterVCInsets, textFieldWidth , textFieldHeight);
    
    self.imageCodeField.frame = CGRectMake(10, CGRectGetMaxY(self.phoneField.frame), textFieldWidth, textFieldHeight);
    self.messageCodeField.frame = CGRectMake(10, CGRectGetMaxY(self.imageCodeField.frame), textFieldWidth, textFieldHeight);
    self.passwordField.frame = CGRectMake(10, CGRectGetMaxY(self.messageCodeField.frame), textFieldWidth, textFieldHeight);
    
    self.btnNext.frame = CGRectMake(0, 0, Passport_Screenwidth-32, textFieldHeight);
    self.btnNext.center = CGPointMake(Passport_Screenwidth/2, CGRectGetMaxY(self.passwordField.frame)+RegisterVCInsets*2);
    
    self.activityView.center = self.btnNext.center;
    
    CGFloat serviceBtnY = CGRectGetMaxY(self.btnNext.frame)+RegisterNextBtnInsets;
    NSString *currentDrive = [self getCurrentDrive];
    if ([currentDrive isEqualToString:@"4"] || [currentDrive isEqualToString:@"5"]) {
        CGFloat serviceBtnWidth = CGRectGetWidth(self.view.bounds)-RegisterVCInsets*4;
        self.btnServiceProtocol.frame = CGRectMake(RegisterVCInsets-5, serviceBtnY, serviceBtnWidth, textFieldHeight);
    }
    if ([currentDrive isEqualToString:@"6"]) {
        CGFloat serviceBtnWidth = CGRectGetWidth(self.view.bounds)-RegisterVCInsets*7;
        self.btnServiceProtocol.frame = CGRectMake(RegisterVCInsets-5, serviceBtnY, serviceBtnWidth, textFieldHeight);
    }
    if ([currentDrive isEqualToString:@"6p"]) {
        CGFloat serviceBtnWidth = CGRectGetWidth(self.view.bounds)-RegisterVCInsets*9;
        self.btnServiceProtocol.frame = CGRectMake(RegisterVCInsets-5, serviceBtnY, serviceBtnWidth, textFieldHeight);
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self.phoneField.textField becomeFirstResponder];
    
    //将倒计时清空,恢复按钮状态
    if (_showTimer && [_showTimer isValid]) {
        [_showTimer invalidate];
    }
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
        _navView.backType = PTLoginNavBackImageType;
        _navView.title = @"注册葡萄账户";
        
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
        _phoneField.actionBlock = ^(NSString *text ,BOOL isSuccess){
        };
    }
    return _phoneField;
}

- (PTLoginImageTextField *)imageCodeField{
    if (!_imageCodeField) {
        _imageCodeField = [[PTLoginImageTextField alloc] initWithFrame:CGRectZero];
        _imageCodeField.placeholder = @"图形验证码";
        _imageCodeField.codeImageUrl = [PTPassport passportSendImageVerifyCodeWithAction:@"register"];
    
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
        
        __weak typeof(self) weak_self = self;
        //成为第一响应者后回调
        _messageCodeField.firstResponderActionBlock = ^(){
            weak_self.messageCodeField.buttonUseable = YES;
        };
        
        //点击 获取验证码 后回调
        _messageCodeField.actionBlock = ^(BOOL isSuccess){
            [weak_self checkPhoneNumber];
        };
    }
    return _messageCodeField;
}

- (PTLoginPasswordTextField *)passwordField{
    if (!_passwordField) {
        _passwordField = [[PTLoginPasswordTextField alloc] initWithFrame:CGRectZero];
        _passwordField.placeholder = @"密码(6-18位)";
        
        __weak typeof(self) weak_self = self;
        _passwordField.actionBlock = ^(BOOL flag){
            if (flag) {
                [weak_self.btnNext setBackgroundImage:[UIImage imageNamed:@"btn_big_nor"] forState:UIControlStateNormal];
                [weak_self.btnNext setBackgroundImage:[UIImage imageNamed:@"btn_big_nor"] forState:UIControlStateHighlighted];
                weak_self.btnNext.userInteractionEnabled = YES;
            }else{
                [weak_self.btnNext setBackgroundImage:[UIImage imageNamed:@"btn_big_dis"] forState:UIControlStateNormal];
                [weak_self.btnNext setBackgroundImage:[UIImage imageNamed:@"btn_big_dis"] forState:UIControlStateHighlighted];
                weak_self.btnNext.userInteractionEnabled = NO;
                
                //这里验证验证码是否输入正确
                [weak_self checkCodeNumber];
            }
            
        };
    }
    return _passwordField;
}

- (UIButton *)btnNext{
    if (!_btnNext) {
        _btnNext = [[UIButton alloc] initWithFrame:CGRectZero];
        _btnNext.clipsToBounds = YES;
        _btnNext.layer.cornerRadius = 4;
        [_btnNext setTitleColor:[UIColor colorWithHexString:@"FFFFFF"] forState:UIControlStateNormal];
        [_btnNext setTitleColor:[UIColor colorWithHexString:@"FFFFFF"] forState:UIControlStateHighlighted];
        [_btnNext setBackgroundImage:[UIImage imageNamed:@"btn_big_dis"] forState:UIControlStateNormal];
        [_btnNext setBackgroundImage:[UIImage imageNamed:@"btn_big_dis"] forState:UIControlStateHighlighted];
        if ([PTPassport getIsUploadAvatar]){
            [_btnNext setTitle:@"下一步" forState:UIControlStateNormal];
        }else{
            [_btnNext setTitle:@"完成注册" forState:UIControlStateNormal];
        }
        
        _btnNext.titleLabel.font = [UIFont systemFontOfSize:18];
        [_btnNext addTarget:self action:@selector(onNextBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        _btnNext.userInteractionEnabled = NO;
    }
    
    return _btnNext;
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

- (UILabel *)lblServiceProtocol{
    if (!_lblServiceProtocol) {
        _lblServiceProtocol = [[UILabel alloc] initWithFrame:CGRectZero];
        _lblServiceProtocol.text = @"点击下一步表示您已同意《用户服务协议》";
        _lblServiceProtocol.font = [UIFont systemFontOfSize:12];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"点击下一步表示您已同意《用户服务协议》"];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"985ec9"] range:NSMakeRange(0,12)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"b57de4"] range:NSMakeRange(12,6)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"646464"] range:NSMakeRange(18,1)];
        _lblServiceProtocol.attributedText = str;
    }
    return _lblServiceProtocol;
}

- (UIButton *)btnServiceProtocol{
    if (!_btnServiceProtocol) {
        _btnServiceProtocol = [[UIButton alloc] initWithFrame:CGRectZero];
        [_btnServiceProtocol setTitleColor:Passport_THEME_COLOR forState:UIControlStateNormal];
        [_btnServiceProtocol setTitleColor:[UIColor colorWithHexString:@"b57de4"] forState:UIControlStateHighlighted];
        [_btnServiceProtocol setTitle:@"点击下一步表示您已同意《用户服务协议》" forState:UIControlStateNormal];
        _btnServiceProtocol.titleLabel.font = [UIFont systemFontOfSize:12];
        [_btnServiceProtocol addTarget:self action:@selector(onServiceProtocalBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnServiceProtocol;
}
#pragma mark -


#pragma mark - setter
- (void)showLoading:(BOOL)loading {
    if(loading) {
        [self.activityView startAnimating];
    } else {
        [self.activityView stopAnimating];
    }
    self.btnNext.enabled = !loading;
    [self.view setNeedsLayout];
}
#pragma mark -



#pragma mark - action
- (void)resignAllResponder{
    if ([self.phoneField.textField isFirstResponder]) {
        [self.phoneField.textField resignFirstResponder];
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

- (void)leftItemTouched{
    [self resignAllResponder];
    
    [self.navigationController popViewControllerAnimated:YES];
}

//验证手机号码
- (void)checkPhoneNumber{
    [self resignAllResponder];
    
    NSString *phone = self.phoneField.textField.text;
    NSString *imageCode = self.imageCodeField.textField.text;
    
    NSMutableString *message = [[NSMutableString alloc] init];
    if ([PassportUtilTool isEmpty:phone]) {
        [message appendString:@"手机号码不能为空"];
        [self.phoneField.textField becomeFirstResponder];
        [PPTAutoHideMessageView showMessage:[NSString stringWithString:message] inView:self.view];
        return;
    }
    
    if(![PassportUtilTool isMobileNumber:phone]){
        [message appendString:@"请输入完整手机号码"];
        [self.phoneField.textField becomeFirstResponder];
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
    __weak typeof(self)weak_self = self;
    [PTPassport passportVerifyPhoneNumberExistWithPhoneNumber:[phone trim] success:^(PTPassportResponseItem *responseItem) {
        if (responseItem.errorCode == 0) {
            //OK,无任何返回描述，未定义，不提示
            [weak_self sendCodeNumber];
        }else if (responseItem.errorCode == 61005 || responseItem.errorCode == 61001 || responseItem.errorCode == 61009 || responseItem.errorCode == 61010) {
            //手机号码已存在,手机号为空,手机号错误
            NSString *errorMessage = [NSString stringWithFormat:@"%@",PTPassportErrorCodeDescription(responseItem.errorCode)];
            [PPTAutoHideMessageView showMessage:[NSString stringWithString:errorMessage] inView:weak_self.view];
            
            weak_self.phoneField.textField.text = @"";
            weak_self.phoneField.textField.placeholder = @"手机号码";
            weak_self.imageCodeField.textField.text = @"";
            [weak_self getNewImageCode];     //刷新验证码
            [weak_self.phoneField.textField becomeFirstResponder];
        }else {
            //这里是未针对手机号码定义的状态码
            NSString *errorMessage = @"请输入正确的手机号码";
            [PPTAutoHideMessageView showMessage:[NSString stringWithString:errorMessage] inView:weak_self.view];
            
            weak_self.phoneField.textField.text = @"";
            weak_self.phoneField.textField.placeholder = @"手机号码";
            weak_self.imageCodeField.textField.text = @"";
            [weak_self getNewImageCode];     //刷新验证码
            [weak_self.phoneField.textField becomeFirstResponder];
        }
        
    } failure:^(NSError *error) {
        [PPTAutoHideMessageView showMessage:@"您的网络不给力" inView:weak_self.view];
        
        weak_self.phoneField.textField.text = @"";
        weak_self.imageCodeField.textField.text = @"";
        weak_self.phoneField.textField.placeholder = @"手机号码";
        [weak_self getNewImageCode];     //刷新验证码
        [weak_self.phoneField.textField becomeFirstResponder];
    }];
    

    return;
}

//发送验证码
- (void)sendCodeNumber{
    [self resignAllResponder];
    
    NSString *phone = self.phoneField.textField.text;
    NSString *imageCode = self.imageCodeField.textField.text;
 
    __weak typeof(self)weak_self = self;
    [PTPassport passportSafeSendVerifyCodeWithPhoneNumber:[phone trim] verify:[imageCode trim] action:@"register" success:^(PTPassportResponseItem *responseItem) {
        if (responseItem.errorCode == 0) {
            [weak_self showTimeCount];
            [PPTAutoHideMessageView showMessage:@"短信已发送，请查收!" inView:weak_self.view];
        }else {
            NSString *errorMessage = [NSString stringWithFormat:@"%@",PTPassportErrorCodeDescription(responseItem.errorCode)];
            [PPTAutoHideMessageView showMessage:[NSString stringWithString:errorMessage] inView:weak_self.view];
            
            //刷新图形验证码
            [weak_self getNewImageCode];     //刷新验证码
            
            //光标会到图形验证码输入框
            weak_self.imageCodeField.textField.text = @"";
            weak_self.messageCodeField.textField.text = @"";
            weak_self.imageCodeField.textField.placeholder = @"图形验证码";
            [weak_self.imageCodeField.textField becomeFirstResponder];
        }
        
    } failure:^(NSError *error) {
        [PPTAutoHideMessageView showMessage:@"您的网络不给力" inView:weak_self.view];
        //刷新图形验证码
        [weak_self getNewImageCode];     //刷新验证码
        
        //光标会到图形验证码输入框
        weak_self.imageCodeField.textField.text = @"";
        weak_self.messageCodeField.textField.text = @"";
        weak_self.imageCodeField.textField.placeholder = @"图形验证码";
        [weak_self.imageCodeField.textField becomeFirstResponder];
    }];

}


//验证验证码
- (void)checkCodeNumber{
    NSString *codeNumber = self.messageCodeField.textField.text;
    NSMutableString *message = [[NSMutableString alloc] init];
    if ([PassportUtilTool isEmpty:codeNumber]) {
        [message appendString:@"验证码不能为空"];
        self.messageCodeField.textField.placeholder = @"短信验证码";
        [self.messageCodeField.textField becomeFirstResponder];
        [PPTAutoHideMessageView showMessage:[NSString stringWithString:message] inView:self.view];
    }
}


//完成注册
- (void)onNextBtnClick{
    [self resignAllResponder];
    
    NSString *phoneNumber = self.phoneField.textField.text;
    NSString *password    = self.passwordField.textField.text;
    NSString *codeNumber = self.messageCodeField.textField.text;
    
    [self showLoading:YES];
    
    __weak typeof(self)weak_self = self;
    [PTPassport passportRegisterWithPhoneNumber:[phoneNumber trim] password:[password trim] code:[codeNumber trim] success:^(PTPassportResponseItem *responseItem) {
        [weak_self showLoading:NO];
        
        if (responseItem.errorCode == 0) {
            //注册成功,保存用户信息
            [weak_self saveUserInfo:responseItem];
            
            if ([PTPassport getIsUploadAvatar]) {
                //跳转到上传头像页面完善头像、昵称
                [weak_self userRegisterWithItem:responseItem];
            }else{
                //完成注册取消当前页面
                [weak_self finishRegister:responseItem];
            }
            
            
        }else {
            [weak_self showLoading:NO];
            
            NSString *errorMessage = [NSString stringWithFormat:@"%@",PTPassportErrorCodeDescription(responseItem.errorCode)];
            [PPTAutoHideMessageView showMessage:[NSString stringWithString:errorMessage] inView:weak_self.view];
            
            [weak_self getNewImageCode];   //刷新验证码
            
            weak_self.imageCodeField.textField.text = @"";
            weak_self.messageCodeField.textField.text = @"";
            weak_self.imageCodeField.textField.placeholder = @"图形验证码";
            [weak_self.imageCodeField.textField becomeFirstResponder];
        }
    } failure:^(NSError *error) {
        [weak_self showLoading:NO];
        [PPTAutoHideMessageView showMessage:@"您的网络不给力" inView:weak_self.view];
        
        [weak_self getNewImageCode];   //刷新验证码
        weak_self.imageCodeField.textField.text = @"";
        weak_self.messageCodeField.textField.text = @"";
        weak_self.imageCodeField.textField.placeholder = @"图形验证码";
        [weak_self.imageCodeField.textField becomeFirstResponder];
    }];
}

//保存当前注册用户信息到本地
- (void)saveUserInfo:(PTPassportResponseItem *)item {
    PTSHARE_USER.user.userID = item.uid;
    PTSHARE_USER.user.userToken = item.token;
    PTSHARE_USER.user.userName = self.phoneField.textField.text;
    PTSHARE_USER.user.userPassword = self.passwordField.textField.text;
    PTSHARE_USER.user.userDeviceID = [PassportUtilTool getDeviceID];
    
    //由于注册时，自动生成默认昵称，这里保存默认昵称到本地。防止用户退出注册流程发表评论
    PTUserEditInfoItem *userInfo = [[PTUserEditInfoItem alloc] init];
    userInfo.nick_name = item.nickName;
    userInfo.head_img = @"";
    userInfo.profile = @"";
    
    PTSHARE_USER.userInfo = userInfo;
    [PTSHARE_USER updateToDisk];
    
        NSLog(@"----注册成功、更新本地的 头像、昵称、简介----");
        NSLog(@"USERINFO userID : %@ ",PTSHARE_USER.user.userID);
        NSLog(@"USERINFO userToken : %@ ",PTSHARE_USER.user.userToken);
        NSLog(@"USERINFO userName : %@ ",PTSHARE_USER.user.userName);
        NSLog(@"USERINFO nickName : %@ ",PTSHARE_USER.userInfo.nick_name);
        NSLog(@"USERINFO headImg : %@ ",PTSHARE_USER.userInfo.head_img);
        NSLog(@"USERINFO profile : %@ ",PTSHARE_USER.userInfo.profile);
}

//成功注册/登录后--对接 索威后台
- (void)userRegisterWithItem:(PTPassportResponseItem *)responseItem{
    //完善用户信息
    PTUserAddInfoViewController *addInfoVC = [[PTUserAddInfoViewController alloc] init];
    addInfoVC.userPhone = self.phoneField.textField.text;
    addInfoVC.userPassword = self.passwordField.textField.text;
    addInfoVC.passportResponseItem = responseItem;
    [self.navigationController pushViewController:addInfoVC animated:YES];
}


#pragma mark - private Method
- (void)finishRegister:(PTPassportResponseItem *)loginResponseItem{
    if ([PTSHARE_USER canAutoLogin]) {
        //发送广播给所有
        [[NSNotificationCenter defaultCenter] postNotificationName:PassportLoginNotification object:nil userInfo:nil];
        
        //回到进入的页面
        __weak typeof(self) weakSelf = self;
        [self dismissViewControllerAnimated:YES completion:^{
            if (weakSelf.actionBlock) {
                weakSelf.actionBlock(YES,loginResponseItem);
            }
        }];
    }
    
    
    return;
}

- (void)onServiceProtocalBtnClick{
    //用户协议
    PTUserProtocolViewController *protocolVC  =  [[PTUserProtocolViewController alloc] init];
    [self.navigationController pushViewController:protocolVC animated:YES];
}


- (void)getNewImageCode{
    self.imageCodeField.codeImageUrl = [PTPassport passportSendImageVerifyCodeWithAction:@"register"];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    [self resignAllResponder];
}
#pragma mark -

#pragma mark -  判断当前设备
// iphone 4 5 6 6p
-(NSString *)getCurrentDrive
{
    NSString *drive = @"";
    CGFloat mainHeight = Passport_Screenheight;
    if (mainHeight == 480) {
        drive = @"4";
    }
    
    if (mainHeight == 568) {
        drive = @"5";
    }
    
    if (mainHeight == 667) {
        drive = @"6";
    }
    
    if (mainHeight == 736) {
        drive = @"6p";
    }
    
    return drive;
}



//显示倒计时
- (void)showTimeCount
{
    //验证码相应
    [self.messageCodeField.textField becomeFirstResponder];
    
    if (!_showTimer) {
        self.messageCodeField.timeOut = NO;
        _showTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(Timing) userInfo:nil repeats:YES];
        //[_showTimer fire];
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


#pragma mark - <SOViewControllerProtocol>
- (void)setParameters:(id)parameters {
    [super setParameters:parameters];
    
}
#pragma mark -

@end
