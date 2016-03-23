//
//  PTMTManager.h
//  PTLatitude
//
//  Created by LiLiLiu on 15/12/16.
//  Copyright © 2015年 PT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MTHelper.h"

@interface PTMTManager : NSObject

+ (void)setUpManager;

//每次进入 陪伴页面，初始化陪伴页面 游戏图标点击状态列表
+ (void)initGameListTouchStateDic;

@end
