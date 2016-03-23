//
//  UIButton+PPTButton.m
//  PTLib
//
//  Created by LiLiLiu on 16/3/14.
//  Copyright © 2016年 putao. All rights reserved.
//

#import "UIButton+PPTButton.h"
#import <objc/runtime.h>

@implementation UIButton (PPTButton)


+ (instancetype)buttonWithImage:(UIImage *)image {
    return ([self buttonWithImage:image selectedImage:nil highlightImage:nil disableImage:nil]);
}

+ (instancetype)buttonWithImage:(UIImage *)nImage
                  selectedImage:(UIImage *)sImage {
    return ([self buttonWithImage:nImage selectedImage:sImage highlightImage:nil disableImage:nil]);
}

+ (instancetype)buttonWithImage:(UIImage *)nImage
                  selectedImage:(UIImage *)sImage
                hightlightImage:(UIImage *)hImage {
    return ([self buttonWithImage:nImage selectedImage:sImage highlightImage:hImage disableImage:nil]);
}

+ (instancetype)buttonWithImage:(UIImage *)nImage
                  selectedImage:(UIImage *)sImage
                 highlightImage:(UIImage *)hImage
                   disableImage:(UIImage *)dImage {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if(nImage && [nImage isKindOfClass:[UIImage class]]) {
        [button setImage:nImage forState:UIControlStateNormal];
    }
    if(sImage && [sImage isKindOfClass:[UIImage class]]) {
        [button setImage:sImage forState:UIControlStateSelected];
    }
    if(hImage && [hImage isKindOfClass:[UIImage class]]) {
        [button setImage:hImage forState:UIControlStateHighlighted];
    }
    if(dImage && [dImage isKindOfClass:[UIImage class]]) {
        [button setImage:dImage forState:UIControlStateDisabled];
    }
    return (button);
}

- (instancetype)initWithImage:(UIImage *)image {
    return ([self initWithImage:image selectedImage:nil highlightImage:nil disableImage:nil]);
}

- (instancetype)initWithImage:(UIImage *)nImage
                selectedImage:(UIImage *)sImage {
    return ([self initWithImage:nImage selectedImage:sImage highlightImage:nil disableImage:nil]);
}

- (instancetype)initWithImage:(UIImage *)nImage
                selectedImage:(UIImage *)sImage
              hightlightImage:(UIImage *)hImage {
    return ([self initWithImage:nImage selectedImage:sImage highlightImage:hImage disableImage:nil]);
}

- (instancetype)initWithImage:(UIImage *)nImage
                selectedImage:(UIImage *)sImage
               highlightImage:(UIImage *)hImage
                 disableImage:(UIImage *)dImage {
    self = [super init];
    if(self) {
        if(nImage && [nImage isKindOfClass:[UIImage class]]) {
            [self setImage:nImage forState:UIControlStateNormal];
        }
        if(sImage && [sImage isKindOfClass:[UIImage class]]) {
            [self setImage:sImage forState:UIControlStateSelected];
        }
        if(hImage && [hImage isKindOfClass:[UIImage class]]) {
            [self setImage:hImage forState:UIControlStateHighlighted];
        }
        if(dImage && [dImage isKindOfClass:[UIImage class]]) {
            [self setImage:dImage forState:UIControlStateDisabled];
        }
    }
    return (self);
}

@end



#define PPT_KEY_ANIMATIONBUTTON_ANIMATION       @"PPT_keyAnimationButtonAnimation"
#define PPT_ANIMATIONBUTTON_ANIMATION_DURATION  0.5f

static NSString * const _PPT_KeySOAnimationButtonAnimating;
static NSString * const _PPT_KeySOAnimationButtonTimeInt;

@implementation UIButton (PPTRotationAnimatiion)

- (void)startAnimating {
    if([self isAnimating]) {
        return;
    }
    self.animating = YES;
    CAKeyframeAnimation *ani = [[CAKeyframeAnimation alloc] init];
    ani.keyPath = @"transform.rotation.z";
    ani.values = @[[NSNumber numberWithFloat:0],
                   [NSNumber numberWithFloat:M_PI_2],
                   [NSNumber numberWithFloat:M_PI],
                   [NSNumber numberWithFloat:M_PI + M_PI_2],
                   [NSNumber numberWithFloat:M_PI + M_PI]];
    ani.repeatCount = NSUIntegerMax;
    ani.duration = PPT_ANIMATIONBUTTON_ANIMATION_DURATION;
    [self.imageView.layer addAnimation:ani forKey:PPT_KEY_ANIMATIONBUTTON_ANIMATION];
    self.timeInt = [NSDate timeIntervalSinceReferenceDate];
}

- (void)stopAnimating {
    if(![self isAnimating]) {
        return;
    }
    //刚好转整数圈
    NSTimeInterval timeInt = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval dis = (timeInt - self.timeInt);
    double offset = dis / PPT_ANIMATIONBUTTON_ANIMATION_DURATION;
    offset -= ((NSInteger)offset);
    NSTimeInterval delay = (1.0f - offset) * PPT_ANIMATIONBUTTON_ANIMATION_DURATION;
    [self.imageView.layer performSelector:@selector(removeAnimationForKey:) withObject:PPT_KEY_ANIMATIONBUTTON_ANIMATION afterDelay:delay];
    self.animating = NO;
}

- (BOOL)isAnimating {
    return ([self animating]);
}

#pragma mark -
- (BOOL)animating {
    id aObj = objc_getAssociatedObject(self, &_PPT_KeySOAnimationButtonAnimating);
    return ([aObj boolValue]);
}

- (void)setAnimating:(BOOL)animating {
    objc_setAssociatedObject(self, &_PPT_KeySOAnimationButtonAnimating, @(animating), OBJC_ASSOCIATION_RETAIN);
}

- (NSTimeInterval)timeInt {
    id aObj = objc_getAssociatedObject(self, &_PPT_KeySOAnimationButtonTimeInt);
    return ([aObj doubleValue]);
}

- (void)setTimeInt:(NSTimeInterval)timeInt {
    objc_setAssociatedObject(self, &_PPT_KeySOAnimationButtonTimeInt, @(timeInt), OBJC_ASSOCIATION_RETAIN);
}
#pragma mark -

@end

