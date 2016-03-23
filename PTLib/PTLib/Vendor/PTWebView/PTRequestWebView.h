//
//  PTRequestWebView.h
//  PTLib
//
//  Created by zhangyi on 16/3/17.
//  Copyright © 2016年 putao. All rights reserved.
//

#import "SOBaseView.h"
#import "PTHeaderFooterWebView.h"

@class PTRequestWebView;
@protocol PTRequestWebViewDelegate <NSObject>

@required
/**
 *  @brief  跳转到画廊
 */
- (void)PTRequestWebViewDelegate:(PTRequestWebView *)webView pictureActionWitData:(NSArray *)data clickIndex:(NSString *)index title:(NSString *)title;
/**
 *  @brief  跳转到葡萄籽
 */
- (void)PTRequestWebViewDelegate:(PTRequestWebView *)webView grapeStoneWithUrl:(NSString *)url;
/**
 *  @brief  视频加载是否需要loading
 */
- (void)PTRequestWebViewDelegate:(PTRequestWebView *)webView videoLoadingView:(BOOL)need;

@optional
/**
 *  @brief  webView返回的同名delegate
 */
- (void)PTRequestWebViewDidStartLoad:(PTRequestWebView *)webView;
/**
 *  @brief  webView返回的同名delegate
 */
- (void)PTRequestWebViewDidFinishLoad:(PTRequestWebView *)webView;
/**
 *  @brief  webView返回的同名delegate
 */
- (void)PTRequestWebView:(PTRequestWebView *)webView didFailLoadWithError:(NSError *)error;

@end

@interface PTRequestWebView : SOBaseView

/**
 *  @brief  webView,可以设置UIWebViewDelegate
 */
@property (nonatomic, strong) PTHeaderFooterWebView *webView;

/**
 *  @brief  设置webview加载的网址
 */
@property (nonatomic, weak) id <PTRequestWebViewDelegate> delegate;

/**
 *  @brief  设置webview加载的网址
 */
- (void)PTRequestWebViewRequestUrl:(NSString *)url;
/**
 *  @brief  设置webview加载的HTMLStr,转好的str，和baseUrl
 */
- (void)PTRequestWebViewLoadHtmlStr:(NSString *)str baseUrl:(NSURL *)baseUrl;
/**
 *  @brief  设置webview ，header和footer的View
 */
- (void)PTRequestWebViewSetHeadView:(UIView *)headView andFootView:(UIView *)footView;

@end
