//
//  JPushViewController.m
//  PTLib
//
//  Created by zhangyi on 16/3/15.
//  Copyright © 2016年 putao. All rights reserved.
//

#import "JPushViewController.h"
#import "JPUSHService.h"        // JPush

@interface JPushViewController ()

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UISwitch *switchButton;

@property (nonatomic, strong) UILabel *aliasLabel;
@property (nonatomic, strong) UILabel *debugLabel;

@end

@implementation JPushViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"JPush";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.button];
    [self.view addSubview:self.switchButton];
    [self.view addSubview:self.aliasLabel];
    [self.view addSubview:self.debugLabel];
    
    self.aliasLabel.frame = CGRectMake(20, 100, 150, 30);
    self.button.frame = CGRectMake(self.aliasLabel.right + 10, self.aliasLabel.origin.y, 100, 30);
    self.debugLabel.frame = CGRectMake(20, 150, 150, 30);
    self.switchButton.frame = CGRectMake(self.debugLabel.right + 10, self.debugLabel.origin.y, 100, 30);
}

#pragma mark -- getters
- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_button setTitle:@"设置别名" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        _button.frame = CGRectMake(0, 0, 100, 30);
    }
    return _button;
}

- (UISwitch *)switchButton {
    if (!_switchButton) {
        _switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        [_switchButton addTarget:self action:@selector(switchButtonClick:) forControlEvents:UIControlEventValueChanged];
        [_switchButton setOn:YES];
        
    }
    return _switchButton;
}

- (UILabel *)aliasLabel {
    if (!_aliasLabel) {
        _aliasLabel = [[UILabel alloc] init];
        [_aliasLabel setText:@"设置别名"];
    }
    return _aliasLabel;
}

- (UILabel *)debugLabel {
    if (!_debugLabel) {
        _debugLabel = [[UILabel alloc] init];
        [_debugLabel setText:@"打开JPush日志"];
    }
    return _debugLabel;
}
#pragma mark -


#pragma mark -- Actions
- (void)buttonClick:(UIButton *)button {
    [self updateTokenToJPush];
}

- (void)switchButtonClick:(UISwitch *)button {
    if (button.on) {
        [JPUSHService setDebugMode];    // 打开Jpush日志
        NSLog(@"打开Jpush日志");
    } else {
        [JPUSHService setLogOFF];       // 关闭Jpush日志
        NSLog(@"关闭Jpush日志");
    }
}
#pragma mark -

#pragma mark -- JPush
-(void)updateTokenToJPush {
    [JPUSHService setAlias:@"这个是别名"
          callbackSelector:@selector(tagsAliasCallback:tags:alias:)
                    object:self];
    [JPUSHService registrationID];
    NSLog(@"设置别名");
}
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}
#pragma mark -
@end
