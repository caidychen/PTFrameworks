//
//  PTShareView.m
//  PTLatitude
//
//  Created by CHEN KAIDI on 11/12/2015.
//  Copyright © 2015 PT. All rights reserved.
//

#import "PTShareView.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "WeiboSDK.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

UIImage *imageWithImageSimple(UIImage *image, CGSize newSize)
{
    newSize = CGSizeMake(floorf(newSize.width), floorf(newSize.height));
    UIGraphicsBeginImageContext(newSize);//根据当前大小创建一个基于位图图形的环境
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];//根据新的尺寸画出传过来的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();//从当前环境当中得到重绘的图片
    UIGraphicsEndImageContext();//关闭当前环境
    return newImage;
}

#define shareViewForScreenWidth     [UIScreen mainScreen].bounds.size.width
#define shareViewForScreenHeight    [UIScreen mainScreen].bounds.size.height

#define kShareTotalHeight 280
#define kShareTotalHeightSmall 200
#define kSplitterHeight 10
#define kCancelButtonHeight 44
#define kPageSize 8


@interface PTShareView ()

@property (nonatomic, strong) NSMutableArray *shareIconArray;
@property (nonatomic, strong) NSMutableArray *shareTitleArray;
@property (nonatomic, strong) NSArray *options;
@property (nonatomic, assign) shareType shareType;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *thumb;
@property (nonatomic, strong) NSString *webURL;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *msgDescription;

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *dismissBackdrop;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *dashboard;
@property (nonatomic, strong) UIView *splitterView;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, copy) PTShareViewActionBlock actionBlock;
@end

@implementation PTShareView
 NSString *PTShareOptionWechatFriends = @"PTShareOptionWechatFriend";
 NSString *PTShareOptionWechatNewsFeed = @"PTShareOptionWechatNewsFeed";
 NSString *PTShareOptionQQFriends = @"PTShareOptionQQFriends";
 NSString *PTShareOptionQQZone = @"PTShareOptionQQZone";
 NSString *PTShareOptionSinaWeibo = @"PTShareOptionSinaWeibo";
 NSString *PTShareOptionWebLink = @"PTShareOptionWebLink";
-(instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.shareIconArray = [[NSMutableArray alloc] init];
        self.shareTitleArray = [[NSMutableArray alloc] init];
    }
    return self;
}

+(void)showOptionsWithTitle:(NSString *)title thumbImage:(UIImage *)thumb webURL:(NSString *)webURL message:(NSString *)message description:(NSString *)description type:(shareType)type options:(NSArray *)options actionBlock:(PTShareViewActionBlock)block{
    PTShareView *shareView = [[PTShareView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    shareView.options = options;
    shareView.title = title;
    shareView.thumb = thumb;
    shareView.webURL = webURL;
    shareView.message = message;
    shareView.msgDescription = description;
    shareView.shareType = type;
    shareView.actionBlock = block;
    [shareView showView];
}


-(void)addAPIWithShareOption:(NSString *)shareOption{
    if ([shareOption isEqualToString:PTShareOptionWechatFriends]) {
        [self.shareTitleArray addObject:@"微信好友"];
        [self.shareIconArray addObject:@"icon_40_01"];
    }else if ([shareOption isEqualToString:PTShareOptionWechatNewsFeed]) {
        [self.shareTitleArray addObject:@"微信朋友圈"];
        [self.shareIconArray addObject:@"icon_40_02"];
    }else if ([shareOption isEqualToString:PTShareOptionQQFriends]) {
        [self.shareTitleArray addObject:@"QQ好友"];
        [self.shareIconArray addObject:@"icon_40_03"];
    }else if ([shareOption isEqualToString:PTShareOptionQQZone]) {
        [self.shareTitleArray addObject:@"QQ空间"];
        [self.shareIconArray addObject:@"icon_40_04"];
    }else if ([shareOption isEqualToString:PTShareOptionSinaWeibo]) {
        [self.shareTitleArray addObject:@"新浪微博"];
        [self.shareIconArray addObject:@"icon_40_05"];
    }else if ([shareOption isEqualToString:PTShareOptionWebLink]) {
        [self.shareTitleArray addObject:@"复制链接"];
        [self.shareIconArray addObject:@"icon_40_06"];
    }
    
}

-(void)showView{
    
    for(NSString *option in self.options){
        [self addAPIWithShareOption:option];
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self addSubview:self.dismissBackdrop];
    if (self.options.count<=4) {
        self.baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, shareViewForScreenWidth, kShareTotalHeightSmall+50)];
    }else{
        self.baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, shareViewForScreenWidth, kShareTotalHeight+50)];
    }
    
    self.baseView.backgroundColor = [UIColor whiteColor];
    [self.baseView addSubview:self.dashboard];
    [self.dashboard addSubview:self.scrollView];
    [self.baseView addSubview:self.splitterView];
    [self.baseView addSubview:self.cancelButton];
    [self.dashboard addSubview:self.titleLabel];
    [self addSubview:self.baseView];
    self.titleLabel.text = self.title;
    self.baseView.center = CGPointMake(self.baseView.centerX, shareViewForScreenHeight+self.baseView.height/2);
    __weak typeof(self) weak_self = self;
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.6
                        options:UIViewAnimationOptionCurveEaseIn animations:^{
                            weak_self.baseView.center = CGPointMake(weak_self.baseView.centerX, shareViewForScreenHeight-weak_self.baseView.height/2+50);
                        } completion:^(BOOL finished) {}];
    [weak_self setNeedsLayout];
}

