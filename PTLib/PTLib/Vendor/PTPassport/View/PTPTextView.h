//
//  PTPTextView.h
//  PTLib
//
//  Created by LiLiLiu on 16/3/14.
//  Copyright © 2016年 putao. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * @brief 自定义的带 placeholder属性的TextView
 */
@interface PTPTextView : UITextView

@property(nonatomic,copy) NSString *myPlaceholder;  //文字

@property(nonatomic,strong) UIColor *myPlaceholderColor; //文字颜色

@end
