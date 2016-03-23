//
//  PTLoginImageTextField.m
//  PTLatitude
//
//  Created by LiLiLiu on 15/11/30.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTLoginImageTextField.h"
#import "PassportMacro.h"

static CGFloat const codeImageWidth = 96.0f;
static CGFloat const codeImageHeight = 32.0f;

@interface PTLoginImageTextField ()<UITextFieldDelegate>
@property (nonatomic,strong) UIView *line;
@property (nonatomic,strong) UIImageView *codeImageView;
@property (strong, nonatomic, readonly) UIActivityIndicatorView *activityView;
@end

@implementation PTLoginImageTextField

@synthesize textField = _textField;
@synthesize line = _line;
@synthesize codeImageView = _codeImageView;
@synthesize activityView = _activityView;

- (void)dealloc {
    PPTRELEASE(_textField);
    PPTRELEASE(_line);
    PPTRELEASE(_codeImageView);
    PPTRELEASE(_activityView);
    PPTSUPERDEALLOC();
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self addSubview:self.textField];
        [self addSubview:self.line];
        [self addSubview:self.codeImageView];
        [self addSubview:self.activityView];
        
        [self showLoading:YES];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(codeImageTap)];
        [self.codeImageView addGestureRecognizer:tap];
    }
    return (self);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textField.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds)-codeImageWidth, CGRectGetHeight(self.bounds)-0.5);
    self.line.frame = CGRectMake(0, CGRectGetMaxY(self.textField.frame), CGRectGetWidth(self.bounds), 0.5);
    
    CGFloat codeImageY = ceilf((CGRectGetHeight(self.bounds)-codeImageHeight)*0.2 );
    self.codeImageView.frame = CGRectMake(CGRectGetMaxX(self.textField.frame), codeImageY, codeImageWidth, codeImageHeight);
    
    self.activityView.center = self.codeImageView.center;
}

#pragma mark - getter
- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.textColor = [UIColor blackColor];
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.font = [UIFont systemFontOfSize:16];
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.returnKeyType = UIReturnKeyNext;
        _textField.secureTextEntry = NO;
        _textField.keyboardType = UIKeyboardTypeDefault;
        
        _textField.delegate = self;
    }
    return _textField;
}

- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectZero];
        _line.backgroundColor = Passport_TEXT_INPUT_LINE_COLOR;
    }
    return _line;
}

- (UIImageView *)codeImageView{
    if (!_codeImageView) {
        _codeImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _codeImageView.backgroundColor = [UIColor clearColor];
        _codeImageView.contentMode = UIViewContentModeScaleAspectFit;
        _codeImageView.userInteractionEnabled = YES;
    }
    return _codeImageView;
}

/**
 * @brief 点击登录按钮时，启动加载
 */
- (UIActivityIndicatorView *)activityView {
    if(!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityView.color = [UIColor colorWithHexString:@"985ec9"];
        _activityView.hidesWhenStopped = YES;
    }
    return (_activityView);
}
#pragma mark -

#pragma mark - setter
- (void)setDelegate:(id<UITextFieldDelegate>)delegate{
    if (delegate) {
        self.textField.delegate = delegate;
    }
}

- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    
    if (!_placeholder) {
        return;
    }
    
    self.textField.placeholder = _placeholder;
}

- (void)setCodeImageUrl:(NSString *)codeImageUrl{
    _codeImageUrl = codeImageUrl;
    
    if (!_codeImageUrl) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:codeImageUrl]]];

        __strong typeof(weakSelf) strong_weakSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [strong_weakSelf.codeImageView setImage:image];
            [strong_weakSelf showLoading:NO];
        });
    });
    
}


- (void)showLoading:(BOOL)loading {
    if(loading) {
        [self.activityView startAnimating];
    } else {
        [self.activityView stopAnimating];
    }
    self.codeImageView.userInteractionEnabled = !loading;
    [self setNeedsLayout];
}
#pragma mark -


#pragma mark - action
- (void)codeImageTap{
    [self.textField becomeFirstResponder];
    self.textField.text = @"";
    
    if (self.imageTapActionBlock) {
        self.imageTapActionBlock();
    }
}
#pragma mark -


#pragma mark - <UITextFieldDelegate>
// return NO to not change text
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    //对手机号码长度进行验证
    if (toBeString.length >= Passport_imageCodeLength){
        textField.text = [toBeString substringToIndex:Passport_imageCodeLength];
        
        if (self.inputActionBlock) {
            self.inputActionBlock(textField.text,YES);
        }
        
        return NO;
    }
    
    if (self.inputActionBlock) {
        self.inputActionBlock(textField.text,NO);
    }
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    if (self.inputActionBlock) {
        self.inputActionBlock(textField.text,NO);
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSString *toBeString = textField.text;
    
    if (toBeString.length >= Passport_imageCodeLength) {
        if (self.inputActionBlock) {
            self.inputActionBlock(textField.text,YES);
        }
        
        return NO;
    }else{
        if (self.inputActionBlock) {
            self.inputActionBlock(textField.text,NO);
        }
    }
    
    return YES;
}

#pragma mark -




@end