-(void)hide:(UIButton *)sender{
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
                            weakSelf.baseView.center = CGPointMake(weakSelf.baseView.centerX, shareViewForScreenHeight+weakSelf.baseView.height/2);
                            weakSelf.dismissBackdrop.alpha = 0.0;
                        } completion:^(BOOL finished) {
                            [weakSelf removeFromSuperview];
                        }];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.dashboard.frame = CGRectMake(0, 0, self.dashboard.width, self.dashboard.height);
    self.splitterView.frame = CGRectMake(0, self.dashboard.bottom, self.splitterView.width, self.splitterView.height);
    self.cancelButton.frame = CGRectMake(0, self.splitterView.bottom, self.cancelButton.width, self.cancelButton.height);
    self.titleLabel.frame = CGRectMake(0, 20, self.width, self.titleLabel.font.lineHeight);
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.scrollView.frame = CGRectMake(0, self.titleLabel.bottom, self.width, self.dashboard.height-self.titleLabel.bottom-20);
    
    NSInteger totalIconNumber = self.shareIconArray.count;
    NSInteger numberOfPage = ceilf((float)totalIconNumber/kPageSize);
    NSInteger offset = 0;
    for (NSInteger i=0; i<numberOfPage; i++) {
        UIView *dashboardPage = [self dashboardPageWithFrame:self.scrollView.frame atOffset:offset];
        offset += kPageSize;
        dashboardPage.frame = CGRectMake(dashboardPage.width*i, 0, dashboardPage.width, dashboardPage.height);
        [self.scrollView addSubview:dashboardPage];
        [self.scrollView setContentSize:CGSizeMake(dashboardPage.right, self.scrollView.height)];
    }
}

-(UIView *)dashboardPageWithFrame:(CGRect)frame atOffset:(NSInteger)offset{
    UIView *page = [[UIView alloc] initWithFrame:frame];
    NSInteger x = 1;
    NSInteger y = 1;
    CGFloat width = self.scrollView.width/4;
    CGFloat height = self.scrollView.height/2;
    if (self.options.count<=4) {
        height = self.scrollView.height;
    }
    for (NSInteger i=0; i<kPageSize; i++) {
        if (i+offset==self.shareIconArray.count) {
            break;
        }
        UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(width*(x-1), height*(y-1), width, height)];
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake((control.width-40)/2, 20, 40, 40)];
        icon.image = [UIImage imageNamed:[self.shareIconArray safeObjectAtIndex:i+offset]];
        [control addSubview:icon];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, icon.bottom+10, control.width, [UIFont systemFontOfSize:12].lineHeight)];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithHexString:@"646464"];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [self.shareTitleArray safeObjectAtIndex:i+offset];
        [control addSubview:label];
        if ((i+1)%4 == 0) {
            x=1;
            y++;
        }else{
            x++;
        }
        [page addSubview:control];
        control.tag = i+offset;
        [control addTarget:self action:@selector(didTapShareControl:) forControlEvents:UIControlEventTouchUpInside];
    }
    return page;
}

