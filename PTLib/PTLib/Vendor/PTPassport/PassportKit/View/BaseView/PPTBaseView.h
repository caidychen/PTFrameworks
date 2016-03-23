//
//  PPTBaseView.h
//  PTLib
//
//  Created by LiLiLiu on 16/3/14.
//  Copyright © 2016年 putao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+PPTAdditions.h"

@interface PPTBaseView : UIView{
    UIEdgeInsets _contentInsets;
    CGFloat _verticalSpace;
    CGFloat _horizontalSpace;
}

/**
 *  @brief  四周留的边框
 */
@property (assign, nonatomic) UIEdgeInsets contentInsets;

/**
 *  @brief  竖直方向的间距
 */
@property (assign, nonatomic) CGFloat verticalSpace;

/**
 *  @brief  水平方向的间距
 */
@property (assign, nonatomic) CGFloat horizontalSpace;

@end
