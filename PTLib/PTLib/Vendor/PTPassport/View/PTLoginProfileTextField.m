//
//  PTLoginProfileTextField.m
//  PTLatitude
//
//  Created by LiLiLiu on 15/12/9.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTLoginProfileTextField.h"

#define PPT_MAX_ProfileTextField_LIMIT_NUMS     100           //来限制最大输入只能100个字符

@interface PTLoginProfileTextField ()<UITextFieldDelegate>

@end

@implementation PTLoginProfileTextField
@synthesize textField = _textField;

- (void)dealloc {
    PPTRELEASE(_textField);
    PPTSUPERDEALLOC();
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self addSubview:self.textField];
//        [self addSubview:self.line];
    }
    return (self);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textField.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds) , CGRectGetHeight(self.bounds)-0.5);
//    self.line.frame = CGRectMake(0, CGRectGetMaxY(self.textField.frame), CGRectGetWidth(self.bounds), 0.5);
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
        _textField.placeholder = @"个人简介";
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.secureTextEntry = NO;
        _textField.keyboardType = UIKeyboardTypeDefault;
        
        _textField.delegate = self;
    }
    return _textField;
}
#pragma mark -

#pragma mark - setter
- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    
    if (!_placeholder) {
        return;
    }
    
    self.textField.placeholder = _placeholder;
}
#pragma mark -


#pragma mark - <UITextFieldDelegate>
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //不允许 点击 Return 按钮换行
    if ([string isEqualToString:@"\n"]){
        NSLog(@"----提交请求----");
        if (self.requestActionBlock) {
            self.requestActionBlock(textField.text);
            self.textField.text = @"";   //清空输入文字
            self.textField.placeholder = @"个人简介";
        }
        //在这里做你响应return键的代码
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    
    
    //如果是在中文或9宫格键盘下会有什么问是呢。下图是我截图，当输入到只剩下一个字时，这时输入拼音时，问题出现了，发现拼音输不完。另一个问题是当离字数上限差距很大时，输入拼音会发现字数也跟着计算了。本来还没有输入的，此时开始计算了，有瘕次。
    //如果是在一段字中间插入的时候呢。这个是有可能出现的
    UITextRange *selectedRange = [textField markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textField positionFromPosition:selectedRange.start offset:0];
    
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textField offsetFromPosition:textField.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textField offsetFromPosition:textField.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < PPT_MAX_ProfileTextField_LIMIT_NUMS) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    
    
    
    
    NSString *comcatstr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSInteger caninputlen = PPT_MAX_ProfileTextField_LIMIT_NUMS-comcatstr.length;
    
    if (caninputlen >= 0)
    {
        //加入动态计算高度
        CGSize size = [self getStringRectInTextView:comcatstr InTextView:textField];
        CGRect frame = textField.frame;
        frame.size.height = size.height;
        
        textField.frame = frame;
        return YES;
    }
    else
    {
        //输入字数判断
        NSInteger len = string.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = [string substringWithRange:rg];
            [textField setText:[textField.text stringByReplacingCharactersInRange:range withString:s]];
            //既然是超出部分截取了，哪一定是最大限制了。
            //            self.inputView.text = [NSString stringWithFormat:@"%d/%ld",0,(long)MAX_QUESTION_LIMIT_NUMS];
        }
        return NO;
    }
    
}


- (void)textViewDidChange:(UITextView *)textView
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (textView == self.inputView) {
        
        if (0 == textView.text.length) {
            self.textField.placeholder = @"在这里输入问题 (200字以内)";
        }
        else {
            self.textField.placeholder = @"";
        }
        
        if (existTextNum > PPT_MAX_ProfileTextField_LIMIT_NUMS)
        {
            //截取到最大位置的字符
            NSString *s = [nsTextContent substringToIndex:PPT_MAX_ProfileTextField_LIMIT_NUMS];
            [textView setText:s];
        }
        
        //不让显示负数
        //        self.inputView.text = [NSString stringWithFormat:@"%ld/%d",MAX(0,MAX_QUESTION_LIMIT_NUMS - existTextNum),MAX_QUESTION_LIMIT_NUMS];
    }
    
    [self refreshTextViewSize:textView];
}
#pragma mark -


- (CGSize)getStringRectInTextView:(NSString *)string InTextView:(UITextView *)textView
{
    //实际textView显示时我们设定的宽
    CGFloat contentWidth = CGRectGetWidth(textView.frame);
    //但事实上内容需要除去显示的边框值
    CGFloat broadWith    = (textView.contentInset.left + textView.contentInset.right
                            + textView.textContainerInset.left
                            + textView.textContainerInset.right
                            + textView.textContainer.lineFragmentPadding/*左边距*/
                            + textView.textContainer.lineFragmentPadding/*右边距*/);
    
    CGFloat broadHeight  = (textView.contentInset.top
                            + textView.contentInset.bottom
                            + textView.textContainerInset.top
                            + textView.textContainerInset.bottom);//+self.textview.textContainer.lineFragmentPadding/*top*//*+theTextView.textContainer.lineFragmentPadding*//*there is no bottom padding*/);
    
    //由于求的是普通字符串产生的Rect来适应textView的宽
    contentWidth -= broadWith;
    
    CGSize InSize = CGSizeMake(contentWidth, MAXFLOAT);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = textView.textContainer.lineBreakMode;
    NSDictionary *dic = @{NSFontAttributeName:textView.font, NSParagraphStyleAttributeName:[paragraphStyle copy]};
    
    CGSize calculatedSize =  [string boundingRectWithSize:InSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    
    CGSize adjustedSize = CGSizeMake(ceilf(calculatedSize.width),calculatedSize.height + broadHeight);
    return adjustedSize;
}

- (void)refreshTextViewSize:(UITextView *)textView
{
    CGSize size = [self getStringRectInTextView:textView.text InTextView:textView];
    CGRect frame = textView.frame;
    frame.size.height = size.height;
    
    textView.frame = frame;
    
    if (self.actionBlock) {
        self.actionBlock(frame);
    }
    
    
}
@end
