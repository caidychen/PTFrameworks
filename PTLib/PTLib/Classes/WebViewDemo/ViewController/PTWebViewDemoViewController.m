//
//  PTWebViewDemoViewController.m
//  PTLib
//
//  Created by zhangyi on 16/3/17.
//  Copyright © 2016年 putao. All rights reserved.
//

#import "PTWebViewDemoViewController.h"
#import "PTRequestWebView.h"
#import "NSString+HTML.h"

// 跳转到画廊
#import "PTPictureViewController.h"

@interface PTWebViewDemoViewController ()<PTRequestWebViewDelegate>

@property (nonatomic, strong) PTRequestWebView *webView;

@end

@implementation PTWebViewDemoViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"WebView Demo";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.webView];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"WebViewData" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *htmlStr = [data stringObjectForKey:@"item"];
    NSString *comstr = [NSString replaceH5ImageWidthAndHeight:htmlStr];
    
    
    [self.webView PTRequestWebViewLoadHtmlStr:comstr baseUrl:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
//    [self.webView PTRequestWebViewRequestUrl:@"http://www.baidu.com"];
}
#pragma mark -- getters
- (PTRequestWebView *)webView {
    if (!_webView) {
        _webView = [[PTRequestWebView alloc] initWithFrame:self.view.bounds];
        _webView.delegate = self;
    }
    return _webView;
}
#pragma mark -

#pragma mark -- PTRequestWebViewDelegate
- (void)PTRequestWebViewDelegate:(PTRequestWebView *)webView grapeStoneWithUrl:(NSString *)url {
    
}

- (void)PTRequestWebViewDelegate:(PTRequestWebView *)webView pictureActionWitData:(NSArray *)data clickIndex:(NSString *)index title:(NSString *)title {
    NSLog(@"%@", data);
    
    NSMutableArray <PTPictureItem *> *dataArr = [NSMutableArray array];
    for (NSDictionary *itemDic in data) {
        PTPictureItem *pictureItem = [PTPictureItem itemWithDict:itemDic];
        [dataArr addObject:pictureItem];
    }
    
    PTPictureViewController *pictureViewController = [[PTPictureViewController alloc] init];
    pictureViewController.clickIndex = [index integerValue];
    pictureViewController.picTitle = title;
    pictureViewController.dataArr = dataArr;
    [self.navigationController pushViewController:pictureViewController animated:YES];
}

- (void)PTRequestWebViewDelegate:(PTRequestWebView *)webView videoLoadingView:(BOOL)need {
    
}
#pragma mark -

@end
