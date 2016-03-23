//
//  PPTBaseViewController.m
//  PTLib
//
//  Created by LiLiLiu on 16/3/14.
//  Copyright © 2016年 putao. All rights reserved.
//

#import "PPTBaseViewController.h"
#import "PPTGlobal.h"

void PPTJumpViewController(Class viewControllerClass, NSDictionary *parameters, BOOL animated) {
    id viewController = [[viewControllerClass alloc] init];
    if(![viewController isKindOfClass:[UIViewController class]]) {
        NSLog(@">>>%@ is not subclass UIViewController", NSStringFromClass(viewControllerClass));
        PPTRELEASE(viewController);
        return;
    }
    if([viewController conformsToProtocol:@protocol(PPTViewControllerProtocol)]) {
        [viewController setParameters:parameters];
    }
    UIViewController *visibleViewController = PPTApplicationVisibleViewController();
    if(!visibleViewController) {
        NSLog(@">>>visible viewController is nil");
        PPTRELEASE(viewController);
        return;
    }
    if(visibleViewController.navigationController) {
        [visibleViewController.navigationController pushViewController:viewController animated:animated];
        return;
    }
#ifdef __IPHONE_6_0
    [visibleViewController presentViewController:viewController animated:animated completion:^{}];
#else
    [visibleViewController presentModalViewController:viewController animated:animated];
#endif
}






@implementation PPTBaseViewController


- (void)dealloc {
    PPTSUPERDEALLOC();
}

- (instancetype)init {
    return ([self initWithNibName:nil bundle:nil]);
}

- (instancetype)initWithSelfClassNameNib {
    return ([self initWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]]);
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        
    }
    return (self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)disableAdjustsScrollView {
    if([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)cleanEdgesForExtendedLayout {
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - <SOViewControllerProtocol>
+ (instancetype)viewControllerWithParameters:(id)parameters {
    id viewController = [[[self class] alloc] initWithParameters:parameters];
    PPTAUTORELEASE(viewController);
    return (viewController);
}

- (instancetype)initWithParameters:(id)parameters {
    self = [super init];
    if(self) {
        [self setParameters:parameters];
    }
    return (self);
}

- (void)setParameters:(id)parameters {
    //root do nothing
}
#pragma mark -

#pragma mark - orientation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation NS_DEPRECATED_IOS(2_0, 6_0) {
    return (NO);
}

- (BOOL)shouldAutorotate NS_AVAILABLE_IOS(6_0) {
    return (NO);
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations NS_AVAILABLE_IOS(6_0) {
    return (UIInterfaceOrientationMaskPortrait);
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation NS_AVAILABLE_IOS(6_0) {
    return (UIInterfaceOrientationPortrait);
}
#pragma mark -

@end
