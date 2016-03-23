//
//  PTWXPayRequest.m
//  PTLatitude
//
//  Created by zhangyi on 16/3/1.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTWXPayRequest.h"
#import "PTWXPayResultItem.h"
#import "PTWXPay.h"

@interface PTWXPayRequest ()

@property (strong, nonatomic, readonly) AFHTTPRequestOperationManager *requestOperationManager;
@property (nonatomic, copy) NSString *orderId;

@end

@implementation PTWXPayRequest
@synthesize requestOperationManager = _requestOperationManager;


+ (instancetype)initWXPayRequest {
    static PTWXPayRequest *paRequest = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        paRequest = [[self alloc] init];
    });
    return (paRequest);
}

+ (void)payWithBaseUrl:(NSString *)baseUrl
               orderId:(NSString *)orderId
                   uid:(NSString *)uid
             userToken:(NSString *)token
               success:(PTWXPayRequestSuccessBlock)success
               failure:(PTWXPayRequestFailureBlock)failure {
    [[self initWXPayRequest] requestWithBaseUrl:baseUrl orderId:orderId uid:uid userToken:token success:success failure:failure];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        
    }
    return (self);
}

#pragma mark --
- (AFHTTPRequestOperationManager *)requestOperationManager {
    if(!_requestOperationManager) {
        _requestOperationManager = [[AFHTTPRequestOperationManager alloc] init];
        _requestOperationManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [_requestOperationManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _requestOperationManager.requestSerializer.timeoutInterval = 30.f;
        [_requestOperationManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        _requestOperationManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _requestOperationManager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:
                                                                              @"application/json",
                                                                              @"application/soap+xml",
                                                                              @"text/html",
                                                                              @"text/xml",
                                                                              @"text/json",
                                                                              @"text/javascript", nil];
    }
    return (_requestOperationManager);
}

#pragma mark -
- (AFHTTPRequestOperation *)requestWithBaseUrl:(NSString *)baseUrl
                                       orderId:(NSString *)orderId
                                           uid:(NSString *)uid
                                     userToken:(NSString *)token
                                       success:(PTWXPayRequestSuccessBlock)success
                                       failure:(PTWXPayRequestFailureBlock)failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if(orderId && [orderId length] > 0) {
        [parameters safeSetObject:orderId forKey:@"order_id"];
    }
    if(uid && [uid length] > 0) {
        [parameters safeSetObject:uid forKey:@"uid"];
    }
    if(token && [token length] > 0) {
        [parameters safeSetObject:token forKey:@"token"];
    }
    [parameters safeSetObject:@"WX_APP" forKey:@"payment_type"];
    
    
    AFHTTPRequestOperation *operation = [[self requestOperationManager]
                                         GET:baseUrl
                                         parameters:parameters
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             if(success) {
                                                 NSInteger status = [[responseObject safeNumberForKey:KEY_PTDEFAULT_STATUS] integerValue];
                                                 if (status == 200) {
                                                     
                                                     NSDictionary *dic = [responseObject objectForKey:KEY_PTDEFAULT_DATA];
                                                     NSDictionary *code = [dic objectForKey:@"code"];
                                                     
                                                     PTWXPayResultItem *item = [PTWXPayResultItem itemWithDict:code];
                                                     [PTWXPay payWithOrderString:item result:^(PTWXPayCallBackItem *item) {
                                                         success(item);
                                                     }];
                                                 } else {
                                                     failure([responseObject objectForKey:@"msg"]);
                                                 }
                                             }
                                         }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             if(failure) {
                                                 NSLog(@"%@", error);
                                                 failure(error);
                                             }
                                         }];
    return (operation);
}

@end
