//
//  UIView+PTView.m
//
//  Created by CHEN KAIDI on 14/3/2016.
//  Copyright © 2016 Putao. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "UIView+PTView.h"

@implementation UIView (PTView)

+(UIWindow*)topWindows
{
    NSArray *windowsArray = [UIApplication sharedApplication].windows;
    if (windowsArray && [windowsArray count] > 0) {
        return [windowsArray lastObject];
    }else{
        return [UIApplication sharedApplication].keyWindow;
    }
}

+ (void)getVerticalLineWithWidth:(float)width beginPointX:(float)beginPointX beginPointY:(float)beginPointY height:(float)height color:(UIColor *)color superView:(UIView *)superView {
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(beginPointX, beginPointY, width, height)];
    [line setBackgroundColor:color];
    [superView addSubview:line];
}

+ (void)getHorizontalLineWithWidth:(float)width beginPointX:(float)beginPointX beginPointY:(float)beginPointY wide:(float)wide color:(UIColor *)color superView:(UIView *)superView {
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(beginPointX, beginPointY, wide, width)];
    [line setBackgroundColor:color];
    [superView addSubview:line];
}

-(void)shadowEffectOn{
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowRadius = 4;
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

-(UIImage *)screenshot{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenShot;
}

- (void)makeCornerRadius:(CGFloat)radius borderColor:(UIColor *)bColor borderWidth:(CGFloat)bWidth {
    self.layer.borderWidth = bWidth;
    if (bColor) {
        self.layer.borderColor = bColor.CGColor;
    }
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = radius;
}

-(void)applyFadeOutBoundaryEffectTopDownWithGradientOpacity:(CGFloat)opactiy length:(CGFloat)length margin:(CGFloat)margin effectOption:(PTViewFadeOutBoundaryEffectOptions)option{
    CALayer *viewLayer = [self layer];
    CALayer* maskLayer = [CALayer layer];
    
    maskLayer.bounds = viewLayer.bounds;
    
    [maskLayer setPosition:CGPointMake(CGRectGetWidth(viewLayer.frame)/2.0, CGRectGetHeight(viewLayer.frame)/2.0)];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate (NULL, viewLayer.bounds.size.width, viewLayer.bounds.size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
    
    CGFloat colors[] = {
        0.0, 0.0, 0.0, opactiy,
        0.0, 0.0, 0.0, 1.0,
    };
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
    CGColorSpaceRelease(colorSpace);
    
    NSUInteger gradientH = length;
    NSUInteger gradientHPos = margin;
    
    //Top section with gradient
    if (option == PTViewFadeOutBoundaryEffectOptionsTopOnly || option == PTViewFadeOutBoundaryEffectOptionsTopBottom) {
        CGContextDrawLinearGradient(context, gradient, CGPointMake(160, CGRectGetHeight(maskLayer.frame)-gradientHPos), CGPointMake(160, CGRectGetHeight(maskLayer.frame)-gradientHPos - gradientH), 0);
    }
    
    //Middle section
    CGFloat topOffset = 0;
    CGFloat bottomOffset = 0;
    switch (option) {
        case PTViewFadeOutBoundaryEffectOptionsTopOnly:
            topOffset = gradientHPos + gradientH;
            bottomOffset = 0;
            break;
        case PTViewFadeOutBoundaryEffectOptionsBottomOnly:
            topOffset = 0;
            bottomOffset = gradientHPos + gradientH;
            break;
        case PTViewFadeOutBoundaryEffectOptionsTopBottom:
            topOffset = gradientHPos + gradientH;
            bottomOffset = gradientHPos + gradientH;
            break;
        default:
            break;
    }
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0].CGColor);
    CGContextFillRect(context, CGRectMake(0, bottomOffset, CGRectGetWidth(maskLayer.frame), CGRectGetHeight(maskLayer.frame)-bottomOffset-topOffset));
    
    //Bottom section with gradient
    if (option == PTViewFadeOutBoundaryEffectOptionsBottomOnly || option == PTViewFadeOutBoundaryEffectOptionsTopBottom) {
        CGContextDrawLinearGradient(context, gradient, CGPointMake(160, gradientHPos), CGPointMake(160, gradientHPos + gradientH), 0);
    }
    
    CGGradientRelease(gradient);
    
    CGImageRef contextImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    
    [maskLayer setContents:(__bridge id)contextImage];
    
    CGImageRelease (contextImage);
    
    viewLayer.masksToBounds = YES;
    viewLayer.mask = maskLayer;
}


@end
