//
//  UITapGestureRecognizer+PTNoRepeat.m
//  KangYang
//
//  Created by KangYang on 16/3/15.
//  Copyright © 2016年 KangYang. All rights reserved.
//

#import "UITapGestureRecognizer+PTNoRepeat.h"
#import <objc/runtime.h>

static const char *UITapGestureRecognizer_noRepeatInterval = "UITapGestureRecognizer_noRepeatInterval";
static const char *UITapGestureRecognizer_noRepeatTime = "UITapGestureRecognizer_noRepeatTime";

@interface UITapGestureRecognizer (PTNoRepeat_Private)

@property (assign, nonatomic) NSTimeInterval pt_NoRepaetTime;

@end

@implementation UITapGestureRecognizer (PTNoRepeat_Private)

- (NSTimeInterval)pt_NoRepaetTime
{
    return [objc_getAssociatedObject(self, UITapGestureRecognizer_noRepeatTime) integerValue];
}

- (void)setPt_NoRepaetTime:(NSTimeInterval)pt_NoRepaetTime
{
    objc_setAssociatedObject(self,
                             UITapGestureRecognizer_noRepeatTime,
                             @(pt_NoRepaetTime),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UITapGestureRecognizer (PTNoRepeat)

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([NSDate date].timeIntervalSince1970 - self.pt_NoRepaetTime < self.pt_NoRepeatInterval) {
        return NO;
    }
    
    if (self.pt_NoRepeatInterval > 0) {
        self.pt_NoRepaetTime = [NSDate date].timeIntervalSince1970;
    }
    
    return YES;
}

#pragma mark - getters and setters

- (CGFloat)pt_NoRepeatInterval
{
    return [objc_getAssociatedObject(self, UITapGestureRecognizer_noRepeatInterval) floatValue];
}

- (void)setPt_NoRepeatInterval:(CGFloat)pt_NoRepeatInterval
{
    objc_setAssociatedObject(self,
                             UITapGestureRecognizer_noRepeatInterval,
                             @(pt_NoRepeatInterval),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (pt_NoRepeatInterval > 0) {
        self.delegate = self;
    }
}

@end
