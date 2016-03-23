//
//  PTReachability.m
//  PTReachability
//
//  Created by KangYang on 16/3/14.
//  Copyright © 2016年 KangYang. All rights reserved.
//

#import "PTReachability.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

#if TARGET_OS_EMBEDDED || TARGET_IPHONE_SIMULATOR
#import <CFNetwork/CFNetwork.h>
#else
#import <CoreServices/CoreServices.h>
#endif

#include <AssertMacros.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <errno.h>

#define kDefaultURL @"www.baidu.com"
#define kDefaultInterval 30

NSString *const kPTReachabilityChangedNotification = @"PTReachabilityChangedNotification";

struct IPHeader {
    uint8_t     versionAndHeaderLength;
    uint8_t     differentiatedServices;
    uint16_t    totalLength;
    uint16_t    identification;
    uint16_t    flagsAndFragmentOffset;
    uint8_t     timeToLive;
    uint8_t     protocol;
    uint16_t    headerChecksum;
    uint8_t     sourceAddress[4];
    uint8_t     destinationAddress[4];
};
typedef struct IPHeader IPHeader;

struct ICMPHeader {
    uint8_t     type;
    uint8_t     code;
    uint16_t    checksum;
    uint16_t    identifier;
    uint16_t    sequenceNumber;
};
typedef struct ICMPHeader ICMPHeader;

static uint16_t in_cksum(const void *buffer, size_t bufferLen) {
    size_t              bytesLeft;
    int32_t             sum;
    const uint16_t *    cursor;
    union {
        uint16_t        us;
        uint8_t         uc[2];
    } last;
    uint16_t            answer;
    
    bytesLeft = bufferLen;
    sum = 0;
    cursor = buffer;
    
    /*
     * Our algorithm is simple, using a 32 bit accumulator (sum), we add
     * sequential 16 bit words to it, and at the end, fold back all the
     * carry bits from the top 16 bits into the lower 16 bits.
     */
    while (bytesLeft > 1) {
        sum += *cursor;
        cursor += 1;
        bytesLeft -= 2;
    }
    
    /* mop up an odd byte, if necessary */
    if (bytesLeft == 1) {
        last.uc[0] = * (const uint8_t *) cursor;
        last.uc[1] = 0;
        sum += last.us;
    }
    
    /* add back carry outs from top 16 bits to low 16 bits */
    sum = (sum >> 16) + (sum & 0xffff);	/* add hi 16 to low 16 */
    sum += (sum >> 16);			/* add carry */
    answer = (uint16_t) ~sum;   /* truncate to 16 bits */
    
    return answer;
}

enum {
    kICMPTypeEchoReply   = 0,
    kICMPTypeEchoRequest = 8
};

@interface PTReachability () {
    CFHostRef _host;
    CFSocketRef _socket;
}

@property (assign, nonatomic) SCNetworkReachabilityRef reachabilityRef;
@property (copy, nonatomic, readwrite) NSData *hostAddress;
@property (nonatomic, assign, readwrite) uint16_t identifier;
@property (nonatomic, assign, readwrite) uint16_t nextSequenceNumber;
@property (assign, nonatomic) BOOL isPinging;
@property (assign, nonatomic) BOOL isAutoing;
@property (assign, nonatomic) PTReachabilityStatus currentStatus;
@property (strong, nonatomic) NSMutableArray *blocks;
@property (strong, nonatomic) NSTimer *autoCheckTimer;

@end

@implementation PTReachability

#pragma mark - life cycle

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    
    struct sockaddr zeroAddr;
    bzero(&zeroAddr, sizeof(zeroAddr));
    zeroAddr.sa_len = sizeof(zeroAddr);
    zeroAddr.sa_family = AF_INET;
    
    _blocks = [[NSMutableArray alloc] init];
    _autoCheckInterval = kDefaultInterval;
    _reachabilityURL = kDefaultURL;
    _reachabilityRef = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *) &zeroAddr);
    self->_identifier = (uint16_t) arc4random();
    
    return self;
}

- (void)dealloc
{
    [self stop];
    [self finishAutoCheck];
}

#pragma mark - public method

+ (instancetype)sharedInstance
{
    static PTReachability *reachability = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        reachability = [[self alloc] init];
    });
    
    return reachability;
}

- (void)reachabilityWithBlock:(PTReachabilityStatusBlock)block
{
    if (![self lc_isReachable]) {
        PTReachabilityStatus previousStatus = self.currentStatus;
        self.currentStatus = PTReachabilityStatusNotReachable;
        
        if (previousStatus != self.currentStatus) {
            [self reachabilityStatusDidChange:previousStatus currentStatus:self.currentStatus];
        }
        
        if (block) {
            block(PTReachabilityStatusNotReachable);
        }
        return;
    }
    
    if (block) {
        @synchronized(self) {
            [self.blocks addObject:block];
        }
    }
    
    [self real_isReachable];
    [self performSelector:@selector(pingTimeOut) withObject:nil afterDelay:2.0];
}

