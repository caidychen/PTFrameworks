//
//  PTWebViewViewController.h
//  PTLib
//
//  Created by zhangyi on 16/3/17.
//  Copyright © 2016年 putao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PTWebViewViewController;
@protocol PTWebViewViewControllerDelegate <NSObject>

@optional
- (void)webViewDidStartLoad:(nonnull PTWebViewViewController *)webView;
- (void)webViewDidFinishLoad:(nonnull PTWebViewViewController *)webView;
- (void)webView:(nonnull PTWebViewViewController *)webView didFailLoadWithError:(nullable NSError *)error;
@end

@interface PTWebViewViewController : UIViewController

@property (nonatomic, weak) id <PTWebViewViewControllerDelegate> delegate;

- (void)webViewRequestUrl:(nonnull NSString *)url;
- (void)webViewLoadHtmlStr:(nonnull NSString *)str baseUrl:(nonnull NSURL *)baseUrl;
- (void)webViewSetHeadView:(nullable UIView *)headView andFootView:(nullable UIView *)footView;

@end
