//
//  PTUserAddInfoViewController.m
//  PTLatitude
//
//  Created by LiLiLiu on 15/11/30.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTUserAddInfoViewController.h"

//Model
#import "PTUserManager.h"
#import "PassportUtilTool.h"
#import "PTAUploadItem.h"
#import "PTAUploadSuccessItem.h"

//View
#import "UIColor+Help.h"
#import "SOAutoHideMessageView.h"
#import "PTLoginNavView.h"
#import "PTLoginNormalTextField.h"
#import "PTLoginAddPhotoView.h"
#import "PTPTextView.h"
#import "PassportMacro.h"

//Controller
#import "PTAUploadManager.h"    //验证并上传图片
#import "PTPassport.h"


//算标题高度
CGSize operateProfileTextFieldSize(NSString *text,CGFloat textWidth){
    CGSize size = CGSizeMake(0.0f, 0.0f);
    if(text && text.length > 0) {
        UIFont *font = [UIFont systemFontOfSize:16];
        CGSize textSize = [text soSizeWithFont:font constrainedToWidth:textWidth];
        size = textSize;
    }
    return (size);
}



#define MaxNumberOfProfileChars  40

static CGFloat const AddPhotoViewHeight = 120.0f;
static CGFloat const AddInfoVCInsets = 10.0f;

@interface PTUserAddInfoViewController ()<UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIActionSheetDelegate,PTAUploadManagerDelegate>

@property (nonatomic , strong) UIImageView *backgroundImage;
@property (nonatomic , strong) PTLoginNavView *navView;
@property (nonatomic , strong) PTLoginAddPhotoView *addPhotoView;
@property (nonatomic , strong) PTLoginNormalTextField *userNickField;
//@property (nonatomic , strong) PTPTextView *userInfoTextView;
@property (nonatomic, strong) UIView *userInfoTextViewBottomLine;

//相机拍照,照片及名称
@property (nonatomic,strong) UIImagePickerController *imagePickerController;
@property (nonatomic,strong) NSMutableArray *capturedImages;   //专门保存拍照照片的数组

//头像上传成功 返回的 SH1
@property (nonatomic,strong) PTAUploadSuccessItem *uploadSuccessItem; //封装上传成功返回数据的对象

@property (nonatomic, strong) PTPassportResponseItem *loginResponseItem;  //纪录登录返回的信息
@end

@implementation PTUserAddInfoViewController

@synthesize backgroundImage = _backgroundImage;
@synthesize navView = _navView;
@synthesize addPhotoView = _addPhotoView;
//@synthesize userInfoTextView = _userInfoTextView;
//@synthesize userInfoTextViewBottomLine = _userInfoTextViewBottomLine;
@synthesize userNickField = _userNickField;
@synthesize uploadSuccessItem = _uploadSuccessItem;
@synthesize loginResponseItem = _loginResponseItem;

- (void)dealloc {
    SORELEASE(_backgroundImage);
    SORELEASE(_navView);
    SORELEASE(_addPhotoView);
    SORELEASE(_userNickField);
//    SORELEASE(_userInfoTextView);
//    SORELEASE(_userInfoTextViewBottomLine);
    SORELEASE(_uploadSuccessItem);
    SORELEASE(_loginResponseItem);
    SOSUPERDEALLOC();
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        _imagePickerController = nil;
        _uploadSuccessItem = nil;
        _loginResponseItem = nil;
        
        _capturedImages = [[NSMutableArray alloc] init];
    }
    return (self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ptLoadingView.alpha = 0.4f;
    
    [self.view addSubview:self.backgroundImage];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.addPhotoView];
    [self.view addSubview:self.userNickField];
//    [self.view addSubview:self.userInfoTextView];
//    [self.view addSubview:self.userInfoTextViewBottomLine];
    
    // 通知控制字数限制
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textviewEditChanged:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:nil];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.backgroundImage.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    //这里是自定义导航栏宽高设置
    self.navView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), Passport_HEIGHT_NAV+Passport_HEIGHT_STATUS);
    
    self.addPhotoView.frame = CGRectMake(0, CGRectGetMaxY(self.navView.frame), CGRectGetWidth(self.view.frame), AddPhotoViewHeight);
    
    CGFloat textFieldWidth = CGRectGetWidth(self.view.frame)-AddInfoVCInsets*2;
    self.userNickField.frame = CGRectMake(AddInfoVCInsets, CGRectGetMaxY(self.addPhotoView.frame), textFieldWidth, 44.0f);
    
    
