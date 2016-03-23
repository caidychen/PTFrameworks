//
//  PTReachabilityDemoVC.m
//  PTLib
//
//  Created by admin on 16/3/14.
//  Copyright © 2016年 putao. All rights reserved.
//

#import "PTReachabilityDemoVC.h"
#import "PTReachability.h"

@interface PTReachabilityDemoVC ()

@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UILabel *label;

@end

@implementation PTReachabilityDemoVC

#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"ReachabilityDemo"
             color:UIColorFromRGB(0x313131)
              font:[UIFont systemFontOfSize:18.0f]
          selector:nil];
    
    [self.view addSubview:self.button];
    [self.view addSubview:self.label];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveReachabilityChanged:)
                                                 name:kPTReachabilityChangedNotification
                                               object:nil];
}

- (void)dealloc
{
    [PTSharedReachability finishAutoCheck];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kPTReachabilityChangedNotification
                                                  object:nil];
}

#pragma mark - observer and notification

- (void)receiveReachabilityChanged:(NSNotification *)notification
{
    NSLog(@"%@",notification.userInfo);
}

#pragma mark - event response

- (void)buttonTouchedAction:(id)sender
{
    [PTSharedReachability reachabilityWithBlock:^(PTReachabilityStatus status) {
        if (status == PTReachabilityStatusNotReachable) {
            self.label.text = @"no network connection";
            
        } else if (status == PTReachabilityStatusWiFi) {
            self.label.text = @"WiFi";
            
        } else if (status >= PTReachabilityStatus4G) {
            self.label.text = @"WWAN";
        }
    }];
    
//    调用这个方法开始自动检测网络，网络改变时会触发通知kPTReachabilityChangedNotification
    PTSharedReachability.autoCheckInterval = 6.0;
    [PTSharedReachability startAutoCheck];
}

#pragma mark - getters and setters

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.frame = CGRectMake(0, 150, CGRectGetWidth(self.view.bounds), 20);
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:16];
        _label.textColor = [UIColor blackColor];
    }
    return _label;
}

- (UIButton *)button
{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeSystem];
        _button.frame = CGRectMake(0, 0, 100, 35);
        _button.center = CGPointMake(CGRectGetMidX(self.view.bounds), 100);
        [_button setTitle:@"Click" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonTouchedAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

@end
