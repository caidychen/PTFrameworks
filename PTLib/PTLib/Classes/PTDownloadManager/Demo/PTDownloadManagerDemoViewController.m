//
//  PTDownloadManagerDemoViewController.m
//  PTLib
//
//  Created by CHEN KAIDI on 16/3/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import "PTDownloadManagerDemoViewController.h"
#import "PTDownloadManager.h"
#import "PTFileManager.h"

@interface PTDownloadManagerDemoViewController ()
@property (nonatomic, strong) UIButton *button;
@end

@implementation PTDownloadManagerDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.button = [[UIButton alloc] initWithFrame:self.view.bounds];
    [self.button setTitle:@"Start download" forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(initiateDownload) forControlEvents:UIControlEventTouchUpInside];
    [self.button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.view addSubview:self.button];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadDidFinishLoading:) name:kDownloadDidFinishLoading object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadDidReceiveData:) name:kDownloadDidReceiveData object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadDidFail:) name:kDownloadDidFail object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDownloadDidFinishLoading object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDownloadDidFail object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDownloadDidReceiveData object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initiateDownload{
    self.button.enabled = NO;
    NSString *sourceURL = @"http://camera.file.dev.putaocloud.com/file/ab5b09cdfd46bb0a79c21d8e4118eb2ce19159cd.zip";
    NSString *fileName = [[PTFileManager getRootFolderPathForSearchPathDirectory:NSLibraryDirectory] stringByAppendingPathComponent:[sourceURL lastPathComponent]];
    [[PTDownloadManager shareManager] addDownloadWithFilename:fileName URL:[NSURL URLWithString:sourceURL] item:nil];
}

- (void)downloadDidFinishLoading:(NSNotification *)notification{
    PTDownload *download = notification.object;
    NSLog(@"download complete:%@",download.url);
    self.button.enabled = YES;
}

- (void)downloadDidFail:(NSNotification *)notification{
    NSLog(@"download failed");
    self.button.enabled = YES;
}

- (void)downloadDidReceiveData:(NSNotification *)notification{
    PTDownload *download = notification.object;
    NSLog(@"downloading...%.0f%%",100*(float)download.progressContentLength/(float)download.expectedContentLength);
}

@end
