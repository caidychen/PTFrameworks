//
//  PTPassportDemoVC.m
//  PTLib
//
//  Created by LiLiLiu on 16/3/11.
//  Copyright © 2016年 putao. All rights reserved.
//

#import "PTPassportDemoVC.h"

//Model
#import "PTPassportAPI.h"                //外部设置 Passport 根路径

//View
#import "SVProgressHUD.h"

//Controller
#import "PPTHeader.h"                    //包含所有  Passport 中的头文件
#import "PTUserLoginViewController.h"    //登录页面



static CGFloat const passProtDemoVCButtonHeight = 50.0f;
static CGFloat const passProtDemoVCButtonWidth = 124.0f;

@interface PTPassportDemoVC ()
@property (nonatomic,strong) UIButton *button;
@end

@implementation PTPassportDemoVC
@synthesize button = _button;

- (void)dealloc {
    // 清理登录成功，接收到该信息
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PassportLoginNotification object:nil];
    
    PPTRELEASE(_button);
    PPTSUPERDEALLOC();
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        //读取本机 keychine 保存用户信息
        [self startPassport];
        //初始化 Passport 
        [self passportSetting];
        
        // 登录成功，接收到该信息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginSuccess:) name:PassportLoginNotification object:nil];
    }
    return (self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"PassportDemo" color:[UIColor colorWithHexString:@"313131"] font:[UIFont systemFontOfSize:18.0f] selector:nil];
    
    [self.view addSubview:self.button];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.button.frame = CGRectMake(0, 0, passProtDemoVCButtonWidth, passProtDemoVCButtonHeight);
    self.button.center = self.view.center;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}


#pragma mark - getter
- (UIButton *)button{
    if (!_button) {
        _button = [[UIButton alloc] initWithFrame:CGRectZero];
        
        _button.titleLabel.font = [UIFont systemFontOfSize: 15.0];
        _button.backgroundColor = [UIColor colorWithHexString:@"95918C"];
        [_button setTitle:@"弹出登录页面" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}
#pragma mark -

#pragma mark - setter
#pragma mark -

#pragma mark - action
- (void)buttonPress:(UIButton *)sender{
    //登录
    if(![PTSHARE_USER canAutoLogin]) {
        PTPresentLoginViewControllerAnimated(self, YES, ^(BOOL success, PTPassportResponseItem *responseItem) {
            if (!success) {
                NSString *errorMessage = [NSString stringWithFormat:@"%@",PTPassportErrorCodeDescription(responseItem.errorCode)];
                [SVProgressHUD dismissWithError:errorMessage afterDelay:1];
                return;
            }
            
            //            NSLog(@"uid : %@ ",PTSHARE_USER.user.userID);
            //            NSLog(@"token : %@ ",PTSHARE_USER.user.userToken);
            //            NSLog(@"userName : %@ ",PTSHARE_USER.user.userName);
            //            NSLog(@"userAvatar : %@ ",PTSHARE_USER.user.userAvatar);
            //            NSLog(@"userPassword : %@ ",PTSHARE_USER.user.userPassword);
            //            NSLog(@"userDeviceID : %@ ",PTSHARE_USER.user.userDeviceID);
            
            SOJumpViewController(NSClassFromString(@"PTShoppingCartViewController"), nil, YES);
            /*
             //或者
             PTNavigationController *nav = [[PTNavigationController alloc] initWithRootViewController:loginVC];
             [self presentViewController:nav animated:YES completion:^{
             
             }];
             */
        });
        return;
    }
    
}

- (void)LoginSuccess:(NSNotification *)notification {
    //登录成功
    BOOL canLogin = [PTSHARE_USER canAutoLogin];
    if (canLogin) {
        NSLog(@"登录成功，这里可以 注册 JPush  红点通知");
        
        NSLog(@"uid : %@ ",PTSHARE_USER.user.userID);
        NSLog(@"token : %@ ",PTSHARE_USER.user.userToken);
        NSLog(@"userName : %@ ",PTSHARE_USER.user.userName);
        NSLog(@"userAvatar : %@ ",PTSHARE_USER.user.userAvatar);
        NSLog(@"userPassword : %@ ",PTSHARE_USER.user.userPassword);
        NSLog(@"userDeviceID : %@ ",PTSHARE_USER.user.userDeviceID);
        //传User数据给fengyang
    }
}
#pragma mark -

#pragma mark - App 从本地 keychine 中读取保存的用户信息
//启动app时调用
- (void)startPassport {
    //读取磁盘中保存的用户信息
    [PTSHARE_USER initSingletonFromDisk];
}

#pragma mark - PTPassport
- (void)passportSetting{
    //Passport 接口: 初始化 登录、注册、忘记密码接口需要参数
    //是否需要上传头像
    [PPTPassport setUpPassportWithClientType:@"1"
                                 platformID:@"1"
                                   deviceID:[PassportUtilTool getDeviceID]
                                      appID:PT_PROJECT_PassportAppID
                                    version:[PassportUtilTool getAppVersion]
                                  secretKey:PT_PROJECT_PassportAppSecretKey
                              baseURLString:PT_PROJECT_PassportServiceBaseURL
                             isUploadAvatar:YES];
    
    //Upload 接口: 初始化 图片上传需要的参数
    [PPTPassport setUpPassportWithUploadAppID:PT_PROJECT_UploadAppID
                        uploadServiceBaseURL:PT_PROJECT_UserServiceBaseURL
                               uploadBaseURL:PT_PROJECT_UploadBaseURL
                         uploadCheckExistURL:PT_PROJECT_UploadCheckExist
                           uploadGetTokenURL:PT_PROJECT_UploadGetToken
                               trueUploadURL:PT_PROJECT_UploadTrueUpload];
    
}
#pragma mark -


#pragma mark - <SOViewControllerProtocol>
- (void)setParameters:(id)parameters {
    [super setParameters:parameters];
    
}
#pragma mark -

@end
