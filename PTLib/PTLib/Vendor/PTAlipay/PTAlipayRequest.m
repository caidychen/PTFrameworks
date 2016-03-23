//
//  PTAlipayRequest.m
//  PTLatitude
//
//  Created by LiLiLiu on 15/12/18.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTAlipayRequest.h"

//Model
#import "PTPayMobileOrderItem.h"
#import "PTAlipayResultItem.h"
#import "PTUserManager.h"

//View
#import "PTAlipay.h"


@interface PTAlipayRequest ()

@property (strong, nonatomic, readonly) AFHTTPRequestOperationManager *requestOperationManager;
@property (nonatomic, copy) NSString *orderId;

@end

@implementation PTAlipayRequest
@synthesize requestOperationManager = _requestOperationManager;

+ (instancetype)alipayRequest {
    static PTAlipayRequest *paRequest = nil;
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
               success:(PTAlipayRequestSuccessBlock)success
               failure:(PTAlipayRequestFailureBlock)failure {
    [[self alipayRequest] requestWithWithBaseUrl:baseUrl orderId:orderId uid:uid userToken:token success:success failure:failure];
}


- (instancetype)init {
    self = [super init];
    if(self) {
        
    }
    return (self);
}


#pragma mark - getter
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


#pragma mark -
- (AFHTTPRequestOperation *)requestWithWithBaseUrl:(NSString *)baseUrl
                                           orderId:(NSString *)orderId
                                               uid:(NSString *)uid
                                         userToken:(NSString *)token
                                           success:(PTAlipayRequestSuccessBlock)success
                                           failure:(PTAlipayRequestFailureBlock)failure {

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
    
    AFHTTPRequestOperation *operation = [[self requestOperationManager] POST:baseUrl
                                                                  parameters:parameters
                                                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                         if(success) {
                                                                             NSInteger status = [[responseObject safeNumberForKey:KEY_PTDEFAULT_STATUS] integerValue];
//                                                                               NSLog(@"%@",[responseObject  safeObjectForKey:@"msg"]);
                                                                             if (status == 200) {
                                                                                 NSDictionary *dic = (NSDictionary *)[responseObject safeObjectForKey:KEY_PTDEFAULT_DATA];
                                                                                 PTPayMobileOrderItem *item = [PTPayMobileOrderItem itemWithDict:dic];
                                                                               
                                                                                 [PTAlipay payWithOrderString:item.code result:^(PTAlipayResultItem *resultItem) {
                                                                                     success(resultItem);
                                                                                 }];

                                                                             }
                                                                             
                                                                         }
                                                                     }
                                                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                         if(failure) {
                                                                             failure(error);
                                                                         }
                                                                     }];
    return (operation);
}

@end
