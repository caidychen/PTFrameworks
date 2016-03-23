//
//  PTLoginAddPhotoView.m
//  PTLatitude
//
//  Created by LiLiLiu on 15/11/30.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTLoginAddPhotoView.h"

//Model

//View

//Controller

static CGFloat const PPT_photoWH = 80.0f;
static CGFloat const PPT_iconWH = 20.0f;

@interface PTLoginAddPhotoView ()
@property (nonatomic, strong) UIImageView *btnPhoto;
@property (nonatomic, strong) UIImageView *cameraIcon;
@end

@implementation PTLoginAddPhotoView
@synthesize btnPhoto = _btnPhoto;
@synthesize cameraIcon = _cameraIcon;

- (void)dealloc {
    PPTRELEASE(_btnPhoto);
    PPTRELEASE(_cameraIcon);
    PPTSUPERDEALLOC();
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self addSubview:self.btnPhoto];
        [self addSubview:self.cameraIcon];
    }
    return (self);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.btnPhoto.frame = CGRectMake(0, 0, PPT_photoWH, PPT_photoWH);
    CGFloat xPoint = floorf(CGRectGetWidth(self.bounds)*0.5);
    CGFloat yPoint = ceilf(CGRectGetHeight(self.bounds)*0.5);
    self.btnPhoto.center = CGPointMake(xPoint, yPoint);
    
    CGFloat xIconPoint = xPoint+20.0f;
    CGFloat yIconPoint = yPoint+20.0f;
    self.cameraIcon.frame = CGRectMake(xIconPoint, yIconPoint, PPT_iconWH, PPT_iconWH);
}

#pragma mark - getter
- (UIImageView *)btnPhoto{
    if (!_btnPhoto) {
        _btnPhoto = [[UIImageView alloc] initWithFrame:CGRectZero];
        _btnPhoto.clipsToBounds = YES;
        _btnPhoto.layer.cornerRadius = PPT_photoWH*0.5;
        _btnPhoto.image = [UIImage imageNamed:@"img_head_signup"];
        _btnPhoto.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAddPhoto)];
        [_btnPhoto addGestureRecognizer:tap];
    }
    return _btnPhoto;
}

- (UIImageView *)cameraIcon{
    if (!_cameraIcon) {
        _cameraIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _cameraIcon.clipsToBounds = YES;
        _cameraIcon.layer.cornerRadius = PPT_iconWH*0.5;
        _cameraIcon.image = [UIImage imageNamed:@"icon_20_12"];
    }
    return _cameraIcon;
}

#pragma mark -


#pragma mark - setter
- (void)setPhotoImge:(UIImage *)photoImge{
    _photoImge = photoImge;
    
    if (!_photoImge) {
        return;
    }
    
    //这里是用户拍照或相册选中的图片，不是服务器返回的
    [_btnPhoto setImage:photoImge];
    [self setNeedsLayout];
}

#pragma mark -


#pragma mark - actions
- (void)onAddPhoto{
    if (self.actionBlock) {
        self.actionBlock();
    }
}
#pragma mark -


@end
