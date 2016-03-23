//
//  UIControl+PTNoRepeat.m
//  KangYang
//
//  Created by KangYang on 16/3/14.
//  Copyright © 2016年 KangYang. All rights reserved.
//

#import "UIControl+PTNoRepeat.h"
#import <objc/runtime.h>

static const char *UIControl_noRepeatInterval = "UIControl_noRepeatInterval";
static const char *UIControl_noRepeatTime = "UIControl_noRepeatTime";
static const char *UIControl_disabledWhenIntime = "UIControl_disabledWhenIntime";

@interface UIControl (PTNoRepeat_Private)

@property (assign, nonatomic) NSTimeInterval pt_NoRepaetTime;

@end

@implementation UIControl (PTNoRepeat_Private)

- (NSTimeInterval)pt_NoRepaetTime
{
    return [objc_getAssociatedObject(self, UIControl_noRepeatTime) integerValue];
}

- (void)setPt_NoRepaetTime:(NSTimeInterval)pt_NoRepaetTime
{
    objc_setAssociatedObject(self,
                             UIControl_noRepeatTime,
                             @(pt_NoRepaetTime),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UIControl (PTNoRepeat)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalMethod = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
        Method swapMethod = class_getInstanceMethod(self, @selector(pt_sendAction:to:forEvent:));
        method_exchangeImplementations(originalMethod, swapMethod);
    });
}

- (void)pt_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    if (event.type == UIEventTypeTouches) {
        
        if ([NSDate date].timeIntervalSince1970 - self.pt_NoRepaetTime < self.pt_NoRepeatInterval) {
            return;
        }
        
        if (self.pt_NoRepeatInterval > 0) {
            self.pt_NoRepaetTime = [NSDate date].timeIntervalSince1970;
            
            if (self.pt_disabledWhenIntime) {
                self.enabled = NO;
                [self performSelector:@selector(timeout)
                           withObject:nil
                           afterDelay:self.pt_NoRepeatInterval];
            }
        }
    }
    
    [self pt_sendAction:action to:target forEvent:event];
}

- (void)timeout
{
    self.enabled = YES;
}

#pragma mark - getters and setters

- (BOOL)pt_disabledWhenIntime
{
    return [objc_getAssociatedObject(self, UIControl_disabledWhenIntime) boolValue];
}

- (void)setPt_disabledWhenIntime:(BOOL)pt_disabledWhenIntime
{
    objc_setAssociatedObject(self,
                             UIControl_disabledWhenIntime,
                             @(pt_disabledWhenIntime),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)pt_NoRepeatInterval
{
    return [objc_getAssociatedObject(self, UIControl_noRepeatInterval) floatValue];
}

- (void)setPt_NoRepeatInterval:(CGFloat)pt_NoRepeatInterval
{
    objc_setAssociatedObject(self,
                             UIControl_noRepeatInterval,
                             @(pt_NoRepeatInterval),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