//    CGSize profileSize = operateProfileTextFieldSize(self.userInfoTextView.text,textFieldWidth);
//    self.userInfoTextView.frame = CGRectMake(AddInfoVCInsets, CGRectGetMaxY(self.userNickField.frame), textFieldWidth, profileSize.height<= 20.0f?44.0f:56.0f);
//    
//    self.userInfoTextViewBottomLine.frame = CGRectMake(AddInfoVCInsets, CGRectGetMaxY(self.userInfoTextView.frame), CGRectGetWidth(self.view.bounds)-AddInfoVCInsets*2, 0.5);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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
        _navView.title = @"完善用户信息";
        [_navView.rightBtn setTitle:@"保存" forState:UIControlStateNormal];
        
        __weak typeof(self) weakSelf = self;
        _navView.leftActionBlock = ^(){
            //点击取消按钮
            [weakSelf leftItemTouched];
        };
        _navView.rightActionBlock = ^(){
            //点击保存按钮
            [weakSelf rightButtonTouched];
        };
        
    }
    return _navView;
}


- (PTLoginAddPhotoView *)addPhotoView{
    if (!_addPhotoView) {
        _addPhotoView = [[PTLoginAddPhotoView alloc] initWithFrame:CGRectZero];
        __weak typeof(self) weakSelf = self;
        _addPhotoView.actionBlock = ^(){
            //点击头像
            [weakSelf toMyAvararEditVC];
        };
        
        
    }
    return _addPhotoView;
}

- (PTLoginNormalTextField *)userNickField{
    if (!_userNickField) {
        _userNickField = [[PTLoginNormalTextField alloc] initWithFrame:CGRectZero];
        _userNickField.type = CharacterTextFieldType;
        _userNickField.placeholder = @" 用户昵称";
        _userNickField.actionBlock = ^(NSString *text ,BOOL isSuccess){
            //回调
        };
    }
    return _userNickField;
}

//- (PTPTextView *)userInfoTextView{
//    if (!_userInfoTextView) {
//        _userInfoTextView = [[PTPTextView alloc] initWithFrame:CGRectZero];
//        _userInfoTextView.backgroundColor = [UIColor clearColor];
//        _userInfoTextView.delegate = self;
//        _userInfoTextView.myPlaceholder = @"个人简介(0-40个字)";
//        _userInfoTextView.myPlaceholderColor = [UIColor colorWithHexString:@"C6C5CE"];
//        
//        /*
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        paragraphStyle.lineSpacing = 5;
//        NSDictionary *attributes = @{
//                                     NSFontAttributeName:[UIFont systemFontOfSize:14],
//                                     NSParagraphStyleAttributeName:paragraphStyle
//                                     };
//        _userInfoTextView.attributedText = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
//         */
//     }
//    return _userInfoTextView;
//}

- (UIView *)userInfoTextViewBottomLine{
    if (!_userInfoTextViewBottomLine) {
        _userInfoTextViewBottomLine = [[UIView alloc] initWithFrame:CGRectZero];
        _userInfoTextViewBottomLine.backgroundColor = Passport_TEXT_INPUT_LINE_COLOR;
    }
    return _userInfoTextViewBottomLine;
}
#pragma mark -



#pragma makr - Setter
- (void)setPassportResponseItem:(PTPassportResponseItem *)passportResponseItem{
    _passportResponseItem = passportResponseItem;
    if (!_passportResponseItem) {
        return;
    }
    
    self.userNickField.textField.text = _passportResponseItem.nickName;
    self.loginResponseItem = _passportResponseItem;
    
    NSLog(@"addInfoVC setPassportResponseItem");
    NSLog(@"USERINFO userID : %@ ",_passportResponseItem.uid);
    NSLog(@"USERINFO userToken : %@ ",_passportResponseItem.token);
    NSLog(@"USERINFO userName : %@ ",_passportResponseItem.nickName);
    NSLog(@"USERINFO avatar : %@ ",_passportResponseItem.avatar);
}
#pragma mark -




