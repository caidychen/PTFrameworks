//
//  PassportLoadingView.h
//  PTLib
//
//  Created by LiLiLiu on 16/3/15.
//  Copyright © 2016年 putao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PassportLoadingViewActionBlock)();

@interface PassportLoadingView : UIView

@property (nonatomic, copy) PassportLoadingViewActionBlock onClick;
- (void)startSpinning;
- (void)stopSpinning;

@end
