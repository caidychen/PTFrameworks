//
//  PTShareItem.h
//  PTLib
//
//  Created by zhangyi on 16/3/14.
//  Copyright © 2016年 putao. All rights reserved.
//

#import "SOBaseItem.h"

@interface PTShareItem : SOBaseItem

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *shareDescription;
@property (nonatomic, copy) NSString *webUrl;
@property (nonatomic, strong) UIImage *shareImage;
@property (nonatomic, strong) UIImage *thumbImage;

@end