- (void)startAutoCheck
{
    if (self.isAutoing) return;
    
    self.isAutoing = YES;
    
    self.autoCheckTimer = [NSTimer timerWithTimeInterval:self.autoCheckInterval
                                                  target:self
                                                selector:@selector(autoCheckTimerTrigger:)
                                                userInfo:nil
                                                 repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.autoCheckTimer forMode:NSDefaultRunLoopMode];
}

- (void)finishAutoCheck
{
    self.isAutoing = NO;
    
    [self.autoCheckTimer invalidate];
    self.autoCheckTimer = nil;
}

#pragma mark - event response

- (void)autoCheckTimerTrigger:(NSTimer *)sender
{
    [self reachabilityWithBlock:nil];
}

#pragma mark - private method

- (BOOL)lc_isReachable
{
    SCNetworkReachabilityFlags flags;
    if (!SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags)) {
        return NO;
        
    } else if ((flags & kSCNetworkReachabilityFlagsReachable) == 0) {
        return NO;
        
    } else if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0) {
        return YES;
        
    } else if ((flags & kSCNetworkReachabilityFlagsConnectionOnDemand) != 0 ||
               (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0) {
        
        if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)lc_isWIFI
{
    SCNetworkReachabilityFlags flags = 0;
    if (SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags)) {
        if ((flags & kSCNetworkReachabilityFlagsReachable)) {
            if ((flags & kSCNetworkReachabilityFlagsIsWWAN)) {
                return NO;
            }
            return YES;
        }
    }
    return NO;
}

- (BOOL)lc_isWWAN
{
    SCNetworkReachabilityFlags flags = 0;
    if (SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags)) {
        if ((flags & kSCNetworkReachabilityFlagsReachable)) {
            if ((flags & kSCNetworkReachabilityFlagsIsWWAN)) {
                return YES;
            }
        }
    }
    return NO;
}

- (PTReachabilityStatus)lc_currentStatus
{
    if ([self lc_isReachable]) {
        if ([self lc_isWIFI]) {
            return PTReachabilityStatusWiFi;
            
        } else if ([self lc_isWWAN]) {
            return [self lc_WWANType];
            
        } else {
            return PTReachabilityStatusUnknown;
        }
    } else {
        return PTReachabilityStatusNotReachable;
    }
}

- (PTReachabilityStatus)lc_WWANType
{
    NSArray *typeStrings2G = @[CTRadioAccessTechnologyEdge,
                               CTRadioAccessTechnologyGPRS,
                               CTRadioAccessTechnologyCDMA1x];
    
    NSArray *typeStrings3G = @[CTRadioAccessTechnologyHSDPA,
                               CTRadioAccessTechnologyWCDMA,
                               CTRadioAccessTechnologyHSUPA,
                               CTRadioAccessTechnologyCDMAEVDORev0,
                               CTRadioAccessTechnologyCDMAEVDORevA,
                               CTRadioAccessTechnologyCDMAEVDORevB,
                               CTRadioAccessTechnologyeHRPD];
    
    NSArray *typeStrings4G = @[CTRadioAccessTechnologyLTE];
    
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    NSString *accessString = info.currentRadioAccessTechnology;
    if (accessString.length > 0) {
        if ([typeStrings4G containsObject:accessString]) {
            return PTReachabilityStatus4G;
            
        } else if ([typeStrings3G containsObject:accessString]) {
            return PTReachabilityStatus3G;
            
        } else if ([typeStrings2G containsObject:accessString]) {
            return PTReachabilityStatus2G;
        }
    }
    return PTReachabilityStatusUnknown;
}

