//
//  PPTBaseView.m
//  PTLib
//
//  Created by LiLiLiu on 16/3/14.
//  Copyright © 2016年 putao. All rights reserved.
//

#import "PPTBaseView.h"
#import "PPTGlobal.h"

@implementation PPTBaseView

@synthesize contentInsets = _contentInsets;
@synthesize verticalSpace = _verticalSpace;
@synthesize horizontalSpace = _horizontalSpace;

- (void)dealloc {
    PPTSUPERDEALLOC();
}

- (instancetype)init {
    return ([self initWithFrame:CGRectZero]);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _contentInsets = UIEdgeInsetsZero;
        _verticalSpace = _horizontalSpace = 0;
    }
    return self;
}

#pragma mark - setter
- (void)setContentInsets:(UIEdgeInsets)contentInsets {
    _contentInsets = contentInsets;
    [self setNeedsLayout];
}

- (void)setVerticalSpace:(CGFloat)verticalSpace {
    _verticalSpace = verticalSpace;
    [self setNeedsLayout];
}

- (void)setHorizontalSpace:(CGFloat)horizontalSpace {
    _horizontalSpace = horizontalSpace;
    [self setNeedsLayout];
}
#pragma mark -

@end
