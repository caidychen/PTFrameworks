//
//  ViewController.m
//  PTLib
//
//  Created by LiLiLiu on 16/3/11.
//  Copyright © 2016年 putao. All rights reserved.
//

#import "ViewController.h"

//Model
#import "DemoPalette.h"
#import "DemoSectionItem.h"
#import "DemoSectionRowItem.h"

//View
#import "ViewControllerTableViewCell.h"

//Controller
#import "PTPassportDemoVC.h"
#import "PTReachabilityDemoVC.h"
#import "PTNoRepeatTouchDemoVC.h"
#import "PTDeviceInfoDemoVC.h"
#import "PTJsonUnitDemoVC.h"
#import "PTShareViewController.h"   // 分享demo
#import "PTPayViewController.h"     // 支付demo
#import "JPushViewController.h"     // JPush demo
#import "NSStringDemoViewController.h"  // string demo
#import "WebViewDemoViewController.h"   // webView demo
#import "PTWebViewDemoViewController.h" //
#import "PTPictureDemoViewController.h" // 画廊 demo

#import "PTDownloadManagerDemoViewController.h"
#import "WechatShortVideoDemoViewController.h"
#import "UIAlertViewCallBackViewController.h"
#import "PTLogDemoViewController.h"
#import "PTMacro.h"



static NSString * const ViewControllerCellIdentifier = @"ViewControllerCellIdentifier";


@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tableDatasource;

@end

@implementation ViewController
@synthesize tableView = _tableView;
@synthesize tableDatasource = _tableDatasource;


- (void)dealloc {
    SORELEASE(_tableView);
    SORELEASE(_tableDatasource);
    SOSUPERDEALLOC();
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        _tableView = nil;
        _tableDatasource = [[DemoPalette sharedPalette] sections];
    }
    
    return (self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"葡萄Lib" color:UIColorFromRGB(0x313131) font:[UIFont systemFontOfSize:18.0f] selector:nil];
    
    [self.view addSubview:self.tableView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}


#pragma mark - getter
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        UIEdgeInsets contentInsets = _tableView.contentInset;
        contentInsets.bottom = HEIGHT_BAR;
        _tableView.contentInset = contentInsets;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView = nil;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.separatorColor = [UIColor clearColor];
        [_tableView registerClass:[ViewControllerTableViewCell class] forCellReuseIdentifier:ViewControllerCellIdentifier];
       
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableView clearExtendCellLine];
    }
    return (_tableView);
}
#pragma mark -

#pragma mark - setter
#pragma mark -

#pragma mark - action
- (void)jumpToViewControllerWithItem:(DemoSectionRowItem *)item{
    
    NSInteger demoIDInt = [item.demoID integerValue];
    
    switch (demoIDInt) {
        case 1:{
            PTPassportDemoVC *passportDemo = [[PTPassportDemoVC alloc] init];
            [self.navigationController pushViewController:passportDemo animated:YES];
        }break;
        case 2:{
            JPushViewController *JPushDemo = [[JPushViewController alloc] init];
            [self.navigationController pushViewController:JPushDemo animated:YES];
        }break;
        case 3:{
            PTShareViewController *shareDemo = [[PTShareViewController alloc] init];
            [self.navigationController pushViewController:shareDemo animated:YES];
        }break;
        case 4:{}break;
        case 5:{}break;
        case 7:{
            PTPayViewController *payDemo = [[PTPayViewController alloc] init];
            [self.navigationController pushViewController:payDemo animated:YES];
        } break;
        case 100:{
            UIAlertViewCallBackViewController *alertDemo = [[UIAlertViewCallBackViewController alloc] init];
            [self.navigationController pushViewController:alertDemo animated:YES];
        }break;
            
        case 102:{
            PTWebViewDemoViewController *webViewDemo = [[PTWebViewDemoViewController alloc] init];
            [self.navigationController pushViewController:webViewDemo animated:YES];
        }break;
        case 106: {
            PTPictureDemoViewController *pictureDemo = [[PTPictureDemoViewController alloc] init];
            [self.navigationController pushViewController:pictureDemo animated:YES];
        } break;
            
        case 107:{
            PTNoRepeatTouchDemoVC *noRepeatDemo = [[PTNoRepeatTouchDemoVC alloc] init];
            [self.navigationController pushViewController:noRepeatDemo animated:YES];
        }break;
        case 200:{
            NSStringDemoViewController *stringDemo = [[NSStringDemoViewController alloc] init];
            [self.navigationController pushViewController:stringDemo animated:YES];
        }break;
        case 202:{
            PTJsonUnitDemoVC *jsonDemo = [[PTJsonUnitDemoVC alloc] init];
            [self.navigationController pushViewController:jsonDemo animated:YES];
        }break;
        case 203:{
            PTLogDemoViewController *logDemo = [[PTLogDemoViewController alloc] init];
            [self.navigationController pushViewController:logDemo animated:YES];
        }break;
        case 208:{
            PTDownloadManagerDemoViewController *downloadDemo = [[PTDownloadManagerDemoViewController alloc] init];
            [self.navigationController pushViewController:downloadDemo animated:YES];
        }break;
        case 209:{
            PTDeviceInfoDemoVC *deviceInfoDemo = [[PTDeviceInfoDemoVC alloc] init];
            [self.navigationController pushViewController:deviceInfoDemo animated:YES];
        }break;
        case 210:{
            PTReachabilityDemoVC *reachabilityDemo = [[PTReachabilityDemoVC alloc] init];
            [self.navigationController pushViewController:reachabilityDemo animated:YES];
        }break;
        case 307:{
            WechatShortVideoDemoViewController *wechatDemoVC = [[WechatShortVideoDemoViewController alloc] init];
            [self.navigationController pushViewController:wechatDemoVC animated:YES];
        }break;
        default:
            break;
    }
}
#pragma mark -


#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.tableDatasource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    DemoSectionItem *sectionItem = (DemoSectionItem *)[self.tableDatasource objectAtIndex:section];
    return (sectionItem.rows.count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    DemoSectionItem *sectionItem = (DemoSectionItem *)[self.tableDatasource objectAtIndex:section];
    DemoSectionRowItem *rowItem = (DemoSectionRowItem *)[sectionItem.rows objectAtIndex:row];
    
    ViewControllerTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ViewControllerCellIdentifier];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.item = rowItem;
    
    __weak typeof(self) weak_self = self;
    cell.actionBlock = ^(DemoSectionRowItem *item){
        [weak_self jumpToViewControllerWithItem:item];
    };
    
    
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    DemoSectionItem *sectionItem = (DemoSectionItem *)[self.tableDatasource objectAtIndex:section];
    return sectionItem.sectionName;
}

#pragma mark -


#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return (25.0f);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ViewControllerTableViewCell getCellHeight];
}
#pragma mark - 



#pragma mark - <SOViewControllerProtocol>
- (void)setParameters:(id)parameters {
    [super setParameters:parameters];
    
}
#pragma mark -



@end
