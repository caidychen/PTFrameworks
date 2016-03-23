//
//  PTDeviceInfoDemoVC.m
//  PTLib
//
//  Created by admin on 16/3/15.
//  Copyright © 2016年 putao. All rights reserved.
//

#import "PTDeviceInfoDemoVC.h"
#import "UIDevice+PTAdd.h"

@implementation PTDeviceInfoDemoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"system version : %f",[UIDevice systemVersion]);
    NSLog(@"isPad: %@",[UIDevice currentDevice].isPad ? @"yes" : @"no");
    NSLog(@"device name : %@",[UIDevice currentDevice].machineModelName);
    NSLog(@"ip address : %@",[UIDevice currentDevice].ipAddressWiFi);
}

@end