#pragma mark - action
- (void)leftItemTouched{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)rightButtonTouched {
    [self resignAllFirstResponder];
    
    NSString *nickName = self.userNickField.textField.text;
//    NSString *userProfile = self.userInfoTextView.text;
    
    //去掉字符串首尾空格
    NSString *cleanNickName = [nickName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (cleanNickName.length == 0) {
        cleanNickName = self.passportResponseItem.nickName;
    }
    if (cleanNickName.length > 0 && (cleanNickName.length <Passport_LENGHT_NICK_NOR || cleanNickName.length > Passport_LENGHT_NICK_MAX)) {
        [SOAutoHideMessageView showMessage:Passport_TEXT_NICKNAME_FAIL inView:self.view];
        return;
    }
    
    
    
//    NSString *cleanUserProfile = [userProfile stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    if (cleanUserProfile.length > 40) {
//        [SOAutoHideMessageView showMessage:@"个人简介内容请不要超过40个字" inView:self.view];
//        return;
//    }
    
    /*
    //这里验证被佳佳当作 Bug。去掉验证
    if (!self.uploadSuccessItem) {
        [SOAutoHideMessageView showMessage:@"请上传头像" inView:self.view];
        return;
    }

    if (nickName.length == 0) {
        [SOAutoHideMessageView showMessage:@"请填写昵称" inView:self.view];
        return;
    }
    */
    
    [SOAutoHideMessageView showMessage:@"注册并登录成功!" inView:self.view];
    
    [self startLoadAnimation];
    __weak typeof(self) weak_self = self;
    [PTPassport passportSetNickNameWithNickName:[nickName trim] uid:self.passportResponseItem.uid token:self.passportResponseItem.token success:^(PTPassportResponseItem *responseItem) {
        weak_self.loginResponseItem.nickName = [nickName trim];
        
        if (responseItem.errorCode == 0) {
            //设置 passport 头像
            __strong typeof(weak_self) strong_weak_self = weak_self;
            [PTPassport passportSetUserAvatarWithHash:self.uploadSuccessItem.filehash ext:self.uploadSuccessItem.ext uid:self.passportResponseItem.uid token:self.passportResponseItem.token success:^(PTPassportResponseItem *responseItem) {
                [strong_weak_self stopLoadAnimation];
                
                if (responseItem.errorCode == 0) {
                    //获取 passport 头像
                    __strong typeof(strong_weak_self) strong_strong_weak_self = strong_weak_self;
                    [PTPassport passportGetUserAvatarWithUid:strong_weak_self.loginResponseItem.uid token:strong_weak_self.loginResponseItem.token success:^(PTPassportResponseItem *responseItem) {
                        
                        if (responseItem.errorCode == 0) {
                            /*
                            //注意事项:服务器返回图片无法按照指定尺寸裁切
                            //http://account.file.dev.putaocloud.com/file/e2b9604aa945bfc94d11ed72e5d3450c8c627961.jpg
                            //需要转换成相机专用的图片服务器路径，可以按照指定尺寸裁切
                            //http://camera.file.dev.putaocloud.com/file/e2b9604aa945bfc94d11ed72e5d3450c8c627961_96x96.jpg
                            NSString *subString = [responseItem.avatar substringFromIndex:15];
                            NSString *newAvatarString = [NSString stringWithFormat:@"http://camera.%@",subString];
                             */
                            strong_strong_weak_self.loginResponseItem.avatar = responseItem.avatar;
                            
                            [strong_strong_weak_self saveUserInfo:strong_strong_weak_self.loginResponseItem];
                            
                            [strong_strong_weak_self updateUserInfo];
                        }
                        
                    } failure:^(NSError *error) {
                        
                    }];

                }
                
            } failure:^(NSError *error) {
                
            }];
            
        }
        
        
        
    } failure:^(NSError *error) {
        
    }];
    
}


- (void)toMyAvararEditVC{
    [self resignAllFirstResponder];

    //设置头像
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"拍照", @"从手机相册选择",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    actionSheet.delegate = self;
//    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    [actionSheet showInView:self.view];
}


- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    [self resignAllFirstResponder];
}


- (void)resignAllFirstResponder{
    if ([self.userNickField.textField isFirstResponder]) {
        [self.userNickField.textField resignFirstResponder];
    }
//    if ([self.userInfoTextView isFirstResponder]) {
//        [self.userInfoTextView resignFirstResponder];
//    }
}

