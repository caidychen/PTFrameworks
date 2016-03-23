//
//  PTPayViewController.m
//  PTLib
//
//  Created by zhangyi on 16/3/15.
//  Copyright © 2016年 putao. All rights reserved.
//

#import "PTPayViewController.h"
#import "PTWXPayRequest.h"  // 微信支付
#import "WXApi.h"           //
#import "PTAlipayRequest.h" // 支付宝支付
#import "PTAlipayError.h"   // 支付宝返回enum

@interface PTPayViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation PTPayViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"支付";
        // 监听从微信支付返回的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WXPayCallBack:) name:@"PayRespCallBack" object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.tableView];
}

#pragma mark -- getters
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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"微信支付";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"支付宝支付";
    }
    
    return cell;
}
#pragma mark -

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [PTWXPayRequest payWithBaseUrl:@"http://api.store.test.putao.com/pay/mobile/toPay" orderId:@"804" uid:@"60000055" userToken:@"11e2e3a7526d42e19610ac1e22437ca7" success:^(PTWXPayCallBackItem *resultItem) {
            switch (resultItem.backType) {
                case callBackTypeForSuccess:{
//                    [SOAutoHideMessageView showMessage:@"等待支付" inView:weak_self.view];
                    NSLog(@"等待支付");
                } break;
                case callBackTypeForFailure:{
//                    [SOAutoHideMessageView showMessage:@"订单信息有误" inView:weak_self.view];
                } break;
                case callBackTypeForNoSupport:{
//                    [SOAutoHideMessageView showMessage:@"您的微信版本过低，不支持支付" inView:weak_self.view];
                } break;
                case callBackTypeForNoInstalled:{
//                    [SOAutoHideMessageView showMessage:@"您的手机未安装手机微信" inView:weak_self.view];
                } break;

                    
                default:
                    break;
            }
        } failure:^(NSError *error) {
            //支付失败
//            [SOAutoHideMessageView showMessage:@"支付失败,您的网络不给力" inView:weak_self.view];
        }];

    } else if (indexPath.row == 1) {
        //支付功能
        [PTAlipayRequest payWithBaseUrl:@"http://api.store.test.putao.com/pay/mobile/order" orderId:@"804" uid:@"60000055" userToken:@"11e2e3a7526d42e19610ac1e22437ca7" success:^(PTAlipayResultItem *resultItem) {
            
            NSInteger resultCode = [[resultItem resultStatus] integerValue];
            switch (resultCode) {
                case PTAlipayErrorCodePaySuccess:{

//                    [SOAutoHideMessageView showMessage:PTAlipayErrorCodeDescription(PTAlipayErrorCodePaySuccess) inView:weak_self.view];
//                    PTPaySuccessViewController *successOrderViewController = [[PTPaySuccessViewController alloc] init];
//                    successOrderViewController.orderID = self.orderItem.orderID;
//                    [self.navigationController pushViewController:successOrderViewController animated:YES];
                }break;
                case PTAlipayErrorCodePayInHand:{
//                    [SOAutoHideMessageView showMessage:PTAlipayErrorCodeDescription(PTAlipayErrorCodePayInHand) inView:weak_self.view];
                }break;
                case PTAlipayErrorCodePayFaile:{
//                    [SOAutoHideMessageView showMessage:PTAlipayErrorCodeDescription(PTAlipayErrorCodePayFaile) inView:weak_self.view];
                }break;
                case PTAlipayErrorCodePayCancel:{
//                    [SOAutoHideMessageView showMessage:PTAlipayErrorCodeDescription(PTAlipayErrorCodePayCancel) inView:weak_self.view];
                }break;
                case PTAlipayErrorCodeNetworkFaile:{
//                    [SOAutoHideMessageView showMessage:PTAlipayErrorCodeDescription(PTAlipayErrorCodeNetworkFaile) inView:weak_self.view];
                }break;
                default:
                break;
            }
        } failure:^(NSError *error) {
            //支付失败
//            [SOAutoHideMessageView showMessage:@"支付失败,您的网络不给力" inView:weak_self.view];
        }];
    }
}
#pragma mark -

#pragma mark -- method
- (void)WXPayCallBack:(NSNotification *)noti {
    
    PayResp *respone = [noti.userInfo objectForKey:@"info"];
    switch (respone.errCode) {
        case WXSuccess:{
//            [SOAutoHideMessageView showMessage:@"成功支付" inView:self.view];
//            PTPaySuccessViewController *successOrderViewController = [[PTPaySuccessViewController alloc] init];
//            successOrderViewController.orderID = self.orderItem.orderID;
//            [self.navigationController pushViewController:successOrderViewController animated:YES];
        }break;
        case WXErrCodeCommon:{
//            [SOAutoHideMessageView showMessage:@"支付失败" inView:self.view];
        }break;
        case WXErrCodeUserCancel:{
//            [SOAutoHideMessageView showMessage:@"用户取消支付" inView:self.view];
        }break;
            
        default:
            break;
    }
}
#pragma mark -

@end
