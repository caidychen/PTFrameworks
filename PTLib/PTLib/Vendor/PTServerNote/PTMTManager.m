//
//  PTMTManager.m
//  PTLatitude
//
//  Created by LiLiLiu on 15/12/16.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTMTManager.h"
#import <netdb.h>
#import <arpa/inet.h>
#import "GCDAsyncSocket.h"

//Model
#import "MPMessagePack.h"
#import "MTAuthItem.h"
#import "MTCSNoticeAckItem.h"
#import "PTUserMessageNotifyBadgeItem.h"
#import "NSString+JSONCatrgory.h"

#import "PTGameListItem.h"
#import "UserDefaultsHelper.h"

//Controller
#import "PTUtilTool.h"
#import "PTUserManager.h"

#define PT_MT_APP_ID      612             //appid
#define PING_INTERVAL     30              //发送ping的间隔60
#define PTMT_LOG          1               //是否输出接收数据的日志

#define MSG_HEAD_SIZE     6               //协议规定的一个消息头部的长度

#if DEBUG_APP
#define PT_MT_HOST        @"notice.putao.com"//@"122.226.100.152"   //地址
#define PT_MT_PORT        8040               //端口
#else
#define PT_MT_HOST        @"10.1.11.31"   //地址
#define PT_MT_PORT        8083            //端口
#endif



//根据域名获取ip地址
NSString *PTMTGetIPWithHostName(const NSString *hostName) {
    const char * charHostName = [hostName cStringUsingEncoding:NSUTF8StringEncoding];
    struct hostent *host_entry = gethostbyname(charHostName);
    char IPStr[64] = {0};
    if(host_entry !=0){
        sprintf(IPStr, "%d.%d.%d.%d",
                (host_entry->h_addr_list[0][0] & 0x00ff),
                (host_entry->h_addr_list[0][1] & 0x00ff),
                (host_entry->h_addr_list[0][2] & 0x00ff),
                (host_entry->h_addr_list[0][3] & 0x00ff));
    }
    NSString *host = [NSString stringWithCString:IPStr encoding:NSUTF8StringEncoding];
    return (host);
}






@interface PTMTManager (){
    GCDAsyncSocket *_socket;
}
@property (copy, nonatomic) MTAuthItem *authItem;
@property (assign, nonatomic) MTSocketState socketState;

@property (copy, nonatomic) NSString *host;
@property (assign, nonatomic) NSUInteger port;

+ (instancetype)manager;

@end


@implementation PTMTManager


@synthesize host = _host;

+ (instancetype)manager {
    static PTMTManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[PTMTManager alloc] init];
    });
    return (_manager);
}

+ (void)setUpManager {
   
    //初始化红点提醒 相关点击状态
    [self initGameListTouchStateDic];
    
    User *user = [[PTUserManager sharedInstance] user];
    //    NSString *deviceid = user.userDeviceID ? : [PTUtilTool getDeviceID];
    NSString *deviceid = user.userID;   //与 韩锋阳 约定传用户 id
    
    MTAuthItem *authItem = [MTAuthItem itemWithDeviceID:deviceid appID:PT_MT_APP_ID];
    [[self manager] setAuthItem:authItem];
    
    //此时 _socket 对象创建成功，
    //设置完客户端发起连接服务器认证信息 CS_CONNECT,authItem 认证信息
    //链接服务器
    [[self manager] connect];
}

//每次进入 陪伴页面，初始化陪伴页面 游戏图标点击状态列表
+ (void)initGameListTouchStateDic{
    NSMutableString *noticeJsonString = [[NSMutableString alloc] init];
    
    [noticeJsonString appendString:@"{\"601\":0,\"602\":0,\"603\":0,\"7000\":0,\"8000\":0,\"8001\":0,\"8002\":0}"];
    
    NSString *pushData = [NSString stringWithString:noticeJsonString];
    if (pushData){
        NSDictionary *dictData = [pushData JSONObj];
        
        [UserDefaultsHelper setDictForKey:dictData key:GAME_CELL_TOUCH_STATU];
    }
}

