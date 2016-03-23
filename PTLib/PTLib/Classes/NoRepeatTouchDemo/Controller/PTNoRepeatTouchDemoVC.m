//
//  PTNoRepeatTouchDemoVC.m
//  PTLib
//
//  Created by admin on 16/3/15.
//  Copyright © 2016年 putao. All rights reserved.
//

#import "PTNoRepeatTouchDemoVC.h"
#import "UIControl+PTNoRepeat.h"
#import "UITapGestureRecognizer+PTNoRepeat.h"

@interface PTNoRepeatTouchDemoVC ()

@end

@implementation PTNoRepeatTouchDemoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    tap.pt_NoRepeatInterval = 2.0;
    [tap addTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 100, 40);
    button.center = CGPointMake(CGRectGetMidX(self.view.bounds), 150);
    button.pt_NoRepeatInterval = 3.0;
    button.pt_disabledWhenIntime = YES;
    [button setTitle:@"Click" forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(btnAction:)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)tapAction:(id)sender
{
    NSLog(@"view tap !!!!");
}

- (void)btnAction:(id)sender
{
    NSLog(@"button touch ????");
}

@end
