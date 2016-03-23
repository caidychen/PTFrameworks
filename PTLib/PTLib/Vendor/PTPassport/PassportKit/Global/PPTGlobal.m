//
//  PPTGlobal.m
//  PTLib
//
//  Created by LiLiLiu on 16/3/14.
//  Copyright © 2016年 putao. All rights reserved.
//

#import "PPTGlobal.h"
#import "NSObject+PPTObject.h"


CGSize PPTCeilSize(CGSize size) {
    return (CGSizeMake(ceilf(size.width), ceilf(size.height)));
}

CGSize PPTFloorSize(CGSize size) {
    return (CGSizeMake(floorf(size.width), floorf(size.height)));
}

double PPTRandom() {
    u_int32_t b = -1;
    return ((double)(arc4random() % b) / b);
}

CGSize PPTScreenSize() {
    return ([[UIScreen mainScreen] bounds].size);
}

//系统版本
CGFloat PPTSystemVersion(void) {
    return ((CGFloat)[[[UIDevice currentDevice] systemVersion] floatValue]);
}

//屏幕缩放
CGFloat PPTDeviceScale(void) {
    return ([[UIScreen mainScreen] scale]);
}

BOOL PPTStringIsNilOrEmpty(NSString *str) {
    if(!str) {
        return (YES);
    }
    if(![str isKindOfClass:[NSString class]]) {
        return (YES);
    }
    if([str length] == 0) {
        return (YES);
    }
    return (NO);
}

NSString *PPTNSStringFromBOOL(BOOL b) {
    return (b ? @"Y" : @"N");
}

id PPTSafePerformSelector(id target, SEL selector, id obj) {
    if(!target || !selector) {
        return (nil);
    }
    if(![target respondsToSelector:selector]) {
        return (nil);
    }
    IMP imp = [target methodForSelector:selector];
    if(!imp) {
        return (nil);
    }
    id (*func)(id, SEL, id) = (void *)imp;
    id res = func(target, selector, obj);
    return (res);
}

SEL PPTSetSelectorWithPropertyName(NSString *pName) {
    if(!pName) {
        return (nil);
    }
    NSString *hd = [pName substringToIndex:1];
    NSString *lt = [pName substringFromIndex:1];
    NSString *slString = [NSString stringWithFormat:@"set%@%@:", [hd uppercaseString], lt];
    return (NSSelectorFromString(slString));
}

UIInterfaceOrientation PPTStatusBarOrientation() {
    return ([[UIApplication sharedApplication] statusBarOrientation]);
}

BOOL PPTStatusBarIsPortrait() {
    return (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation));
}

BOOL PPTStatusBarIsLandscape() {
    return (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation));
}


UIViewController *PPTApplicationRootViewController() {
    return ([[[UIApplication sharedApplication] keyWindow] rootViewController]);
}

UIViewController *PPTApplicationVisibleViewController() {
    return (PPTViewControllersVisibleViewController(PPTApplicationRootViewController()));
}

UIViewController *PPTApplicationTabBarAtIndex(NSUInteger index) {
    UIViewController *rootViewController = PPTApplicationRootViewController();
    if(!rootViewController || ![rootViewController isKindOfClass:[UITabBarController class]]) {
        return (rootViewController);
    }
    return ([[(UITabBarController *)rootViewController viewControllers] safeObjectAtIndex:index]);
}

UIViewController *PPTViewControllersRootNavigationViewController(UIViewController *viewController) {
    UIViewController *rootViewController = viewController;
    while (viewController.navigationController) {
        rootViewController = viewController.navigationController;
    }
    return (rootViewController);
}

UIViewController *PPTViewControllersVisibleViewController(UIViewController *viewController) {
    if([viewController isKindOfClass:[UITabBarController class]]) {
        return (PPTViewControllersVisibleViewController([(UITabBarController *)viewController selectedViewController]));
    }
    if([viewController isKindOfClass:[UINavigationController class]]) {
        return (PPTViewControllersVisibleViewController([(UINavigationController *)viewController visibleViewController]));
    }
    return (viewController);
}