- (void)saveUserInfo:(PTPassportResponseItem *)item {
    User *user = PTSHARE_USER.user;
    user.userID = item.uid;
    user.userToken = item.token;
    user.userNick = item.nickName;
    user.userName = self.userPhone;
    user.userPassword = self.userPassword;
    user.userDeviceID = [PassportUtilTool getDeviceID];
    user.userAvatar = item.avatar;
    [PTSHARE_USER updateToDisk];
}

- (void)updateUserInfo{
    if ([PTSHARE_USER canAutoLogin]) {
        //发送广播给所有
        [[NSNotificationCenter defaultCenter] postNotificationName:PassportLoginNotification object:nil userInfo:nil];
        
        //回到进入的页面
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    }
    
    
    return;
}
#pragma mark -

#pragma mark - 监听UITextViewTextDidChangeNotification通知
// 通知实现字数限制
- (void)textviewEditChanged:(NSNotification *)notification
{
//    PTPTextView *textView = (PTPTextView *)notification.object;
//    if (textView == self.userInfoTextView && [textView isFirstResponder])
//    {
//        // 限制长度，包括汉字
//        [self limitIncludeChineseTextView:self.userInfoTextView Length:MaxNumberOfProfileChars];
//    }
}


// 用于限制UITextView的输入中英文限制
- (void)limitIncludeChineseTextView:(UITextView *)textview Length:(NSUInteger)kMaxLength
{
    NSString *limitString = textview.text;
    NSUInteger length = limitString.length;
    
//    NSInteger charCount = MaxNumberOfProfileChars-limitString.length;
//    NSUInteger leftCount = (charCount<0) ?0:charCount;
//    NSLog(@"监听的 当前剩余字数为 : %ld ",leftCount);
    
    // 键盘输入模式
//    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];
//    if ([lang isEqualToString:@"zh-Hans"])
    NSArray *currentar = [UITextInputMode activeInputModes];
    UITextInputMode *current = [currentar firstObject];
    if ([current.primaryLanguage isEqualToString:@"zh-Hans"])
    {
        // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textview markedTextRange];
        // 获取高亮部分
        UITextPosition *position = [textview positionFromPosition:selectedRange.start offset:0];
        
        if (!position)
        {
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (length > kMaxLength)
            {
                textview.text = [limitString substringToIndex:kMaxLength];
                [SOAutoHideMessageView showMessage:@"个人简介内容请不要超过40个字" inView:self.view];
                [self.view setNeedsLayout];
            }else{
                [self.view setNeedsLayout];
            }
        }
        else
        {
            // 有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    }
    else
    {
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (length > kMaxLength)
        {
            textview.text = [limitString substringToIndex:kMaxLength];
            [SOAutoHideMessageView showMessage:@"个人简介内容请不要超过40个字" inView:self.view];
            [self.view setNeedsLayout];
        }else{
            [self.view setNeedsLayout];
        }
    }
}
#pragma mark -




#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    /*
    if (textView == self.userInfoTextView) {
        if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
            if ([self.userInfoTextView isFirstResponder]) {
                [self.userInfoTextView resignFirstResponder];
            }
            
            return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
        }
        
        //如果是在一段字中间插入的时候呢。这个是有可能出现的
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
        //如果有高亮且当前字数开始位置小于最大限制时允许输入
        if (selectedRange && pos) {
            NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
            NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
            NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
            
            if (offsetRange.location < MaxNumberOfProfileChars) {
                return YES;
            }
            else
            {
                return NO;
            }
        }
        
        
        NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
        NSInteger caninputlen = MaxNumberOfProfileChars-comcatstr.length;
        
        if (0 == comcatstr.length) {
            self.userInfoTextView.myPlaceholder = @"个人简介(0-40个字)";
        }
        else {
            self.userInfoTextView.myPlaceholder = @"";
        }
        
        if (caninputlen >= 0)
        {
            return YES;
        }
        else
        {
            //输入字数判断
            NSInteger len = text.length + caninputlen;
            //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
            NSRange rg = {0,MAX(len,0)};
            
            //处理直接复制 超过 40 字后字数提醒
            if (rg.length > 0)
            {
                NSString *s = [text substringWithRange:rg];
                //既然是超出部分截取了，哪一定是最大限制了。
                [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            }
            return NO;
        }
        
    }
    */
    return YES;
    
}
#pragma mark -



#pragma mark - ActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isRearCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            }
            controller.allowsEditing = YES;          //拍照完成有正方形裁切框
            controller.showsCameraControls = YES; //不自定义相机控制按钮
            
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            self.imagePickerController = controller;
            
            [self presentViewController:controller animated:YES completion:^{
                
                if (![PassportUtilTool checkCameraCanUse]) {
                    
                    UIAlertView* notChecked = [[UIAlertView alloc]initWithTitle:nil message:@"此功能需要开启您的相机,请您去系统设置->隐私->相机进行设置" delegate:controller cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                    [notChecked show];
                }
                
            }];
            
        }
        
    }
    else if (1 == buttonIndex) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable] && [PassportUtilTool checkALAssetsLibraryCanUse]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            controller.allowsEditing = YES;
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            self.imagePickerController = controller;
            
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                             }];
        }else{
            
            [self showNotice:@"此功能需要开启您的照片,请您去系统设置->隐私->照片进行设置" withBtnName:@"我知道了"];
        }
        
        
    }
    else if (2 == buttonIndex) {
        return;
    }
}


- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    if (SOSystemVersion() < 8.0) {
        for (UIView *subViwe in actionSheet.subviews) {
            if ([subViwe isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton*)subViwe;
                if ([button.titleLabel.text isEqualToString:@"取消"]) {
                    //                    [button setTitleColor:COLOR_MAKE(253, 71, 43, 1) forState:UIControlStateNormal];
                }
            }
        }
    }
    else {
        
    }
}



#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (self.capturedImages) {
        [self.capturedImages removeAllObjects];
    }
    
    UIImage *portraitImg = [info objectForKey:UIImagePickerControllerEditedImage];
    if(!portraitImg) {
        portraitImg = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    UIImage *reSizeImage = [PassportUtilTool reSizeImage:portraitImg WithWidth:1242];
    
    //更新页面照片
    self.addPhotoView.photoImge = reSizeImage;
    
    //保存图片到数组中
    [self.capturedImages addObject:reSizeImage];
    
    //释放拍照界面
    [self finishAndUpdate];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        //隐藏状态栏
//        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }];
}


#pragma mark - <PTUploadOperationDelegate>
- (void)uploadOperation:(PTUploadOperation *)operation progress:(double)progress{
//    NSLog(@"上传进度 %f ",progress);
}


- (void)uploadOperationDidFinish:(PTUploadOperation *)operation responseObj:(id)responseObj{
    [self stopLoadAnimation];
    [SOAutoHideMessageView showMessage:@"头像上传成功" inView:self.view];
    
    if(responseObj && [responseObj isKindOfClass:[NSDictionary class]]) {
        self.uploadSuccessItem =  [PTAUploadSuccessItem itemWithDict:responseObj];
    }
}

- (void)uploadOperationDidFailure:(PTUploadOperation *)operation{
    [self stopLoadAnimation];
    [SOAutoHideMessageView showMessage:@"头像上传失败,请重新上传" inView:self.view];
}
#pragma mark -

#pragma mark -   压缩并保存 刷新界面
//释放界面，并刷新页面
- (void)finishAndUpdate
{
    __weak typeof(self) weakSelf = self;
    [self.imagePickerController dismissViewControllerAnimated:YES completion:^{
        weakSelf.imagePickerController = nil;
        //隐藏状态栏
//        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }];
    
    if ([self.capturedImages count] > 0)
    {
        __weak typeof(self) weakSelf = self;
        PTAUploadItem *item = [[PTAUploadItem alloc] init];
        item.image = [weakSelf.capturedImages objectAtIndex:0];
        item.userID = PTCURRENT_USER.userID;
        
        //开始上传照片到图片服务器
        [self startLoadAnimation];
        [PTAUploadManager manager].delegate = self;
        [PTAUploadManager addUploadItem:item];
    }
    
    
}

- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

- (void)showNotice:(NSString *)noticeString withBtnName:(NSString *)btnName {
    UIAlertView* notChecked = [[UIAlertView alloc]initWithTitle:nil message:noticeString delegate:self cancelButtonTitle:btnName otherButtonTitles: nil];
    [notChecked show];
}


#pragma mark - <SOViewControllerProtocol>
- (void)setParameters:(id)parameters {
    [super setParameters:parameters];
    
}
#pragma mark -






@end