-(void)didTapShareControl:(UIControl *)control{
    NSString *shareOption = [self.options safeObjectAtIndex:control.tag];

    if ([shareOption isEqualToString:PTShareOptionWechatFriends]) {
        [self sendToWeChatFriends];
    }else if ([shareOption isEqualToString:PTShareOptionWechatNewsFeed]) {

        [self sendToWeChatTimeLine];
        
    }else if ([shareOption isEqualToString:PTShareOptionQQFriends]) {
        [self sendToQQFriends];

    }else if ([shareOption isEqualToString:PTShareOptionQQZone]) {
        
        [self sendToQQZone];
        
    }else if ([shareOption isEqualToString:PTShareOptionSinaWeibo]) {
        
        [self sendToSinaWeiBo];
        
    }else if ([shareOption isEqualToString:PTShareOptionWebLink]) {
        
        [self copyWebLink];
        
    }
}

// 分享成功后
- (void)shareWhenCompleteWithState:(SSDKResponseState)state andError:(NSError *)error{

    switch (state) {
        case SSDKResponseStateBegin:
            
            break;
        case SSDKResponseStateSuccess:
            [self hide:self.dismissBackdrop];
            NSLog(@"分享成功");
//            [SVProgressHUD showSuccessWithStatus:@"分享成功" duration:2.0];
            break;
        case SSDKResponseStateFail:
            if (error) {
                if ([error.userInfo safeObjectForKey:@"error_message"]) {
//                    [SVProgressHUD showErrorWithStatus:[error.userInfo safeObjectForKey:@"error_message"] duration:2.0];
                    NSLog(@"%@", [error.userInfo safeObjectForKey:@"error_message"]);
                }
            } else {
                NSLog(@"分享失败");
//                [SVProgressHUD showErrorWithStatus:@"分享失败" duration:2.0];
            }
            break;
        case SSDKResponseStateCancel:
            
            break;
            
        default:
            break;
    }
}


CGFloat const PTShareImageMaxSize        = 8 * 1024.0f * 1024.0f;     //微信分享图片最大size
CGFloat const PTShareImageThumbSize       = 30 * 1024.0f;     //微信分享图片预览size
UIImage *PTShareCopmpressImage(CGFloat maxSize, UIImage *image){
    CGFloat offset = 1;
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    if(data && data.length > 0) {
        offset = MIN(offset, maxSize / data.length);
        offset = sqrtf(offset);
    }
    //压缩图片大小
    if (ABS(1.0f - offset) < 0.000001) {
        return image;
    }
    image = imageWithImageSimple(image, CGSizeMake(image.size.width * offset, image.size.height * offset));
    return image;
}


#pragma mark -- actions
/**
 * @brief 微信好友分享
 */
