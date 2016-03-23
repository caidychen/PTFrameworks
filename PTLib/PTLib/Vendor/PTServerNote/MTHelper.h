//
//  MTHelper.h
//  PTLatitude
//
//  Created by LiLiLiu on 15/12/16.
//  Copyright © 2015年 PT. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 消息传输协议 MT V0.1.doc 
 * 头部解析命名规则: C(Client)  S(Service)  
 *                CS(客户端发起给服务器)  SC(服务器端发起给客户端)
 */

//读写 Socket 包的 tag名
typedef NS_OPTIONS(NSUInteger, MTSocketTag) {
    MTSocketTagUnknow     = 0,        //未知
    MTSocketTagCSConnect,             //客户端发起连接服务端
    MTSocketTagSCConnectAck,          //服务端给客户端确认连接的应答
    MTSocketTagSCNotice,              //服务器给客户端推送消息
    MTSocketTagCSNoticeAck,             //服务器在推送后，客户端发的确认
    MTSocketTagCSPingQeq,             //客户端主动给服务器ping
    MTSocketTagSCPingResp             //服务端给客户端的ping的应答
};

//解包 Socket 中数据的类型
typedef NS_OPTIONS(NSUInteger, MTMessageType) {
    MTMessageType_Reserved     = 0,       //
    MTMessageType_CS_CONNECT,             //客户端发起连接服务端(连接)
    MTMessageType_SC_CONNECTACK,          //服务端给客户端的应答(认证返回)
    MTMessageType_SC_NOTICE,              //服务器给客户端推送消息
    MTMessageType_CS_NOTICEACK,           //服务器在推送后，客户端发的确认
    MTMessageType_CS_PINGREQ,             //客户端主动给服务器ping
    MTMessageType_SC_PINGRESP,            //服务端给客户端的ping的应答
    MTMessageType_CS_PUBLISH              //消息发布(APP端暂时不需要使用此字段)
};

typedef NS_OPTIONS(NSUInteger, MTSocketState) {
    MTSocketStateDisconnect       = 0,    //未连接
    MTSocketStateConnecting,              //连接中
    MTSocketStateConnected,               //已连接未认证
    MTSocketStateAuthing,                 //正在认证
    MTSocketStateConnectedAndAuth         //已连接已认证
};


//获取当前系统时间
NSUInteger MTTimeInt();

//生成协议链接时需要的签名  sign
//见文档 CS_CONNECT
NSString *MTMakeSign(NSUInteger appid,
                       NSString *deviceid,
                       NSString *secret);

//解包信息 协议返回的头信息
NSData * MTPackData(MTMessageType type, NSData *msg);


//解析 头信息 (不带粘包处理)
NSArray * MTParsePackage(char *buff, int buff_len);


//解析 头信息 (带粘包处理)
NSArray * MTParsePackageInPackSize(char *buff, uint32_t buff_len);