- (void)dealloc {
    [self removeNotifications];
    [self disConnect];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        self.host = PT_MT_HOST;
        self.port = PT_MT_PORT;
        self.socketState = MTSocketStateDisconnect;
        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        [self addNotifications];
    }
    return (self);
}

#pragma mark - setter
- (void)setHost:(NSString *)host {
    if(host && [host rangeOfString:@".com"].length > 0) {
        _host = [PTMTGetIPWithHostName(host) copy];
    } else {
        _host = [host copy];
    }
    
//    NSLog(@"--------Host : %@:%zd",_host,PT_MT_PORT);
}

- (void)setSocketState:(MTSocketState)socketState {
    _socketState = socketState;
    //    NSLog(@">>>MT消息 Socket state:%@", @(_socketState));
}
#pragma mark -



#pragma mark - action
//NOTI_LOGIN
- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}


//建立连接
- (void)connect {
    if([_socket isConnected]) {
        return;
    }
    NSError *error = nil;
    BOOL res = [_socket connectToHost:self.host onPort:self.port error:&error];
    if(res) {
        self.socketState = MTSocketStateConnecting;
    } else {
        self.socketState = MTSocketStateDisconnect;
    }
}


//断开连接
- (void)disConnect {
    if([_socket isConnected]) {
        [_socket disconnectAfterReadingAndWriting];
    }
}


//连接成功,认证
- (void)authConnect {
    NSData *packData = [self.authItem messagePackData];
    NSData *data = MTPackData(MTMessageType_CS_CONNECT, packData);
    [_socket writeData:data withTimeout:-1 tag:MTSocketTagCSConnect];
    [_socket readDataWithTimeout:-1 tag:MTSocketTagCSConnect]; //-1则认为永不超时
    self.socketState = MTSocketStateAuthing;
}

//发送日志
- (void)sendLogItem:(MTCSNoticeAckItem *)item {
    NSData *data = MTPackData(MTMessageType_CS_NOTICEACK, [item messagePackData]);
    //调用 <GCDAsyncSocketDelegate>  didWriteDataWithTag 方法
    [_socket writeData:data withTimeout:-1 tag:MTSocketTagCSNoticeAck];
}

//ping 方法
- (void)delayPing {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(pingService) object:nil];
    [self performSelector:@selector(pingService) withObject:nil afterDelay:PING_INTERVAL];
}

- (void)pingService{
    //判断状态、重连接
    if(![_socket isConnected]) {
        [self connect];
        return;
    }
    
    NSData *pingData = MTPackData(MTMessageType_CS_PINGREQ, nil);
    [_socket writeData:pingData withTimeout:-1 tag:MTSocketTagCSPingQeq];
    
    //保持心跳
    [self delayPing];
}
#pragma mark -



#pragma mark - notifications
- (void)appDidEnterBackground:(NSNotification *)notification {
    //
}

- (void)appDidBecomeActive:(NSNotification *)notfication {
    //这里应该检查 Socket 链接状态
}
#pragma mark -

#pragma mark - <GCDAsyncSocketDelegate>
//连接成功的代理
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
    self.socketState = MTSocketStateConnected;
    [self authConnect];
}

//数据成功发送给服务器
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    if (tag == MTSocketTagCSNoticeAck) {
//        NSLog(@"MT CSNoticeAck");
    }
    
    if (tag == MTSocketTagCSPingQeq) {
//        NSLog(@"MT Ping");
        [_socket readDataWithTimeout:-1 tag:MTSocketTagSCNotice]; //-1则认为永不超时
    }
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSUInteger msgId = 0;
    NSMutableArray *badgeArr = [[NSMutableArray alloc] init];
    NSInteger noticeNumber = 0;
    NSInteger answerNumber = 0;
    NSInteger praiseNumber = 0;
    NSInteger remindNumber = 0;
    
    NSLog(@"------------接收到的数据长度 : %zd",data.length);
    
    //对接收的数据进行 粘包 处理 1024*1024 = 1048576
    if (data.length > 1048576 && data.length < 6) {
        return;
    }
    
    //获取到返沪数据的初始指针位置
    char *p = (char *)[data bytes];
    
    //每个包的开始、结束地址