- (void)sendToWeChatFriends {
    __weak typeof(self) weak_self = self;
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];

    if (self.shareType == shareTypeForWebPage) {
        [shareParams SSDKSetupWeChatParamsByText:self.msgDescription
                                           title:self.message
                                             url:[NSURL URLWithString:self.webURL]
                                      thumbImage:PTShareCopmpressImage(PTShareImageThumbSize, self.thumb)
                                           image:self.thumb
                                    musicFileURL:nil
                                         extInfo:self.msgDescription
                                        fileData:nil
                                    emoticonData:nil
                                            type:SSDKContentTypeWebPage
                              forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    } else if (self.shareType == shareTypeForImage) {
        [shareParams SSDKSetupWeChatParamsByText:self.msgDescription
                                           title:self.message
                                             url:nil
                                      thumbImage:PTShareCopmpressImage(PTShareImageThumbSize, self.thumb)
                                           image:self.thumb
                                    musicFileURL:nil
                                         extInfo:self.msgDescription
                                        fileData:nil
                                    emoticonData:nil
                                            type:SSDKContentTypeImage
                              forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    } else if (self.shareType == shareTypeForVideo) {
        [shareParams SSDKSetupWeChatParamsByText:self.msgDescription
                                           title:self.message
                                             url:[NSURL URLWithString:self.webURL]
                                      thumbImage:PTShareCopmpressImage(PTShareImageThumbSize, self.thumb)
                                           image:self.thumb
                                    musicFileURL:nil
                                         extInfo:self.msgDescription
                                        fileData:nil
                                    emoticonData:nil
                                            type:SSDKContentTypeVideo
                              forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    } else {
        [shareParams SSDKSetupWeChatParamsByText:self.msgDescription
                                           title:self.message
                                             url:nil
                                      thumbImage:PTShareCopmpressImage(PTShareImageThumbSize, self.thumb)
                                           image:nil
                                    musicFileURL:nil
                                         extInfo:self.msgDescription
                                        fileData:nil
                                    emoticonData:nil
                                            type:SSDKContentTypeAuto
                              forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    }
    [ShareSDK share:SSDKPlatformSubTypeWechatSession parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        [weak_self shareWhenCompleteWithState:state andError:error];
        
        if (weak_self.actionBlock) {
            weak_self.actionBlock(PTShareOptionWechatFriends);
        }
    }];
}

/**
 * @brief 微信朋友圈
 */
- (void)sendToWeChatTimeLine {
    __weak typeof(self) weak_self = self;
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    if (self.shareType == shareTypeForWebPage) {
        [shareParams SSDKSetupWeChatParamsByText:self.msgDescription
                                           title:self.message
                                             url:[NSURL URLWithString:self.webURL]
                                      thumbImage:PTShareCopmpressImage(PTShareImageThumbSize, self.thumb)
                                           image:self.thumb
                                    musicFileURL:nil
                                         extInfo:self.msgDescription
                                        fileData:nil
                                    emoticonData:nil
                                            type:SSDKContentTypeWebPage
                              forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    } else if (self.shareType == shareTypeForImage) {
        [shareParams SSDKSetupWeChatParamsByText:self.msgDescription
                                           title:self.message
                                             url:nil
                                      thumbImage:PTShareCopmpressImage(PTShareImageThumbSize, self.thumb)
                                           image:self.thumb
                                    musicFileURL:nil
                                         extInfo:self.msgDescription
                                        fileData:nil
                                    emoticonData:nil
                                            type:SSDKContentTypeImage
                              forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    } else if (self.shareType == shareTypeForVideo) {
        [shareParams SSDKSetupWeChatParamsByText:self.msgDescription
                                           title:self.message
                                             url:[NSURL URLWithString:self.webURL]
                                      thumbImage:PTShareCopmpressImage(PTShareImageThumbSize, self.thumb)
                                           image:self.thumb
                                    musicFileURL:nil
                                         extInfo:self.msgDescription
                                        fileData:nil
                                    emoticonData:nil
                                            type:SSDKContentTypeVideo
                              forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    } else {
        [shareParams SSDKSetupWeChatParamsByText:self.msgDescription
                                           title:self.message
                                             url:nil
                                      thumbImage:PTShareCopmpressImage(PTShareImageThumbSize, self.thumb)
                                           image:nil
                                    musicFileURL:nil
                                         extInfo:self.msgDescription
                                        fileData:nil
                                    emoticonData:nil
                                            type:SSDKContentTypeAuto
                              forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    }
    [ShareSDK share:SSDKPlatformSubTypeWechatTimeline parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        [weak_self shareWhenCompleteWithState:state andError:error];
        
        if (weak_self.actionBlock) {
            weak_self.actionBlock(PTShareOptionWechatNewsFeed);
        }
    }];
}

/**
 * @brief QQ好友分享
 */
- (void)sendToQQFriends {
    
    __weak typeof(self) weak_self = self;
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    if (self.shareType == shareTypeForWebPage) {
        [shareParams SSDKSetupQQParamsByText:self.msgDescription
                                       title:self.message
                                         url:[NSURL URLWithString:self.webURL]
                                  thumbImage:self.thumb
                                       image:nil
                                        type:SSDKContentTypeWebPage
                          forPlatformSubType:SSDKPlatformSubTypeQQFriend];
    } else if (self.shareType == shareTypeForImage) {
        [shareParams SSDKSetupQQParamsByText:self.msgDescription
                                       title:self.message
                                         url:[NSURL URLWithString:self.webURL]
                                  thumbImage:self.thumb
                                       image:self.thumb
                                        type:SSDKContentTypeImage
                          forPlatformSubType:SSDKPlatformSubTypeQQFriend];
    } else if (self.shareType == shareTypeForVideo) {
        [shareParams SSDKSetupQQParamsByText:self.msgDescription
                                       title:self.message
                                         url:[NSURL URLWithString:self.webURL]
                                  thumbImage:self.thumb
                                       image:self.thumb
                                        type:SSDKContentTypeVideo
                          forPlatformSubType:SSDKPlatformSubTypeQQFriend];
    } else {
        [shareParams SSDKSetupQQParamsByText:self.msgDescription
                                       title:self.message
                                         url:[NSURL URLWithString:self.webURL]
                                  thumbImage:self.thumb
                                       image:self.thumb
                                        type:SSDKContentTypeAuto
                          forPlatformSubType:SSDKPlatformSubTypeQQFriend];
    }
    [ShareSDK share:SSDKPlatformSubTypeQQFriend parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        [weak_self shareWhenCompleteWithState:state andError:error];
        NSLog(@"%@", error);
        
        if (weak_self.actionBlock) {
            weak_self.actionBlock(PTShareOptionQQFriends);
        }
    }];
}

/**
 * @brief QQ空间分享
 */
- (void)sendToQQZone {
    __weak typeof(self) weak_self = self;
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    if (self.shareType == shareTypeForWebPage) {
        
        [shareParams SSDKSetupQQParamsByText:self.msgDescription
                                       title:self.message
                                         url:[NSURL URLWithString:self.webURL]
                                  thumbImage:self.thumb
                                       image:nil
                                        type:SSDKContentTypeWebPage
                          forPlatformSubType:SSDKPlatformSubTypeQZone];
    } else if (self.shareType == shareTypeForImage) {
        
//        [SVProgressHUD showErrorWithStatus:@"QQ空间无法分享该内容" duration:1.0f];
        return;

    } else if (self.shareType == shareTypeForVideo) {
        [shareParams SSDKSetupQQParamsByText:self.msgDescription
                                       title:self.message
                                         url:[NSURL URLWithString:self.webURL]
                                  thumbImage:self.thumb
                                       image:self.thumb
                                        type:SSDKContentTypeVideo
                          forPlatformSubType:SSDKPlatformSubTypeQZone];
    } else {
        [shareParams SSDKSetupQQParamsByText:self.msgDescription
                                       title:self.message
                                         url:[NSURL URLWithString:self.webURL]
                                  thumbImage:self.thumb
                                       image:self.thumb
                                        type:SSDKContentTypeAuto
                          forPlatformSubType:SSDKPlatformSubTypeQZone];
    }
    [ShareSDK share:SSDKPlatformSubTypeQZone parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        [weak_self shareWhenCompleteWithState:state andError:error];
        NSLog(@"%@", error);
        
        if (weak_self.actionBlock) {
            weak_self.actionBlock(PTShareOptionQQZone);
        }
        
    }];
}

/**
 * @brief 新浪微博
 */
- (void)sendToSinaWeiBo {
    
    __weak typeof(self) weak_self = self;
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibo://"]]) {
//        [SVProgressHUD showErrorWithStatus:@"分享平台［新浪微博］尚未安装新浪微博客户端!无法进行分享!" duration:2.0f];
        return;
    }
    [shareParams SSDKEnableUseClientShare];
    
    if (self.shareType == shareTypeForWebPage) {
        
        [shareParams SSDKSetupSinaWeiboShareParamsByText:self.msgDescription
                                                   title:self.message
                                                   image:self.thumb
                                                     url:[NSURL URLWithString:self.webURL]
                                                latitude:0.0
                                               longitude:0.0
                                                objectID:nil
                                                    type:SSDKContentTypeWebPage];
    } else if (self.shareType == shareTypeForImage) {
        [shareParams SSDKSetupSinaWeiboShareParamsByText:self.msgDescription
                                                   title:self.message
                                                   image:self.thumb
                                                     url:[NSURL URLWithString:self.webURL]
                                                latitude:0.0
                                               longitude:0.0
                                                objectID:nil
                                                    type:SSDKContentTypeImage];
        
    } else if (self.shareType == shareTypeForVideo) {
//        [SVProgressHUD showErrorWithStatus:@"新浪微博无法分享该内容" duration:1.0f];
        return;

    } else {
        [shareParams SSDKSetupSinaWeiboShareParamsByText:self.msgDescription
                                                   title:self.message
                                                   image:self.thumb
                                                     url:[NSURL URLWithString:self.webURL]
                                                latitude:0.0
                                               longitude:0.0
                                                objectID:nil
                                                    type:SSDKContentTypeAuto];
    }
    [ShareSDK share:SSDKPlatformTypeSinaWeibo parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        [weak_self shareWhenCompleteWithState:state andError:error];
        NSLog(@"%@", error);
        
        if (weak_self.actionBlock) {
            weak_self.actionBlock(PTShareOptionSinaWeibo);
        }
    }];
}

-(void)copyWebLink{
    if (self.webURL) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.webURL;
        NSLog(@"链接已复制");
//        [SVProgressHUD showSuccessWithStatus:@"链接已复制" duration:2.0];
    }else{
//        [SVProgressHUD showErrorWithStatus:@"无效链接" duration:2.0];
    }
    
}
#pragma mark -

