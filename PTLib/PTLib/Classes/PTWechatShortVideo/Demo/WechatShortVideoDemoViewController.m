//
//  WechatShortVideoDemoViewController.m
//  PTLib
//
//  Created by CHEN KAIDI on 17/3/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import "WechatShortVideoDemoViewController.h"
#import "WechatShortVideoController.h"
#import <AVFoundation/AVFoundation.h>

@interface WechatShortVideoDemoViewController ()<WechatShortVideoDelegate>
@property (nonatomic, strong) UIButton *shootVideoButton;
@property (nonatomic, strong) AVPlayer *avPlayer;
@property (nonatomic, strong) AVPlayerLayer *avPlayerLayer;
@property (nonatomic, strong) UIView *contentView;
@end

@implementation WechatShortVideoDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.shootVideoButton = [[UIButton alloc] initWithFrame:self.view.bounds];
    [self.shootVideoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.shootVideoButton setTitle:@"Shoot video" forState:UIControlStateNormal];
    [self.shootVideoButton addTarget:self action:@selector(toggleShootVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.shootVideoButton];
}

-(void)toggleShootVideo{
    WechatShortVideoController *wechatVC = [[WechatShortVideoController alloc] initWithNibName:@"WechatShortVideoController" bundle:nil];
    wechatVC.delegate = self;
    [self presentViewController:wechatVC animated:YES completion:^{
        
    }];
}

-(void)wechatVC:(WechatShortVideoController *)wechatVC finishWechatShortVideoCapture:(NSURL *)filePath{
    [self playbackVideoWithFilePath:filePath];
}

-(void)playbackVideoWithFilePath:(NSURL *)videoURL{
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width/(480.f/320.f))];
    [self.view addSubview:self.contentView];
    self.avPlayer = [AVPlayer playerWithURL:videoURL];
    self.avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    self.avPlayerLayer.frame = self.contentView.layer.bounds;
    [self.contentView.layer addSublayer: self.avPlayerLayer];
    self.avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.avPlayer currentItem]];
    [self.avPlayer play];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}


@end
