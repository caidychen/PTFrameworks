//
//  DemoSectionRowItem.h
//  PTLib
//
//  Created by LiLiLiu on 16/3/13.
//  Copyright © 2016年 putao. All rights reserved.
//

#import "SOBaseItem.h"

//typedef NS_ENUM(NSInteger, DemoRoeState){
//    DemoRoeStateNotYetStarted,    //还没有开始
//    DemoRoeStateStart,            //开始
//    DemoRoeStateInProgress,       //进行中
//    DemoRoeStateFinish            //完成
//};


/**
 * @brief 封装一个 Section 中的一行中的数据
 
 {
    "rowName":"Passport登录";
    "rowState":"InProgress"
 },
 */
@interface DemoSectionRowItem : SOBaseItem<NSCopying>

@property (nonatomic, copy) NSString *demoID;
@property (nonatomic, copy) NSString *rowName;
@property (nonatomic, copy) NSString *rowStateColor;

@end