#pragma mark -- getters
-(UIButton *)dismissBackdrop{
    if (!_dismissBackdrop) {
        _dismissBackdrop = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _dismissBackdrop.backgroundColor = [[UIColor colorWithHexString:@"000000"] colorWithAlphaComponent:0.5];
        [_dismissBackdrop addTarget:self action:@selector(hide:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissBackdrop;
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.clipsToBounds = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

-(UIView *)dashboard{
    if (!_dashboard) {
        if (self.options.count<=4) {
            _dashboard = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, kShareTotalHeightSmall-kCancelButtonHeight-kSplitterHeight)];
        }else{
            _dashboard = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, kShareTotalHeight-kCancelButtonHeight-kSplitterHeight)];
        }
        _dashboard.backgroundColor = [UIColor whiteColor];
        _dashboard.layer.borderColor = [UIColor colorWithHexString:@"e1e1e1"].CGColor;
        _dashboard.layer.borderWidth = 0.5;
    }
    return _dashboard;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor colorWithHexString:@"959595"];
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

-(UIView *)splitterView{
    if (!_splitterView) {
        _splitterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, kSplitterHeight)];
        _splitterView.backgroundColor = [UIColor colorWithHexString:@"EBEBEB"];
    }
    return _splitterView;
}

-(UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.width, kCancelButtonHeight)];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor colorWithHexString:@"ed5564"] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _cancelButton.backgroundColor = [UIColor whiteColor];
        _cancelButton.layer.borderColor = [UIColor colorWithHexString:@"e1e1e1"].CGColor;
        _cancelButton.layer.borderWidth = 0.5;
        [_cancelButton addTarget:self action:@selector(hide:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}
#pragma mark -


@end
