//
//  PTLogDemoViewController.m
//  PTLib
//
//  Created by CHEN KAIDI on 15/3/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import "PTLogDemoViewController.h"
#import "PTLog.h"
@implementation PTLogDemoViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"Test Log A");
    NSLog(@"Test Log B");
    NSLog(@"Test Log C");
    
    NSLogWrite(@"Write Log 1");
    NSLogWrite(@"Write Log 2");
    NSLogWrite(@"Write Log 3");
    
    [PTLogManager print];
}

@end
