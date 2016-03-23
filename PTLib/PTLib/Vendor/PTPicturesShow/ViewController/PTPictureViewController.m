//
//  PTPictureViewController.m
//  PTLib
//
//  Created by zhangyi on 16/3/18.
//  Copyright © 2016年 putao. All rights reserved.
//

#import "PTPictureViewController.h"
#import "PTPictureCell.h"
#import "PTPictureDescribeView.h"
#import "PTShareView.h" // 分享

#import "UIImageView+WebCache.h"  
#import "AssetHelper.h"

static NSString *pictureReuseCell = @"pictureReuseCell";
static CGFloat rightButtonWidthHeight = 40;

@interface PTPictureViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PTPictureCellDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) PTPictureItem *currentPictureItem;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, assign) BOOL isShowStatus; // 记录点击状态 YES:show状态栏和文字NO:hiden状态栏和文字
@property (nonatomic, strong) PTPictureDescribeView *describeView;
@property (nonatomic, strong) UIActionSheet *saveActionSheet;

@end

@implementation PTPictureViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataArr = [NSMutableArray array];
        _currentPictureItem = [[PTPictureItem alloc] init];
        _isShowStatus = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self disableAdjustsScrollView];
    
    // 分享按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    self.navigationItem.rightBarButtonItem = rightButton;
    // 返回按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    
    self.collectionView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.clickIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    self.currentPictureItem = [self.dataArr safeObjectAtIndex:self.clickIndex];
    
    // 给描述赋值
    CGFloat height = [PTPictureDescribeView getHeightWithStr:self.currentPictureItem.picText];
    [self.describeView setValuesForViewWithStr:self.currentPictureItem.picText];
    self.describeView.frame = CGRectMake(0, self.view.height - height, self.view.width, height);
    [self.view addSubview:self.describeView];
    
    // 长按手势
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapScroll:)];
    longGesture.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:longGesture];
    
    [self scrollViewDidScroll:self.collectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:[[UIColor blackColor] colorWithAlphaComponent:0.5f]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

#pragma mark -- getters
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.itemSize = self.view.size;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal; // 横向翻页
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _collectionView.pagingEnabled = YES;
        //        _collectionView.contentInset = UIEdgeInsetsZero;
        //        _collectionView.alwaysBounceVertical = YES;
        _collectionView.alwaysBounceHorizontal = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColorFromRGB(0xebebeb);
        [_collectionView registerClass:[PTPictureCell class] forCellWithReuseIdentifier:pictureReuseCell];
    }
    return _collectionView;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_rightButton setImage:[UIImage imageNamed:@"btn_20_share_w_nor"] forState:UIControlStateNormal];
        [_rightButton setImage:[UIImage imageNamed:@"btn_20_share_w_sel"] forState:UIControlStateHighlighted];
        _rightButton.imageEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 0);
        
        _rightButton.size = CGSizeMake(rightButtonWidthHeight, rightButtonWidthHeight);
    }
    return _rightButton;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_leftButton setImage:[UIImage imageNamed:@"btn_20_back_w_nor"] forState:UIControlStateNormal];
        [_leftButton setImage:[UIImage imageNamed:@"btn_20_back_w_sel"] forState:UIControlStateHighlighted];
        _leftButton.size = CGSizeMake(rightButtonWidthHeight, rightButtonWidthHeight);
        _leftButton.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 20);
    }
    return _leftButton;
}

- (PTPictureDescribeView *)describeView {
    if (!_describeView) {
        _describeView = [[PTPictureDescribeView alloc] init];
    }
    return _describeView;
}
#pragma mark -

#pragma mark -- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PTPictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:pictureReuseCell forIndexPath:indexPath];
    cell.delegate = self;
    PTPictureItem *item = [self.dataArr safeObjectAtIndex: indexPath.row];
    [cell setValuesForCellItemWithItem:item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.collectionView != collectionView) {
        return;
    }
}
#pragma mark -

#pragma mark -- <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
        CGFloat offset = scrollView.contentOffset.x / self.view.width;
        if (offset < 0) {
            // 不显示0
            offset = 0;
        }
        NSString *titleStr = [NSString stringWithFormat:@"%ld/%ld", (long)(offset + 1.0), (long)self.dataArr.count];
        self.title = titleStr;
        [self setTitle:titleStr color:UIColorFromRGB(0xffffff) font:[UIFont systemFontOfSize:16] selector:nil];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
        CGFloat offset = scrollView.contentOffset.x / self.view.width;
        NSString *titleStr = [NSString stringWithFormat:@"%ld/%ld", (long)(offset + 1.0), (long)self.dataArr.count];
        self.title = titleStr;
        self.currentPictureItem = [self.dataArr safeObjectAtIndex:(long)offset];
        CGFloat height = [PTPictureDescribeView getHeightWithStr:self.currentPictureItem.picText];
        [self.describeView setValuesForViewWithStr:self.currentPictureItem.picText];
        self.describeView.height = height;
        [self changeDescribeView];
    }
}
#pragma mark -

