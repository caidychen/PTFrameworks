//
//  PTWebViewViewController.m
//  PTLib
//
//  Created by zhangyi on 16/3/17.
//  Copyright © 2016年 putao. All rights reserved.
//

#import "PTWebViewViewController.h"
#import "PTHeaderFooterWebView.h"

@interface PTWebViewViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) PTHeaderFooterWebView *webView;

@end

@implementation PTWebViewViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.webView];
}

#pragma mark -- getters
- (PTHeaderFooterWebView *)webView {
    if (!_webView) {
        _webView = [[PTHeaderFooterWebView alloc] initWithFrame:self.view.bounds];
        _webView.delegate = self;
    }
    return _webView;
}
#pragma mark -

#pragma mark -- method
- (void)webViewRequestUrl:(NSString *)url {
    NSURL *requestUrl = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl];
    [self.webView loadRequest:request];
}

- (void)webViewLoadHtmlStr:(NSString *)str baseUrl:(NSURL *)baseUrl {
    [self.webView loadHTMLString:str baseURL:baseUrl];
}

- (void)webViewSetHeadView:(UIView *)headView andFootView:(UIView *)footView{
    self.webView.headerView = headView;
    self.webView.footerView = footView;
}
#pragma mark -

#pragma mark -- UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.delegate webViewDidStartLoad:self];
    }
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.delegate webViewDidFinishLoad:self];
    }
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    if (self.delegate && [self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.delegate webView:self didFailLoadWithError:error];
    }
}
#pragma mark -

@end
