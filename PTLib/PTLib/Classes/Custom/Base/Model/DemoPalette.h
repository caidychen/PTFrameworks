//
//  DemoPalette.h
//  PTLib
//
//  Created by LiLiLiu on 16/3/13.
//  Copyright © 2016年 putao. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @brief 读取 demo.json 中的数据，生成 ViewController 页面需要的数据
 */
@interface DemoPalette : NSObject

@property (nonatomic, readonly) NSMutableArray *sections;

+ (instancetype)sharedPalette;

@end
