//
//  PTPictureDescribeView.m
//  PTLib
//
//  Created by zhangyi on 16/3/18.
//  Copyright © 2016年 putao. All rights reserved.
//

#import "PTPictureDescribeView.h"

static CGFloat commonOffset = 20 * 0.5;
static CGFloat numberWithFourLinesHeight = 73;

@interface PTPictureDescribeView () <UIScrollViewDelegate>

@property (nonatomic, strong) UILabel *describeLabel;
@property (nonatomic, strong) UIScrollView *scrollView;

+ (NSAttributedString *)setLineSpacing:(CGFloat)lineSpace withAttributedText:(NSMutableAttributedString *)attributedText font:(UIFont *)font;
+ (CGFloat)getHeightForAttributedString:(NSAttributedString *)attributedString boundingRect:(CGSize)boundingRect;

@end

@implementation PTPictureDescribeView

+ (CGFloat)getHeightWithStr:(NSString *)str {
    CGFloat height = 0;
    height += commonOffset;
    if (!str || str.length == 0) {
        return 0;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, attributedString.length)];
    
    NSMutableAttributedString *lineSpacingStr = [[NSMutableAttributedString alloc] initWithAttributedString:[PTPictureDescribeView setLineSpacing:5.0f withAttributedText:attributedString font:[UIFont systemFontOfSize:12]]];
    CGFloat strHeight = [PTPictureDescribeView getHeightForAttributedString:lineSpacingStr  boundingRect:CGSizeMake([UIScreen mainScreen].bounds.size.width - 2 * commonOffset, CGFLOAT_MAX)];
    
    if (strHeight > numberWithFourLinesHeight) {
        // 高度大于 4行的高度
        // 固定73高度 10 + 73 + 10
        height += numberWithFourLinesHeight;
    } else {
        height += strHeight;
    }
    height += commonOffset;
    return height;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.describeLabel];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = CGRectMake(commonOffset, commonOffset, self.width - 2 * commonOffset, self.height - 2 * commonOffset);
    self.describeLabel.frame = CGRectMake(0, 0, self.width - 2 * commonOffset, self.describeLabel.height);
}

#pragma mark -- getters
- (UILabel *)describeLabel {
    if (!_describeLabel) {
        _describeLabel = [[UILabel alloc] init];
        [_describeLabel sizeToFit];
        _describeLabel.numberOfLines = 0;
    }
    return _describeLabel;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
    }
    return _scrollView;
}
#pragma mark -

#pragma mark -- method
- (void)setValuesForViewWithStr:(NSString *)str {
    if (!str || str.length == 0) {
        self.describeLabel.text = @"";
        return;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attributedString.length)];
    NSMutableAttributedString *lineSpacingStr = [[NSMutableAttributedString alloc] initWithAttributedString:[PTPictureDescribeView setLineSpacing:5.0f withAttributedText:attributedString font:[UIFont systemFontOfSize:12]]];
    CGFloat strHeight = [PTPictureDescribeView getHeightForAttributedString:lineSpacingStr  boundingRect:CGSizeMake([UIScreen mainScreen].bounds.size.width - 2 * commonOffset, CGFLOAT_MAX)];
    if (strHeight >= numberWithFourLinesHeight) {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.width, strHeight);
    } else {
        self.scrollView.height = strHeight;
        self.scrollView.contentSize = self.scrollView.size;
    }
    
    self.describeLabel.height = strHeight;
    
    self.describeLabel.attributedText = lineSpacingStr;
    [self layoutSubviews];
    
}

+ (NSAttributedString *)setLineSpacing:(CGFloat)lineSpace withAttributedText:(NSMutableAttributedString *)attributedText font:(UIFont *)font{
    if (attributedText.string.length == 0) {
        return nil ;
    }
    [attributedText addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributedText.string.length)];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = lineSpace;
    style.alignment = NSTextAlignmentJustified;
    [attributedText addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attributedText.string.length)];
    return attributedText;
}

+ (CGFloat)getHeightForAttributedString:(NSAttributedString *)attributedString boundingRect:(CGSize)boundingRect{
    CGRect paragraphRect =
    [attributedString boundingRectWithSize:boundingRect
                                   options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                   context:nil];
    return ceilf(paragraphRect.size.height);
}
#pragma mark -

@end
