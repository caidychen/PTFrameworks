//
//  UITapGestureRecognizer+PTNoRepeat.h
//  KangYang
//
//  Created by KangYang on 16/3/15.
//  Copyright © 2016年 KangYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITapGestureRecognizer (PTNoRepeat) <UIGestureRecognizerDelegate>

//两次点击之间的时间间隔，单位是秒
@property (assign, nonatomic) CGFloat pt_NoRepeatInterval;

@end
