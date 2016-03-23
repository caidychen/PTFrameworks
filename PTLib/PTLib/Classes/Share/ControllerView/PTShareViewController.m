//
//  PTShareViewController.m
//  PTLib
//
//  Created by zhangyi on 16/3/14.
//  Copyright © 2016年 putao. All rights reserved.
//

#import "PTShareViewController.h"
#import "PTShareItem.h"
#import "PTShareView.h"     // 直接画出UI，传参数和设置分享平台

@interface PTShareViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) PTShareItem *item;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation PTShareViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"shareSDK 分享";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];

}

#pragma mark -- getters
- (PTShareItem *)item {
    if (!_item) {
        _item = [[PTShareItem alloc] init];
        _item.title = @"分享给好友";
        _item.shareTitle = @"这是分享的title";
        _item.shareDescription = @"这个是分享的描述 description";
        _item.webUrl = @"https://www.baidu.com/";
        _item.shareImage = [UIImage imageNamed:@"icon_40_01"];
        _item.thumbImage = [UIImage imageNamed:@"icon_40_01"];
    }
    return _item;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}
#pragma mark -

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"webUrl分享";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"image分享";
    } else {
        cell.textLabel.text = @"视频分享";
    }
    return cell;
}
#pragma mark -

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:{
            [PTShareView showOptionsWithTitle:self.item.title
                                   thumbImage:self.item.thumbImage
                                       webURL:self.item.webUrl
                                      message:self.item.shareTitle
                                  description:self.item.shareDescription
                                         type:shareTypeForWebPage
                                      options:@[PTShareOptionWechatFriends,PTShareOptionWechatNewsFeed,PTShareOptionQQFriends,PTShareOptionQQZone,PTShareOptionSinaWeibo,PTShareOptionWebLink]
                                  actionBlock:^(NSString *option) {
                                      
                                  }];
        } break;
        case 1:{
            [PTShareView showOptionsWithTitle:self.item.title
                                   thumbImage:self.item.thumbImage
                                       webURL:self.item.webUrl
                                      message:self.item.shareTitle
                                  description:self.item.shareDescription
                                         type:shareTypeForWebPage
                                      options:@[PTShareOptionWechatFriends,PTShareOptionWechatNewsFeed,PTShareOptionQQFriends,PTShareOptionQQZone,PTShareOptionSinaWeibo,PTShareOptionWebLink]
                                  actionBlock:^(NSString *option) {
                                      
                                  }];
        
        } break;
        case 2:{
        
        } break;
            
        default:
            break;
    }
}
#pragma mark -

@end
