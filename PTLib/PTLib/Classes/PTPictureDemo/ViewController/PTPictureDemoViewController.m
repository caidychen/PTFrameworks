//
//  PTPictureDemoViewController.m
//  PTLib
//
//  Created by zhangyi on 16/3/18.
//  Copyright © 2016年 putao. All rights reserved.
//

#import "PTPictureDemoViewController.h"
#import "PTPictureViewController.h"

@interface PTPictureDemoViewController ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation PTPictureDemoViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Picture Demo";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.button];
    
    self.button.frame = CGRectMake(100, 200, 200, 50);

}

#pragma mark -- getters
- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button addTarget:self action:@selector(pushToPictureVC) forControlEvents:UIControlEventTouchUpInside];
        [_button setTitle:@"跳转到图片展示" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _button.layer.borderWidth = 1;
        _button.layer.borderColor = [UIColor blueColor].CGColor;
        _button.layer.cornerRadius = 4;
    }
    return _button;
}
#pragma mark -

#pragma mark -- method
- (void)pushToPictureVC {
    NSMutableArray *data = [NSMutableArray arrayWithObjects:
                            @{@"src":@"http://weidu.file.dev.putaocloud.com/file/bddaf79ea7be0b86c18ed679a703669a730675b6.png", @"text":@"这个是图片的描述1这个是图片的描述1这个是图片的描述1这个是图片的描述1这个是图片的描述1这个是图片的描述1这个是图片的描述1这个是图片的描述1"},
                            @{@"src":@"http://weidu.file.dev.putaocloud.com/file/832c1e2a4afece2c280bf6bb4121424a170c0921.png", @"text":@"这个是图片的描述2这个是图片的描述2这个是图片的描述2这个是图片的描述2这个是图片的描述2这个是图片的描述2这个是图片的描述2这个是图片的描述2这个是图片的描述2这个是图片的描述2这个是图片的描述2"},
                            @{@"src":@"http://weidu.file.dev.putaocloud.com/file/9f1700a1d338dc578f9cb660d1f4a6d3b8320af4.png", @"text":@"这个是图片的描述3"},
                            @{@"src":@"http://weidu.file.dev.putaocloud.com/file/9f1700a1d338dc578f9cb660d1f4a6d3b8320af4.png", @"text":@"这个是图片的描述4"},
                            @{@"src":@"http://weidu.file.dev.putaocloud.com/file/356353c302bd4c192b7e643ed89d5beab2a87d84.png", @"text":@"这个是图片的描述5"},
                            @{@"src":@"http://weidu.file.dev.putaocloud.com/file/7971cb5717dd37752a883f4fd57068c2d778a719.png", @"text":@"这个是图片的描述6"},
                            @{@"src":@"http://weidu.file.dev.putaocloud.com/file/fc72a37143374cc68b883eaa79e908936a14ab55.png", @"text":@"这个是图片的描述7这个是图片的描述7这个是图片的描述7这个是图片的描述7这个是图片的描述7这个是图片的描述7这个是图片的描述7这个是图片的描述7这个是图片的描述7这个是图片的描述7这个是图片的描述7这个是图片的描述7这个是图片的描述7"},
                            @{@"src":@"http://weidu.file.dev.putaocloud.com/file/07bc39f1c59400ec018b1c8d8ed677e7f906704b.png", @"text":@"这个是图片的描述8这个是图片的描述8这个是图片的描述8这个是图片的描述8这个是图片的描述8这个是图片的描述8这个是图片的描述8这个是图片的描述8这个是图片的描述8这个是图片的描述8这个是图片的描述8这个是图片的描述8这个是图片的描述8这个是图片的描述8这个是图片的描述8这个是图片的描述8这个是图片的描述8这个是图片的描述8这个是图片的描述8这个是图片的描述8这个是图片的描述8这个是图片的描述8这个是图片的描述8"},
                            @{@"src":@"http://weidu.file.dev.putaocloud.com/file/c4830000df3f12cba8284ddee88d00647c6f884f.png", @"text":@"这个是图片的描述9这个是图片的描述9这个是图片的描述9这个是图片的描述9这个是图片的描述9"},
                            @{@"src":@"http://weidu.file.dev.putaocloud.com/file/914103b28386d04282616c888d27838d69d7b05b.png", @"text":@"这个是图片的描述10这个是图片的描述10"},
                            nil];
    
    
    NSMutableArray <PTPictureItem *> *dataArr = [NSMutableArray array];
    for (NSDictionary *itemDic in data) {
        PTPictureItem *pictureItem = [PTPictureItem itemWithDict:itemDic];
        [dataArr addObject:pictureItem];
    }
    
    PTPictureViewController *picVC = [[PTPictureViewController alloc] init];
    picVC.dataArr = dataArr;
    picVC.clickIndex = 0;
    picVC.picTitle = @"图片预览";
    [self.navigationController pushViewController:picVC animated:YES];
}
#pragma mark -

@end
