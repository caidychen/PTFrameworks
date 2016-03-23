//
//  PTJsonUnitDemoVC.m
//  PTLib
//
//  Created by admin on 16/3/15.
//  Copyright © 2016年 putao. All rights reserved.
//

#import "PTJsonUnitDemoVC.h"
#import "PTJsonUnit.h"

@implementation PTJsonUnitDemoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *json = [PTJsonUnit jsonFromObject:@{@"aa": @"bb", @"cc": @"dd"}
                                       usingLib:PTJsonLibNative];
    id object = [PTJsonUnit objectFromJson:json
                                  usingLib:PTJsonLibNative];
    
    NSLog(@"%@",json);
    NSLog(@"%@",object);
    
    
    json = [PTJsonUnit jsonFromObject:@{@"aa": @"bb", @"cc": @"dd"}
                             usingLib:PTJsonLibJSONKit];
    object = [PTJsonUnit objectFromJson:json usingLib:PTJsonLibJSONKit];
    
    NSLog(@"%@",json);
    NSLog(@"%@",object);
}

@end
