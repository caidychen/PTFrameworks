//
//  UIAlertViewCallBackViewController.m
//  PTLib
//
//  Created by CHEN KAIDI on 15/3/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import "UIAlertViewCallBackViewController.h"
#import "UIAlertView+Callback.h"

@implementation UIAlertViewCallBackViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Title" message:@"This is message" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alertView showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
        switch (buttonIndex) {
            case 0:
                NSLog(@"Cancel");
                break;
            case 1:
                NSLog(@"OK");
                break;
            default:
                break;
        }
    }];
}
@end
