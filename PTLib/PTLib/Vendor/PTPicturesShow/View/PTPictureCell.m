//
//  PTPictureCell.m
//  PTLib
//
//  Created by zhangyi on 16/3/18.
//  Copyright © 2016年 putao. All rights reserved.
//

#import "PTPictureCell.h"
#import "UIImageView+WebCache.h"

void scrollViewDidZoom(UIScrollView *scrollView, UIImageView *imageView) {
    
    if(!scrollView || !imageView || !imageView.image) {
        return;
    }
    
    CGFloat scrollViewWidthHeightOffset = CGRectGetWidth(scrollView.bounds) / CGRectGetHeight(scrollView.bounds);
    CGFloat imageWidthHeightOffset = imageView.image.size.width / imageView.image.size.height;
    if(isnan(scrollViewWidthHeightOffset) || isnan(imageWidthHeightOffset)) {
        return;
    }
    
    CGSize scrollSize = scrollView.bounds.size;
    
    if(imageWidthHeightOffset > scrollViewWidthHeightOffset) {
        CGFloat width = MIN(CGRectGetWidth(scrollView.bounds), imageView.image.size.width) * scrollView.zoomScale;
        CGSize imageScaleSize = CGSizeMake(width, width / imageWidthHeightOffset);
        
        CGSize contentSize = imageScaleSize;
        contentSize = CGSizeMake(MAX(scrollSize.width, contentSize.width), MAX(scrollSize.height, contentSize.height));
        scrollView.contentSize = contentSize;
        
        imageView.frame = CGRectMake((contentSize.width - imageScaleSize.width) * 0.5f, (contentSize.height - imageScaleSize.height) * 0.5f, imageScaleSize.width, imageScaleSize.height);
        
        return;
    }
    
    if(imageWidthHeightOffset < scrollViewWidthHeightOffset) {
        CGFloat height = MIN(CGRectGetHeight(scrollView.bounds), imageView.image.size.height) * scrollView.zoomScale;
        CGSize imageScaleSize = CGSizeMake(height * imageWidthHeightOffset, height);
        
        CGSize contentSize = imageScaleSize;
        contentSize = CGSizeMake(MAX(scrollSize.width, contentSize.width), MAX(scrollSize.height, contentSize.height));
        scrollView.contentSize = contentSize;
        
        imageView.frame = CGRectMake((contentSize.width - imageScaleSize.width) * 0.5f, (contentSize.height - imageScaleSize.height) * 0.5f, imageScaleSize.width, imageScaleSize.height);
        return;
    }
    
    if(imageWidthHeightOffset == scrollViewWidthHeightOffset) {
        CGSize imageScaleSize = CGSizeMake(imageView.image.size.width * scrollView.zoomScale, imageView.image.size.height * scrollView.zoomScale);
        scrollView.contentSize = imageScaleSize;
        imageView.frame = CGRectMake(0, 0, imageScaleSize.width, imageScaleSize.height);
        return;
    }
}

@interface PTPictureCell ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) PTPictureItem *item;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;

@end

@implementation PTPictureCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.contentView addSubview:self.scrollView];
        [self.scrollView addSubview:self.imageView];
        [self.contentView addSubview:self.loadingView];
        _item = [[PTPictureItem alloc] init];
        
        // 点击手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapScroll)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = self.contentView.bounds;
    self.loadingView.center = self.contentView.center;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    //    [self.loadingView startAnimating];
    self.scrollView.zoomScale = 1.0;
}

#pragma mark -- getters
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [_imageView sizeToFit];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.contentView.bounds];
        _scrollView.delegate = self;
        _scrollView.maximumZoomScale = 2.0;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.bouncesZoom = YES;
        _scrollView.alwaysBounceVertical = NO;
        _scrollView.alwaysBounceHorizontal = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIActivityIndicatorView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _loadingView.hidesWhenStopped = YES;
        [_loadingView startAnimating];
    }
    return _loadingView;
}
#pragma mark -

#pragma mark -- method
- (void)setValuesForCellItemWithItem:(PTPictureItem *)pictureItem {
    self.item = pictureItem;
    __weak typeof(self) weakSelf = self;
    [self.loadingView startAnimating];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:pictureItem.picUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [weakSelf scrollViewDidZoom:weakSelf.scrollView];
            [weakSelf.loadingView stopAnimating];
        }
    }];
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return (self.imageView);
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    scrollViewDidZoom(scrollView, self.imageView);
}
#pragma mark -

#pragma mark -- actions
- (void)didTapScroll {
    if (self.delegate && [self.delegate respondsToSelector:@selector(PTPictureCellDelegate:withPictureItem:)]) {
        [self.delegate PTPictureCellDelegate:self withPictureItem:self.item];
    }
}
#pragma mark -

@end
