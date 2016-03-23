//
//  PTPictureDescribeView.h
//  PTLib
//
//  Created by zhangyi on 16/3/18.
//  Copyright © 2016年 putao. All rights reserved.
//

#import "SOBaseView.h"

@interface PTPictureDescribeView : SOBaseView

+ (CGFloat)getHeightWithStr:(NSString *)str;
- (void)setValuesForViewWithStr:(NSString *)str;

@end
