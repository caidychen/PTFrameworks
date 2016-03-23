//
//  DemoSectionItem.h
//  PTLib
//
//  Created by LiLiLiu on 16/3/13.
//  Copyright © 2016年 putao. All rights reserved.
//

#import "SOBaseItem.h"

/**
 * @brief 封装 Demo 列表中，一个 SectionHeader 中的内容
 {
    "sectionName": "公共库",
    "rows": [
        {
            "rowName":"Passport登录";
            "rowState":"InProgress"
        },
        {
            "rowName":"jPush推送";
            "rowState":"NotYetStarted"
        }
    ]
 }
 */
@interface DemoSectionItem : SOBaseItem<NSCopying>

@property (nonatomic, copy)  NSString * sectionName;
@property (nonatomic, strong)NSArray *rows;

@end
