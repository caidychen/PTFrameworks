//
//  LDTPHelper.h
//  PTAsyncSocket
//
//  Created by so on 15/8/13.
//  Copyright (c) 2015年 so. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, LDTPActionID) {
    
    LDTPActionID_Index_LV1_Tab                      = 1001,     //一级页面, 点击首页TAB底部栏
    LDTPActionID_Index_LV2_WriterTopic              = 1111,     //二级页面, 点击作者头像
    LDTPActionID_Index_LV2_Product                  = 1112,     //二级页面, 点击任一相关产品
    LDTPActionID_Index_LV2_WeiXin_Friend            = 1113,     //二级页面, 点击分享给微信好友
    LDTPActionID_Index_LV2_WeiXin_Friends           = 1114,     //二级页面, 点击微信朋友圈
    LDTPActionID_Index_LV2_CopyLink                 = 1115,     //二级页面, 点击复制链接
    
    LDTPActionID_Category_LV1_Tab                   = 2001,     //一级页面, 点击分类TAB底部栏
    
    LDTPActionID_Find_LV1_Tab                           = 3001,     //一级页面, 点击发现TAB底部栏
    LDTPActionID_Find_LV1_BlueLink                      = 3103,     //一级页面, 点击首页蓝色商品链接
    LDTPActionID_Find_LV1_LongText                      = 3104,     //一级页面, 点击长文
    
    LDTPActionID_Mine_LV1_Tab                           = 4001,     //一级页面, 点击我TAB底部栏
    LDTPActionID_Mine_LV1_Feedback                      = 4101,     //一级页面, 点击意见反馈
    LDTPActionID_Mine_LV1_Nick                          = 4102,     //一级页面, 点击头像昵称栏
    LDTPActionID_Mine_LV1_Kid                           = 4103,     //一级页面, 点击孩子信息
    LDTPActionID_Mine_LV1_Index                         = 4104,     //一级页面, 点击我的主页
    LDTPActionID_Mine_LV1_Message                       = 4105,     //一级页面, 点击我的消息
    LDTPActionID_Mine_LV1_Setting                       = 4107,     //一级页面, 点击设置
    
    LDTPActionID_APP_BecomeActive               = 5001,     //打开应用
    LDTPActionID_APP_DidEnterBackground         = 5002,     //切到后台
    
};

typedef NS_OPTIONS(NSUInteger, LDTPSocketTag) {
    LDTPSocketTagUnknow     = 0,        //未知
    LDTPSocketTagConnect,               //连接
    LDTPSocketTagLog                    //打点
};

typedef NS_OPTIONS(NSUInteger, LDTPMessageType) {
    LDTPMessageType_Reserved     = 0,       //
    LDTPMessageType_CS_CONNECT,             //连接
    LDTPMessageType_SC_CONNECTACK,          //认证返回
    LDTPMessageType_CS_LOGACTION,           //打点
};

typedef NS_OPTIONS(NSUInteger, LDTPSocketState) {
    LDTPSocketStateDisconnect       = 0,    //未连接
    LDTPSocketStateConnecting,              //连接中
    LDTPSocketStateConnected,               //已连接未认证
    LDTPSocketStateAuthing,                 //正在认证
    LDTPSocketStateConnectedAndAuth         //已连接已认证
};


NSUInteger LDTPTimeInt();

NSString *LDTPChannelAndVersion();

NSString *LDTPMakeSign(NSUInteger uid,
                       NSUInteger appid,
                       NSString *deviceid,
                       NSString *token,
                       NSString *secret);

NSData * LDTPPackData(LDTPMessageType type, NSData *msg);

NSUInteger LDTPParsePackage(char *buff, int buff_len);

