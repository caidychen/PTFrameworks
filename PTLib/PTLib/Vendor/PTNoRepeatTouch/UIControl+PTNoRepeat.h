//
//  UIControl+PTNoRepeat.h
//  KangYang
//
//  Created by KangYang on 16/3/14.
//  Copyright © 2016年 KangYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (PTNoRepeat)

//默认是NO，当设置为YES后，处在不可点击状态时，enable属性为NO，状态还原时自动变为YES
@property (assign, nonatomic) BOOL pt_disabledWhenIntime;

//两次点击之间最小的时间间隔，默认是0，单位是秒
@property (assign, nonatomic) CGFloat pt_NoRepeatInterval;

@end
