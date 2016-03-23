//
//  PTLDTPManager.m
//  PTAsyncSocket
//
//  Created by so on 15/8/12.
//  Copyright (c) 2015年 so. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <netdb.h>
#import <arpa/inet.h>
#import "PTLDTPManager.h"
#import "GCDAsyncSocket.h"
#import "MPMessagePack.h"
#import "LDTPLogCache.h"
#import "LDTPAuthItem.h"
#import "LDTPMessageItem.h"
#import "PTUtilTool.h"

#define PT_LDTP_APP_ID      613             //appid

#if DEBUG_APP
#define PT_LDTP_HOST        @"behavior.collect.putaocloud.com"   //地址
#define PT_LDTP_PORT        10080               //端口
#else
#define PT_LDTP_HOST        @"10.1.11.31"   //地址
#define PT_LDTP_PORT        8082           //端口
#endif

//根据域名获取ip地址
NSString *PTGetIPWithHostName(const NSString *hostName) {
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


@interface PTLDTPManager () {
    GCDAsyncSocket *_socket;
}
@property (copy, nonatomic) LDTPAuthItem *authItem;
@property (assign, nonatomic) LDTPSocketState socketState;
@property (strong, nonatomic) LDTPLogCache *logCache;

@property (copy, nonatomic) NSString *host;
@property (assign, nonatomic) NSUInteger port;

@property (strong, nonatomic) NSDate *date;

+ (instancetype)manager;
+ (void)actionWithMessageItem:(LDTPMessageItem *)item;
- (void)actionWithActionID:(NSUInteger)actionid;
- (void)actionWithMessageItem:(LDTPMessageItem *)item;

@end

@implementation PTLDTPManager
@synthesize host = _host;

+ (instancetype)manager {
    static PTLDTPManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[PTLDTPManager alloc] init];
    });
    return (_manager);
}

+ (void)setUpManager {
    User *user = [[PTUserManager sharedInstance] user];
    NSInteger uid = [user.userID integerValue];
    NSString *deviceid = user.userDeviceID ? : [PTUtilTool getDeviceID];
    
    //暂不传token
    NSString *token = @"";//user.userToken;
    
    LDTPAuthItem *authItem = [LDTPAuthItem itemWithUID:uid
                                                 appID:PT_LDTP_APP_ID
                                              deviceID:deviceid
                                                 token:token];
    [[self manager] setAuthItem:authItem];
}

+ (void)actionWithActionID:(NSUInteger)actionid {
    [[self manager] actionWithActionID:actionid];
}

+ (void)actionWithActionID:(NSUInteger)actionid type:(NSString *)type {
    [[self manager] actionWithActionID:actionid type:type];
}

+ (void)actionWithActionID:(NSUInteger)actionid operateID:(NSString *)operateid {
    [[self manager] actionWithActionID:actionid operateID:operateid];
}

+ (void)actionWithActionID:(NSUInteger)actionid type:(NSString *)type operateID:(NSString *)operateid {
    [[self manager] actionWithActionID:actionid type:type operateID:operateid];
}

+ (void)actionWithMessageItem:(LDTPMessageItem *)item {
    [[self manager] actionWithMessageItem:item];
}

- (void)dealloc {
    [self removeNotifications];
    [self disConnect];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        self.host = PT_LDTP_HOST;
        self.port = PT_LDTP_PORT;
        self.date = [NSDate date];
        self.socketState = LDTPSocketStateDisconnect;
        _logCache = [[LDTPLogCache alloc] init];
        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        [self addNotifications];
    }
    return (self);
}

#pragma mark - setter
- (void)setHost:(NSString *)host {
    if(host && [host rangeOfString:@".com"].length > 0) {
        _host = [PTGetIPWithHostName(host) copy];
    } else {
        _host = [host copy];
    }
}

- (void)setSocketState:(LDTPSocketState)socketState {
    _socketState = socketState;
    //NSLog(@">>>打点 socket state:%@", @(_socketState));
    //认证成功后检查一次
    if(self.socketState == LDTPSocketStateConnectedAndAuth) {
        [self checkCache];
    }
}
#pragma mark -

#pragma mark - action
//NOTI_LOGIN
- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:[self class] name:NOTI_LOGIN object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:[self class] name:NOTI_LOGOUT object:nil];
}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:[self class] selector:@selector(setUpManager) name:NOTI_LOGIN object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:[self class] selector:@selector(setUpManager) name:NOTI_LOGOUT object:nil];
}

//建立连接
- (void)connect {
    if([_socket isConnected]) {
        return;
    }
    NSError *error = nil;
    BOOL res = [_socket connectToHost:self.host onPort:self.port error:&error];
    if(res) {
        self.socketState = LDTPSocketStateConnecting;
    } else {
        self.socketState = LDTPSocketStateDisconnect;
    }
}

//断开连接
- (void)disConnect {
    if([_socket isConnected]) {
        [_socket disconnectAfterReadingAndWriting];
    }
}

