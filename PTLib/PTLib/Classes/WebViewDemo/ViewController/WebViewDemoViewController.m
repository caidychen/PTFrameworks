//
//  WebViewDemoViewController.m
//  PTLib
//
//  Created by zhangyi on 16/3/16.
//  Copyright © 2016年 putao. All rights reserved.
//

#import "WebViewDemoViewController.h"
#import "NSString+HTML.h"   // 把图片、视频适应尺寸，并添加点击事件

#import "PTWebViewViewController.h"


@interface WebViewDemoViewController ()<UIWebViewDelegate>

@end

@implementation WebViewDemoViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"WebViewData" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *htmlStr = [data stringObjectForKey:@"item"];
    NSString *comstr = [NSString replaceH5ImageWidthAndHeight:htmlStr];
    
    
    PTWebViewViewController *webViewController = [[PTWebViewViewController alloc] init];
    webViewController.view.frame = CGRectMake(0, 0, self.view.width, self.view.height);

//    [webViewController webViewRequestUrl:@"http://www.baidu.com"];
    [webViewController webViewLoadHtmlStr:comstr baseUrl:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
    [self addChildViewController:webViewController];
    [self.view addSubview:webViewController.view];
    [webViewController didMoveToParentViewController:self];
}

@end
