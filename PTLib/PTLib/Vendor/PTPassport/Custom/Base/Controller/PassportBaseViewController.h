//
//  PassportBaseViewController.h
//  PTLib
//
//  Created by LiLiLiu on 16/3/15.
//  Copyright © 2016年 putao. All rights reserved.
//

#import "PPTBaseViewController.h"
#import "PassportLoadingView.h"

@interface PassportBaseViewController : PPTBaseViewController{
    CGRect _keyboardBenginFrame;
    CGRect _keyboardEndFrame;
    NSTimeInterval _keyboardAnimationDuration;
    
    BOOL _needRefresh;
    PassportLoadingView *_ptLoadingView;                  // 小菊花loading
}

@property (assign, nonatomic, getter=isNeedRefresh) BOOL needRefresh;

@property (strong, nonatomic, readonly) PassportLoadingView *ptLoadingView;

- (UIButton *)showBackButtonItemAnimation:(BOOL)animation;
- (void)leftItemTouched:(id)sender;

//开始加载动画
- (void)startLoadAnimation;
//停止加载动画
- (void)stopLoadAnimation;

//返回手势
- (BOOL)isEnableBackGesture;
- (void)setEnableBackGesture:(BOOL)enableBackGesture;

- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;

@end