#pragma mark -- PTCellDelegate
- (void)PTPictureCellDelegate:(PTPictureCell *)cell withPictureItem:(PTPictureItem *)pictureItem {
    if (self.isShowStatus) {
        [self hidenStatus];
        self.isShowStatus = NO;
    } else {
        [self showStatus];
        self.isShowStatus = YES;
    }
}
#pragma mark -

#pragma mark -- action
- (void)rightButtonClick {
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:self.currentPictureItem.picUrl] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if(!image) {
            image = [UIImage imageNamed:@"icon_114"];
        }
//        [PTShareView showOptionsWithTitle:@"分享给好友"
//                               thumbImage:image
//                                   webURL:nil
//                                  message:nil
//                              description:nil
//                                     type:shareTypeForImage
//                                  options:@[PTShareOptionWechatFriends,PTShareOptionWechatNewsFeed,PTShareOptionQQFriends,PTShareOptionSinaWeibo]];
    }];
}

- (void)leftButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)longTapScroll:(UILongPressGestureRecognizer *)gesture {
    if(gesture.state != UIGestureRecognizerStateBegan) {
        return;
    }
    UIActionSheet *saveImageActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存图片" otherButtonTitles:nil];
    [saveImageActionSheet showInView:self.view];
}
#pragma mark -



#pragma mark -- Method
- (void)hidenStatus {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:_keyboardAnimationDuration];
    
    CGFloat height = [PTPictureDescribeView getHeightWithStr:self.currentPictureItem.picText];
    self.describeView.frame = CGRectMake(0, self.view.height, self.view.width, height);
    [UIView commitAnimations];
}

- (void)showStatus {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:_keyboardAnimationDuration];
    CGFloat height = [PTPictureDescribeView getHeightWithStr:self.currentPictureItem.picText];
    self.describeView.frame = CGRectMake(0, self.view.height - height, self.view.width, height);
    [UIView commitAnimations];
    
}

- (void)changeDescribeView {
    if (self.isShowStatus) {
        [self showStatus];
    } else {
        [self hidenStatus];
    }
}
#pragma mark -

#pragma mark - <UIActionSheetDelegate>
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex != 0) {
        return;
    }
    PTPictureItem *picItem = self.currentPictureItem;
    if(!picItem || ![picItem isKindOfClass:[PTPictureItem class]]) {
        [actionSheet dismissWithClickedButtonIndex:1 animated:YES];
        //        [SVProgressHUD showErrorWithStatus:@"保存失败"];
        NSLog(@"保存失败");
        return;
    }
    NSString *imageURLString = picItem.picUrl;
    if(!imageURLString || imageURLString.length == 0) {
        [actionSheet dismissWithClickedButtonIndex:1 animated:YES];
        //        [SVProgressHUD showErrorWithStatus:@"保存失败"];
        NSLog(@"保存失败");
        return;
    }
    
    __weak typeof(actionSheet) weak_actionSheet = actionSheet;
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:imageURLString] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        [weak_actionSheet dismissWithClickedButtonIndex:1 animated:YES];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if(!finished || !image) {
            [weak_actionSheet dismissWithClickedButtonIndex:1 animated:YES];
            //            [SVProgressHUD showErrorWithStatus:@"保存失败"];
            NSLog(@"保存失败");
            return;
        }
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
        if(!imageData || imageData.length == 0) {
            [weak_actionSheet dismissWithClickedButtonIndex:1 animated:YES];
            //            [SVProgressHUD showErrorWithStatus:@"保存失败"];
            NSLog(@"保存失败");
            return;
        }
        //  保存图片
        [[AssetHelper sharedAssetHelper] saveToAlbumWithMetadata:nil imageData:imageData customAlbumName:@"葡萄纬度" completionBlock:^{
            [weak_actionSheet dismissWithClickedButtonIndex:1 animated:YES];
//            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            NSLog(@"保存成功");
        } failureBlock:^(NSError *error) {
            [weak_actionSheet dismissWithClickedButtonIndex:1 animated:YES];
//            [SVProgressHUD showErrorWithStatus:@"保存失败"];
            NSLog(@"保存失败");
        }];
    }];
}
#pragma mark -

@end