//        unsigned long start = (unsigned long)((char *)[data bytes]);
    unsigned long end = (unsigned long)((char *)[data bytes] + data.length);
   
#if PTMT_LOG
    char *f = p;
    while ((unsigned long)f < end) {
        printf("%d ",(int)*f++);
    }
    printf("\n");
#endif
    
    
    
    while ((unsigned long)p < end) {
        NSArray* pushDataArr = nil;     //一个包里面的信息
        
        //取头部第一个字节,作为消息类型
        uint8_t type = *p;
//        NSLog(@"------------这个就是协议中的类型 msgType : %d  ",type);
        
        if (type > 7) {
            break;
        }
        
        //取出头部第 3-6 字节数据，转成 uint32_t ,作为内容长度
        uint32_t nPackSize = *(uint32_t *)(p + 2);
        if (nPackSize > 0) {
            //如果内容长度大于 0 说明内容存在
            pushDataArr = MTParsePackageInPackSize(p+MSG_HEAD_SIZE, nPackSize);
        }
        
        
        msgId = [[pushDataArr firstObject] unsignedIntValue];
        //判断是否登录成功
        self.socketState = (msgId == 49) ? MTSocketStateConnectedAndAuth : MTSocketStateConnected;
    
        switch (type) {
            case MTSocketTagUnknow:{
//                NSLog(@"---0 Reserved");
            }break;
            case MTSocketTagCSConnect:{
//                NSLog(@"---1 连接成功,下次再 read 肯定是 notice");
            }break;
            case MTSocketTagSCConnectAck:{
//                NSLog(@"---2 服务端给客户端的应答");
                //启动心跳
                if (self.socketState == MTSocketStateConnectedAndAuth) {
                    [self delayPing];
                }
            }break;
            case MTSocketTagSCNotice:{
//                NSLog(@"---3 服务器给客户端推送消息");
                if (msgId != 49) {
                    NSString *pushData = (NSString *)[pushDataArr safeObjectAtIndex:1];
                    NSLog(@"---3 pushData : %@ ",pushData);
                    if (pushData){
                        NSDictionary *dictData = [pushData JSONObj];
                        //处理完数据后,再发送广播
                        PTUserMessageNotifyBadgeItem *badgeItem = [PTUserMessageNotifyBadgeItem itemWithDict:dictData];
                        [badgeArr addObject:badgeItem];
                    }
                }
                
                
                //回复消息服务器，确认收到该消息
                MTCSNoticeAckItem *noticeAckItem = [[MTCSNoticeAckItem alloc] init];
                noticeAckItem.msgId = msgId;
                NSData *packData = [noticeAckItem messagePackData];
                NSData *data = MTPackData(MTMessageType_CS_NOTICEACK, packData);
                [_socket writeData:data withTimeout:-1 tag:MTSocketTagCSNoticeAck];
                
                [_socket readDataWithTimeout:-1 tag:MTSocketTagSCNotice]; //-1则认为永不超时
            }break;
            case MTSocketTagCSNoticeAck:{
//                NSLog(@"---4 服务器在推送后，客户端发的确认");
            }break;
            case MTSocketTagCSPingQeq:{
//                NSLog(@"---5 客户端主动给服务器ping");
                [_socket readDataWithTimeout:-1 tag:MTSocketTagSCNotice]; //-1则认为永不超时
            }break;
            case MTSocketTagSCPingResp:{}break;
            default:
                break;
        }
        
        
        p += nPackSize + MSG_HEAD_SIZE;
    }
    
    //这里对结果进行解析,确保推送广播只发出一次
    if (badgeArr && badgeArr.count > 0) {
        
        //新增过滤 一次性推送过来的多条 appProduct_id
        NSMutableArray *productIDArr = [self filterWithArray:badgeArr];
        
        for (PTUserMessageNotifyBadgeItem *tempItem in badgeArr) {
            if (tempItem.messageCenter_notice) {
                noticeNumber += 1;
            }
            if (tempItem.messageCenter_reply) {
                answerNumber += 1;
            }
            if (tempItem.messageCenter_praise) {
                praiseNumber += 1;
            }
            if (tempItem.messageCenter_remind) {
                remindNumber += 1;
            }
        }
        
        //    {"location_dot":{"me_tabbar":1,"me_messageCenter":1,"messageCenter_notice":1,"messageCenter_reply":1,"messageCenter_praise":1,"appProduct_id":601}}
        
        for (PTUserMessageNotifyBadgeItem *tempItem in productIDArr) {
            NSMutableString *noticeJsonString = [[NSMutableString alloc] init];
            [noticeJsonString appendString:@"{\"location_dot\":{"];
            [noticeJsonString appendString:[NSString stringWithFormat:@"%@%@,",@"\"appProduct_id\":",tempItem.appProduct_id]];
            
            if (noticeNumber > 0) {
                [noticeJsonString appendString:@"\"messageCenter_notice\":1,"];
            }else{
                [noticeJsonString appendString:@"\"messageCenter_notice\":0,"];
            }
            
            if (answerNumber > 0) {
                [noticeJsonString appendString:@"\"messageCenter_reply\":1,"];
            }else{
                [noticeJsonString appendString:@"\"messageCenter_reply\":0,"];
            }
            
            if (praiseNumber > 0) {
                [noticeJsonString appendString:@"\"messageCenter_praise\":1,"];
            }else{
                [noticeJsonString appendString:@"\"messageCenter_praise\":0,"];
            }
            
            if (remindNumber > 0) {
                [noticeJsonString appendString:@"\"messageCenter_remind\":1,"];
            }else{
                [noticeJsonString appendString:@"\"messageCenter_remind\":0,"];
            }
            
            if ((noticeNumber+answerNumber+praiseNumber+remindNumber) > 0) {
                [noticeJsonString appendString:@"\"me_tabbar\":1,\"me_messageCenter\":1}}"];
            }else{
                [noticeJsonString appendString:@"\"me_tabbar\":0,\"me_messageCenter\":0}}"];
            }

//            NSLog(@"最终解析出来 json : %@ ",[NSString stringWithString:noticeJsonString]);
            
            if (tag == MTSocketTagSCNotice) {
                if (msgId != 49) {
                    NSString *pushData = [NSString stringWithString:noticeJsonString];
                    //模拟陪伴红点数据
//                    NSString *pushData = @"{\"location_dot\":{\"me_tabbar\":1,\"me_messageCenter\":1,\"messageCenter_notice\":1,\"messageCenter_reply\":0,\"messageCenter_praise\":0,\"messageCenter_remind\":0,\"appProduct_id\":601}}";
                    if (pushData){
                        NSDictionary *dictData = [pushData JSONObj];
                        //发送广播
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_UPDATE_BADGE object:@"badge" userInfo:dictData];
//                        NSLog(@"--------发送广播--------");
                    }
                }
            }
        }
        
    }
}

//连接结束的代理
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    self.socketState = MTSocketStateDisconnect;
}

#pragma mark -





#pragma mark - private Method
- (NSMutableArray *)filterWithArray:(NSMutableArray *)arr{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    //过滤 appProduct_id
    NSMutableString *tempTime = [[NSMutableString alloc] init];
    for (PTUserMessageNotifyBadgeItem *tempItem in arr) {
        
        if (tempTime.length == 0) {
            if (tempItem.appProduct_id) {
                [tempTime appendString:tempItem.appProduct_id];
            }else{
                [tempTime appendString:@"0"];
                tempItem.appProduct_id = @"0";
            }
            
            [tempArray safeAddObject:tempItem];
        }else{
            NSString *timeStr = [NSString stringWithString:tempTime];
            [tempTime deleteCharactersInRange: NSMakeRange(0, timeStr.length)];
            if (!tempItem.appProduct_id) {
                tempItem.appProduct_id = @"0";
            }
            
            [tempTime appendString:tempItem.appProduct_id];
            
            if (![tempTime isEqualToString:timeStr]) {
                [tempArray safeAddObject:tempItem];
            }
        }
    }
    
    return tempArray;
}
#pragma mark -

@end
