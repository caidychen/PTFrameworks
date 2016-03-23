//
//  ViewControllerTableViewCell.m
//  PTLib
//
//  Created by LiLiLiu on 16/3/11.
//  Copyright © 2016年 putao. All rights reserved.
//

#import "ViewControllerTableViewCell.h"

CGFloat const PTVCTableViewCellBorder     = 10.0f;

//算 Title 标签内 文本内容尺寸
CGSize operateCellTitleLblSizeWithName(NSString *text,CGFloat textWidth){
    CGSize size = CGSizeMake(0.0f, 0.0f);
    if(text && text.length > 0) {
        UIFont *font = [UIFont systemFontOfSize:16];
        CGSize textSize = [text soSizeWithFont:font constrainedToWidth:textWidth];
        size = textSize;
    }
    
    return (size);
}

@interface ViewControllerTableViewCell ()
@property (assign, nonatomic) UIEdgeInsets contentInsets;
@property (nonatomic, strong) UIButton *button;
@end

@implementation ViewControllerTableViewCell
@synthesize button = _button;


+ (CGFloat)getCellHeight{
    return 64.0f;
}

- (void)dealloc {
    SORELEASE(_button);
    SOSUPERDEALLOC();
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.contentInsets = UIEdgeInsetsMake(PTVCTableViewCellBorder, PTVCTableViewCellBorder, PTVCTableViewCellBorder, PTVCTableViewCellBorder);
        [self.contentView addSubview:self.button];
    }
    return (self);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect inFrame = UIEdgeInsetsInsetRect(self.bounds, self.contentInsets);
    
    self.button.frame = CGRectMake(CGRectGetMinX(inFrame), CGRectGetMinY(inFrame), CGRectGetWidth(inFrame), CGRectGetHeight(inFrame));
    self.button.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.button.bounds].CGPath;
}

#pragma mark - getter
- (UIButton *)button{
    if (!_button) {
        _button = [[UIButton alloc] initWithFrame:CGRectZero];
        [_button setTitleColor:[UIColor colorWithHexString:@"646464"] forState:UIControlStateNormal];
        
        [_button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        
        _button.layer.masksToBounds = NO;
        _button.layer.shadowOffset = CGSizeMake(0, 2);
        _button.layer.shadowRadius = 4;
        _button.layer.shadowOpacity = 0.35;
        _button.layer.shadowColor = [UIColor blackColor].CGColor;
    }
    return _button;
}
#pragma mark -


#pragma mark - setter
- (void)setItem:(DemoSectionRowItem *)item{
    _item = item;
    
    if (!_item) {
        return;
    }

    [_button setTitle:_item.rowName forState:UIControlStateNormal];
    [_button setBackgroundColor:[UIColor colorWithHexString:_item.rowStateColor]];
}
#pragma mark -


#pragma mark - action
- (void)buttonPress:(UIButton *)sender{
    if (self.actionBlock) {
        self.actionBlock(self.item);
    }
}
#pragma mark -



@end
