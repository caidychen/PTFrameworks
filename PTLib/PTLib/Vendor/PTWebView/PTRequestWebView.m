//
//  PTRequestWebView.m
//  PTLib
//
//  Created by zhangyi on 16/3/17.
//  Copyright © 2016年 putao. All rights reserved.
//

#import "PTRequestWebView.h"
#import "JSONKit.h"

static NSString * PTWebViewSchemeBase           =       @"putao";
static NSString * PTWebViewActionString         =       @"viewPic";
static NSString * PTWebViewHideVideoLoading     =       @"hideVideoLoading";
static NSString * PTWebViewShowVideoLoading     =       @"showVideoLoading";
static NSString * PTWebViewToGrapeDetail        =       @"openWebview";

@interface PTRequestWebView ()<UIWebViewDelegate>

@end

@implementation PTRequestWebView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.webView];
    }
    return self;
}

#pragma mark -- getters
- (PTHeaderFooterWebView *)webView {
    if (!_webView) {
        _webView = [[PTHeaderFooterWebView alloc] initWithFrame:self.bounds];
        _webView.delegate = self;
    }
    return _webView;
}
#pragma mark -

#pragma mark -- method
- (void)PTRequestWebViewRequestUrl:(NSString *)url {
    NSURL *requestUrl = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl];
    [self.webView loadRequest:request];
}

- (void)PTRequestWebViewLoadHtmlStr:(NSString *)str baseUrl:(NSURL *)baseUrl {
    [self.webView loadHTMLString:str baseURL:baseUrl];
}

- (void)PTRequestWebViewSetHeadView:(UIView *)headView andFootView:(UIView *)footView {
    self.webView.headerView = headView;
    self.webView.footerView = footView;
}
#pragma mark -

#pragma mark -- UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = request.URL;
    NSString *scheme = url.scheme;
    NSString *absUrl = url.absoluteString;
    if (!scheme) {
        return YES;
    }
    if ([PTWebViewSchemeBase isEqualToString:scheme]) {
        [self getInfoFromUrl:absUrl];
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(PTRequestWebViewDidStartLoad:)]) {
        [self.delegate PTRequestWebViewDidStartLoad:self];
    }
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(PTRequestWebViewDidFinishLoad:)]) {
        [self.delegate PTRequestWebViewDidFinishLoad:self];
    }
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    if (self.delegate && [self.delegate respondsToSelector:@selector(PTRequestWebView:didFailLoadWithError:)]) {
        [self.delegate PTRequestWebView:self didFailLoadWithError:error];
    }
}
#pragma mark -

#pragma mark -- actions
- (void)getInfoFromUrl:(NSString *)absUrl {
    if ([@"" isEqualToString:absUrl]) {
        return;
    }
    NSURL *url = [NSURL URLWithString:absUrl];
    if (!url){
        NSLog(@"url不合法");
        return;
    }
    NSString *scheme = url.scheme;
    if (![PTWebViewSchemeBase isEqualToString:scheme]) {
        NSLog(@"不支持url");
        return;
    }
    
    
    NSString *hideLoading = [NSString stringWithFormat:@"%@://%@", PTWebViewSchemeBase, PTWebViewHideVideoLoading];
    NSString *showLoading = [NSString stringWithFormat:@"%@://%@", PTWebViewSchemeBase, PTWebViewShowVideoLoading];
    
    if ([hideLoading isEqualToString:absUrl]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(PTRequestWebViewDelegate:videoLoadingView:)]) {
            [self.delegate PTRequestWebViewDelegate:self videoLoadingView:NO];
        }
        return;
    }
    if ([showLoading isEqualToString:absUrl]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(PTRequestWebViewDelegate:videoLoadingView:)]) {
            [self.delegate PTRequestWebViewDelegate:self videoLoadingView:YES];
        }
        return;
    }
    
    
    NSDictionary *pictureDic = [self getWebViewJsonWithAbsUrl:absUrl baseUrl:PTWebViewSchemeBase actionString:PTWebViewActionString];
    
    if (pictureDic) {
        [self getPictureInfo:pictureDic];
    }
    
    NSDictionary *grapeStone = [self getWebViewJsonWithAbsUrl:absUrl baseUrl:PTWebViewSchemeBase actionString:PTWebViewToGrapeDetail];
    if (grapeStone) {
        [self getGrapeStoneInfo:grapeStone];
    }
    
    
}

- (NSDictionary *)getWebViewJsonWithAbsUrl:(NSString *)absUrl baseUrl:(NSString *)baseUrl actionString:(NSString *)actionString {
    
    NSString * decodeURLString = [absUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *preStr = [NSString stringWithFormat:@"%@://%@/", baseUrl, actionString];
    
    NSString *jsonStr = [decodeURLString stringByReplacingOccurrencesOfString:preStr withString:@""];
    
    NSDictionary *dic = [jsonStr objectFromJSONString];
    if (dic) {
        return (dic);
    } else {
        return nil;
    }
}

- (void)getPictureInfo:(NSDictionary *)dic {
    NSString *clickIndex = [dic safeStringForKey:@"clickIndex"];
    NSString *picTitle = [dic safeObjectForKey:@"title"];
    NSArray *picList = [dic safeObjectForKey:@"picList"];
    //        NSMutableArray *picItemArr = [NSMutableArray array];
    //        for (NSDictionary *itemDic in picList) {
    //            PTActivityDetailPictureItem *pictureItem = [PTActivityDetailPictureItem itemWithDict:itemDic];
    //            [picItemArr addObject:pictureItem];
    //        }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(PTRequestWebViewDelegate:pictureActionWitData:clickIndex:title:)]) {
        [self.delegate PTRequestWebViewDelegate:self pictureActionWitData:picList clickIndex:clickIndex title:picTitle];
    }
}

- (void)getGrapeStoneInfo:(NSDictionary *)dic {
    NSString *url = [dic safeObjectForKey:@"url"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(PTRequestWebViewDelegate:grapeStoneWithUrl:)]) {
        [self.delegate PTRequestWebViewDelegate:self grapeStoneWithUrl:url];
    }
}
#pragma mark -

@end
