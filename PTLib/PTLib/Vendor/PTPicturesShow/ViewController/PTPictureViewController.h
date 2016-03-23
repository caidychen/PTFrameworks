//
//  PTPictureViewController.h
//  PTLib
//
//  Created by zhangyi on 16/3/18.
//  Copyright © 2016年 putao. All rights reserved.
//

#import "SOBaseViewController.h"
#import "PTPictureItem.h"

@interface PTPictureViewController : SOBaseViewController

/**
 *  @brief  图片数组
 */
@property (nonatomic, strong) NSMutableArray <PTPictureItem *> *dataArr;

/**
 *  @brief  点击的index
 */
@property (nonatomic, assign) NSInteger clickIndex;

/**
 *  @brief  title
 */
@property (nonatomic, copy) NSString *picTitle;

@end