- (void)real_isReachable
{
    self.isPinging = YES;
    Boolean success;
    CFHostClientContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
    CFStreamError streamError;
    
    self->_host = CFHostCreateWithName(NULL, (__bridge CFStringRef)self.reachabilityURL);
    if (self->_host == NULL) return;
    
    CFHostSetClient(self->_host, HostResolveCallback, &context);
    CFHostScheduleWithRunLoop(self->_host, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    
    success = CFHostStartInfoResolution(self->_host, kCFHostAddresses, &streamError);
    if (!success) {
        [self endWithFlag:NO];
    }
}

static void HostResolveCallback(CFHostRef theHost, CFHostInfoType typeInfo, const CFStreamError *error, void *info)
{
    PTReachability *obj;
    obj = (__bridge PTReachability *)info;
    
    if (([obj isKindOfClass:[PTReachability class]] && typeInfo == kCFHostAddresses))
    {
        if (theHost != obj->_host) return;
        
        if ((error != NULL) && (error->domain != 0)) {
            [obj endWithFlag:NO];
        } else {
            [obj hostResolutionDone];
        }
    }
}

- (void)hostResolutionDone
{
    Boolean resolved;
    NSArray *addresses;
    
    addresses = (__bridge NSArray *)CFHostGetAddressing(self->_host, &resolved);
    if (resolved && (addresses != nil)) {
        resolved = false;
        for (NSData *address in addresses) {
            const struct sockaddr *addrPtr;
            addrPtr = (const struct sockaddr *)[address bytes];
            
            if ([address length] >= sizeof(struct sockaddr) && addrPtr->sa_family == AF_INET) {
                self.hostAddress = address;
                resolved = true;
                break;
            }
        }
    }
    
    [self stopHostResolution];
    
    if (resolved) {
        [self startWithHostAddress];
    } else {
        [self endWithFlag:NO];
    }
}

- (void)stopHostResolution
{
    if (self->_host != NULL) {
        CFHostSetClient(self->_host, NULL, NULL);
        CFHostUnscheduleFromRunLoop(self->_host, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
        CFRelease(self->_host);
        self->_host = NULL;
    }
}

- (void)startWithHostAddress
{
    if (!self.hostAddress) return;
    
    int err;
    int fd;
    const struct sockaddr *addrPtr;
    
    addrPtr = (const struct sockaddr *)[self.hostAddress bytes];
    
    fd = -1;
    err = 0;
    switch (addrPtr->sa_family) {
        case AF_INET: {
            fd = socket(AF_INET, SOCK_DGRAM, IPPROTO_ICMP);
            if (fd < 0) {
                err = errno;
            }
        }
            break;
        case AF_INET6:
        default: {
            err = EPROTONOSUPPORT;
        }
            break;
    }
    
    if (err != 0) {
        [self endWithFlag:NO];
    } else {
        CFSocketContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
        CFRunLoopSourceRef rls;
        
        self->_socket = CFSocketCreateWithNative(NULL, fd, kCFSocketReadCallBack, SocketReadCallback, &context);
        
        fd = -1;
        rls = CFSocketCreateRunLoopSource(NULL, self->_socket, 0);
        CFRunLoopAddSource(CFRunLoopGetCurrent(), rls, kCFRunLoopDefaultMode);
        CFRelease(rls);
        
        [self sendPingWithData:nil];
    }
}

static void SocketReadCallback(CFSocketRef s, CFSocketCallBackType type, CFDataRef address, const void *data, void *info)
{
    PTReachability *obj;
    obj = (__bridge PTReachability *) info;
    
    if (([obj isKindOfClass:[PTReachability class]] && type == kCFSocketReadCallBack))
    {
        if (s == obj->_socket)
        {
            [obj readData];
        }
    }
}

- (void)readData
{
    int err = 0;
    struct sockaddr_storage addr;
    socklen_t addrLen;
    ssize_t bytesRead;
    void * buffer;
    enum { kBufferSize = 65535 };
    
    buffer = malloc(kBufferSize);
    addrLen = sizeof(addr);
    bytesRead = recvfrom(CFSocketGetNative(self->_socket), buffer, kBufferSize, 0, (struct sockaddr *)&addr, &addrLen);
    
    if (bytesRead < 0) {
        err = errno;
    }
    
    if (bytesRead > 0) {
        NSMutableData *packet;
        packet = [NSMutableData dataWithBytes:buffer length:(NSUInteger)bytesRead];
        
        if ([self isValidPingResponsePacket:packet]) {
            [self endWithFlag:YES];
        } else {
            [self endWithFlag:NO];
        }
    } else {
        if (err == 0) {
            err = EPIPE;
        }
    }
    
    free(buffer);
}

- (BOOL)isValidPingResponsePacket:(NSMutableData *)packet
{
    BOOL result;
    NSUInteger icmpHeaderOffset;
    ICMPHeader *icmpPtr;
    uint16_t receivedChecksum;
    uint16_t calcuatedChecksum;
    
    result = NO;
    
    icmpHeaderOffset = [[self class] icmpHeaderOffsetInPacket:packet];
    if (icmpHeaderOffset != NSNotFound) {
        icmpPtr = (struct ICMPHeader *)(((uint8_t *)[packet mutableBytes]) + icmpHeaderOffset);
        
        receivedChecksum = icmpPtr->checksum;
        icmpPtr->checksum = 0;
        calcuatedChecksum = in_cksum(icmpPtr, [packet length] - icmpHeaderOffset);
        icmpPtr->checksum = receivedChecksum;
        
        if (receivedChecksum == calcuatedChecksum) {
            if ((icmpPtr->type == kICMPTypeEchoReply) && (icmpPtr->code == 0)) {
                if (OSSwapBigToHostInt16(icmpPtr->identifier) == self.identifier) {
                    if (OSSwapBigToHostInt16(icmpPtr->sequenceNumber) < self.nextSequenceNumber) {
                        result = YES;
                    }
                }
            }
        }
    }
    return result;
}

+ (NSUInteger)icmpHeaderOffsetInPacket:(NSData *)packet
{
    NSUInteger              result;
    const struct IPHeader * ipPtr;
    size_t                  ipHeaderLength;
    
    result = NSNotFound;
    if ([packet length] >= (sizeof(IPHeader) + sizeof(ICMPHeader))) {
        ipPtr = (const IPHeader *) [packet bytes];
        ipHeaderLength = (ipPtr->versionAndHeaderLength & 0x0F) * sizeof(uint32_t);
        if ([packet length] >= (ipHeaderLength + sizeof(ICMPHeader))) {
            result = ipHeaderLength;
        }
    }
    return result;
}

- (void)sendPingWithData:(NSData *)data
{
    int err;
    NSData *payload;
    NSMutableData *packet;
    ICMPHeader *icmpPtr;
    ssize_t bytesSent;
    
    payload = data;
    if (payload == nil) {
        payload = [[NSString stringWithFormat:@"%28zd bottles of beer on the wall",(ssize_t) 99 - (size_t) (self.nextSequenceNumber % 100)] dataUsingEncoding:NSASCIIStringEncoding];
    }
    
    packet = [NSMutableData dataWithLength:sizeof(*icmpPtr) + [payload length]];
    
    icmpPtr = [packet mutableBytes];
    icmpPtr->type = kICMPTypeEchoRequest;
    icmpPtr->code = 0;
    icmpPtr->checksum = 0;
    icmpPtr->identifier = OSSwapHostToBigInt16(self.identifier);
    icmpPtr->sequenceNumber = OSSwapHostToBigInt16(self.nextSequenceNumber);
    memcpy(&icmpPtr[1], [payload bytes], [payload length]);
    
    icmpPtr->checksum = in_cksum([packet bytes], [packet length]);
    
    if (self->_socket == NULL) {
        bytesSent = -1;
        err = EBADF;
    } else {
        bytesSent = sendto(CFSocketGetNative(self->_socket),
                           [packet bytes],
                           [packet length],
                           0,
                           (struct sockaddr *)[self.hostAddress bytes],
                           (socklen_t)[self.hostAddress length]);
        err = 0;
        if (bytesSent < 0) {
            err = errno;
        }
    }
    
    if ((bytesSent > 0) && (((NSUInteger)bytesSent) == [packet length])) {
        
    } else {
        NSError *error;
        if (err == 0) {
            err = ENOBUFS;
        }
        error = [NSError errorWithDomain:NSPOSIXErrorDomain code:err userInfo:nil];
        [self endWithFlag:NO];
    }
    
    self.nextSequenceNumber += 1;
}

- (void)stopDataTransfer
{
    if (self->_socket != NULL) {
        CFSocketInvalidate(self->_socket);
        CFRelease(self->_socket);
        self->_socket = NULL;
    }
}

//网络检测结束后调用此方法，通过block返回结果，block置为nil解除retain cycle
- (void)endWithFlag:(BOOL)isSuccess
{
    if (!self.isPinging) return;
    self.isPinging = NO;
    
    [self stop];
    
    PTReachabilityStatus previousStatus = self.currentStatus;
    self.currentStatus = isSuccess ? [self lc_currentStatus] : PTReachabilityStatusNotReachable;
    
    if (previousStatus != self.currentStatus) {
        [self reachabilityStatusDidChange:previousStatus currentStatus:self.currentStatus];
    }
    
    @synchronized(self) {
        for (PTReachabilityStatusBlock block in self.blocks) {
            block(self.currentStatus);
        }
        [self.blocks removeAllObjects];
    }
}

- (void)stop
{
    [self stopHostResolution];
    [self stopDataTransfer];
    
    if (self.reachabilityURL != nil) {
        self.hostAddress = NULL;
    }
}

- (void)pingTimeOut
{
    [self endWithFlag:NO];
}

- (void)reachabilityStatusDidChange:(PTReachabilityStatus)previous currentStatus:(PTReachabilityStatus)current
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kPTReachabilityChangedNotification
                                                        object:nil
                                                      userInfo:@{@"last": @(previous),
                                                                 @"now": @(current)}];
}

#pragma mark - setter

- (void)setAutoCheckInterval:(float)autoCheckInterval
{
    if (autoCheckInterval > 5) {
        _autoCheckInterval = autoCheckInterval;
    }
}

@end
