//
//  NSStringDemoViewController.m
//  PTLib
//
//  Created by zhangyi on 16/3/16.
//  Copyright © 2016年 putao. All rights reserved.
//

#import "NSStringDemoViewController.h"
#import "NSString+HTML.h"
#import "NSString+JSONCatrgory.h"
#import "NSString+OAURLEncodingAdditions.h"
#import "NSString+PTJSON.h"
#import "NSString+Time.h"
#import "NSString+URL.h"

@interface NSStringDemoViewController ()


@end

@implementation NSStringDemoViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"NSStringDemo";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *preStr = @"这个是使用前的string";
    NSString *htmlString = [NSString replaceH5ImageWidthAndHeight:preStr];  // 放入webview中使用，loadstring方法
    
    NSString *jsonString = [preStr JSONObj];

    NSString *encodeStr = [preStr URLEncodedToString];
    NSString *decodeStr = [preStr URLDecodedString];
    
    NSString *ptJsonStr = [NSString JSONStringWithJSONObj:@{@"aa": @"bb", @"cc": @"dd"}];

    NSString *timeStr = [NSString countTimeTransfoWithString:preStr];
    
    NSString *urlStr = [preStr URLEncodedString];

    NSLog(@"%@--%@--%@--%@--%@--%@--%@--%@",preStr, htmlString, jsonString, encodeStr, decodeStr, ptJsonStr, timeStr, urlStr);
}



@end
