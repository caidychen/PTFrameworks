//
//  PTLoginNavView.m
//  PTLatitude
//
//  Created by LiLiLiu on 15/11/30.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTLoginNavView.h"
#import "PassportMacro.h"

static CGFloat const backBarItemMargin = 15.0f;
static CGFloat const backBarItemWH = 20.0f;
static CGFloat const rightBarItemWidth = 30.0f;
static CGFloat const rightBarItemHeight = 20.0f;

@interface PTLoginNavView ()
@property (nonatomic , strong) UIButton *backBarItem;
@property (nonatomic , strong) UILabel  *titleLbl;
@end

@implementation PTLoginNavView
@synthesize backBarItem = _backBarItem;
@synthesize titleLbl = _titleLbl;
@synthesize rightBtn = _rightBtn;

- (void)dealloc {
    PPTRELEASE(_backBarItem);
    PPTRELEASE(_titleLbl);
    PPTRELEASE(_rightBtn);
    PPTSUPERDEALLOC();
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self addSubview:self.backBarItem];
        [self addSubview:self.titleLbl];
        [self addSubview:self.rightBtn];
    }
    return (self);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat yPoint = Passport_HEIGHT_STATUS+backBarItemMargin;
    self.backBarItem.frame = CGRectMake(0.0f, Passport_HEIGHT_STATUS, backBarItemWH*3, backBarItemWH*2);
    
    CGFloat titleX = backBarItemMargin+backBarItemWH;
    CGFloat titleWidth = CGRectGetWidth(self.bounds) - backBarItemMargin*2-backBarItemWH-rightBarItemWidth;
    self.titleLbl.frame = CGRectMake(titleX, yPoint, titleWidth, backBarItemWH);
    
    CGFloat rightBtnX = CGRectGetMaxX(self.titleLbl.frame);
    self.rightBtn.frame = CGRectMake(rightBtnX, yPoint, rightBarItemWidth, rightBarItemHeight);
}

#pragma mark - getter
- (UIButton *)backBarItem{
    if (!_backBarItem) {
        _backBarItem = [[UIButton alloc] initWithFrame:CGRectZero];
        [_backBarItem addTarget:self action:@selector(leftItemTouched:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBarItem;
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        _titleLbl.font = [UIFont systemFontOfSize:18.0f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"313131"];
        _titleLbl.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLbl.numberOfLines = 0;
    }
    
    return _titleLbl;
}

- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_rightBtn setTitleColor:Passport_THEME_COLOR forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor colorWithHexString:@"FFFFFF"] forState:UIControlStateHighlighted];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_rightBtn addTarget:self action:@selector(rightItemTouched:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

#pragma mark -


#pragma mark - setter
- (void)setBackType:(PTLoginNavBackType)backType{
    _backType = backType;
    
    switch (_backType) {
        case PTLoginNavBackTextType:
        {
            [self.backBarItem setTitle:@"取消" forState:UIControlStateNormal];
            [self.backBarItem setTitleColor:Passport_THEME_COLOR forState:UIControlStateNormal];
            [self.backBarItem setTitleColor:[UIColor colorWithHexString:@"b57de4"] forState:UIControlStateHighlighted];
        }
            break;
        case PTLoginNavBackImageType:
        {
            [self.backBarItem setImage:[UIImage imageNamed:@"btn_20_back_p_nor"] forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
    
    [self setNeedsLayout];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    
    if (!_title) {
        return;
    }
    
    self.titleLbl.text = _title;
    [self setNeedsLayout];
}

#pragma mark -


#pragma mark - action
- (void)leftItemTouched:(UIButton *) sender{
    if (self.leftActionBlock) {
        self.leftActionBlock();
    }
}

- (void)rightItemTouched:(UIButton *) sender{
    if (self.rightActionBlock) {
        self.rightActionBlock();
    }
}

#pragma mark -


@end