//传递事件
- (void)actionWithMessageItem:(LDTPMessageItem *)item {
    [self cacheLogItem:item];
    switch (self.socketState) {
        case LDTPSocketStateDisconnect:{
            [self connect];
        }break;
        case LDTPSocketStateConnecting:{
            
        }break;
        case LDTPSocketStateConnected:{
            [self authConnect];
        }break;
        case LDTPSocketStateAuthing:{
            
        }break;
        case LDTPSocketStateConnectedAndAuth:{
            [self checkCache];
        }break;
        default:break;
    }
}

- (void)actionWithActionID:(NSUInteger)actionid {
    LDTPMessageItem *item = [LDTPMessageItem itemWithActionID:actionid
                                                      timeInt:LDTPTimeInt()
                                                        info1:LDTPChannelAndVersion()
                                                        info2:@""
                                                        info3:@""
                                                        info4:@""
                                                        info5:@""];
    [self actionWithMessageItem:item];
}

- (void)actionWithActionID:(NSUInteger)actionid type:(NSString *)type {
    LDTPMessageItem *item = [LDTPMessageItem itemWithActionID:actionid
                                                      timeInt:LDTPTimeInt()
                                                        info1:LDTPChannelAndVersion()
                                                        info2:@""
                                                        info3:type
                                                        info4:@""
                                                        info5:@""];
    [self actionWithMessageItem:item];
}

- (void)actionWithActionID:(NSUInteger)actionid operateID:(NSString *)operateID {
    LDTPMessageItem *item = [LDTPMessageItem itemWithActionID:actionid
                                                      timeInt:LDTPTimeInt()
                                                        info1:LDTPChannelAndVersion()
                                                        info2:operateID
                                                        info3:@""
                                                        info4:@""
                                                        info5:@""];
    [self actionWithMessageItem:item];
}

- (void)actionWithActionID:(NSUInteger)actionid type:(NSString *)type operateID:(NSString *)operateID {
    LDTPMessageItem *item = [LDTPMessageItem itemWithActionID:actionid
                                                      timeInt:LDTPTimeInt()
                                                        info1:LDTPChannelAndVersion()
                                                        info2:operateID
                                                        info3:type
                                                        info4:@""
                                                        info5:@""];
    [self actionWithMessageItem:item];
}

//认证
- (void)authConnect {
    NSData *packData = [self.authItem messagePackData];
    NSData *data = LDTPPackData(LDTPMessageType_CS_CONNECT, packData);
    [_socket writeData:data withTimeout:-1 tag:LDTPSocketTagConnect];
    [_socket readDataWithTimeout:-1 tag:LDTPSocketTagConnect];
    self.socketState = LDTPSocketStateAuthing;
}

//发送日志
- (void)sendLogItem:(LDTPMessageItem *)item {
    NSData *data = LDTPPackData(LDTPMessageType_CS_LOGACTION, [item messagePackData]);
    [_socket writeData:data withTimeout:-1 tag:LDTPSocketTagLog];
}

//缓存日志
- (void)cacheLogItem:(LDTPMessageItem *)item {
    [self.logCache cacheItem:item];
}

//检查缓存
- (void)checkCache {
    __weak typeof(self) weak_self = self;
    [self.logCache getTopItemWithBlock:^(id obj) {
        if(obj && [obj isKindOfClass:[LDTPMessageItem class]]) {
            [weak_self performSelectorOnMainThread:@selector(sendLogItem:) withObject:obj waitUntilDone:NO];
        }
    }];
}
#pragma mark -

#pragma mark - notifications
- (void)appDidEnterBackground:(NSNotification *)notification {
    NSTimeInterval dt = 0;
    if(self.date) {
        dt = [[NSDate date] timeIntervalSinceDate:self.date];
    }
    LDTPMessageItem *item = [LDTPMessageItem itemWithActionID:5003
                                                      timeInt:LDTPTimeInt()
                                                        info1:LDTPChannelAndVersion()
                                                        info2:@""
                                                        info3:@""
                                                        info4:[@((NSUInteger)dt) stringValue]
                                                        info5:@""];
    
    [self actionWithMessageItem:item];
}

- (void)appDidBecomeActive:(NSNotification *)notfication {
    [self actionWithActionID:LDTPActionID_APP_BecomeActive];
    self.date = [NSDate date];
}
#pragma mark -

#pragma mark - <GCDAsyncSocketDelegate>
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
    self.socketState = LDTPSocketStateConnected;
    [self authConnect];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    if(tag == LDTPSocketTagLog) {
        [self checkCache];
    }
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    char *buff = (char *)[data bytes];
    NSUInteger rt = LDTPParsePackage(buff, (int)[data length]);
    self.socketState = (rt == 49) ? LDTPSocketStateConnectedAndAuth : LDTPSocketStateConnected;
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    self.socketState = LDTPSocketStateDisconnect;
}
#pragma mark -

@end

