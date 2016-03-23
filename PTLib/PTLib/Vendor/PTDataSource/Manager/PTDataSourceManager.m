//
//  PTDataSourceManager.m
//  PTLatitude
//
//  Created by so on 15/12/18.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTDataSourceManager.h"
#import "PTDataSourceLocalOperation.h"
#import "PTDataSourceOperation.h"
#import "PTDataSourceParseFaceOperation.h"
#import "PTDataSourceParseRegionOperation.h"

@interface PTDataSourceManager () {
    NSOperationQueue *_queue;
}
@property (copy, nonatomic) NSString *bundleFileName;
@property (copy, nonatomic) NSString *bundleFileVersion;
@property (copy, nonatomic) NSString *checkURLString;
@property (strong, nonatomic) NSDictionary *checkDataSourceParameters;

@property (strong, nonatomic) NSArray <PTFaceItem *> *faceItems;
@property (strong, nonatomic) NSArray <PTRegionItem *> *regionItems;
@end


@implementation PTDataSourceManager

+ (instancetype)manager {
    static PTDataSourceManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[PTDataSourceManager alloc] init];
    });
    return (_manager);
}

- (void)setUpDataSourceWithBundleFileName:(NSString *)bundleFileName
                        bundleFileVersion:(NSString *)bundleFileVersion
                           checkURLString:(NSString *)checkURLString
                                   gameID:(NSString *)gameID
                                     opID:(NSString *)opID
                                 clientID:(NSString *)clientID
                             clientSecret:(NSString *)clientSecret {
    self.bundleFileName = bundleFileName;
    self.bundleFileVersion = bundleFileVersion;
    self.checkURLString = checkURLString;
    NSMutableDictionary *pDict = [NSMutableDictionary dictionary];
    if(gameID) {
        [pDict setObject:gameID forKey:@"game_id"];
    }
    if(opID) {
        [pDict setObject:opID forKey:@"op_id"];
    }
    if(clientID) {
        [pDict setObject:clientID forKey:@"client_id"];
    }
    if(clientSecret) {
        [pDict setObject:clientSecret forKey:@"client_secret"];
    }
    self.checkDataSourceParameters = [pDict copy];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        _faceItems = nil;
        _regionItems = nil;
        _queue = [[NSOperationQueue alloc] init];
        [_queue setMaxConcurrentOperationCount:1];
    }
    return (self);
}

- (void)start {
    
    PTDataSourceLocalOperation *localOperation = [[PTDataSourceLocalOperation alloc] init];
    localOperation.bundleFileName = self.bundleFileName;
    localOperation.lastVersion = self.bundleFileVersion;
    [_queue addOperation:localOperation];
    
    PTDataSourceOperation *operation = [[PTDataSourceOperation alloc] init];
    operation.checkURLString = self.checkURLString;
    [operation setCheckParameters:self.checkDataSourceParameters];
    [_queue addOperation:operation];
    
    __weak typeof(self) weak_self = self;
    __weak typeof(operation) weak_operation = operation;
    operation.completionBlock = ^(void){
        if(weak_self.block) {
            weak_self.block([weak_operation isSuccessed], weak_operation.unZipFilePath);
        }
        if([weak_operation isSuccessed]) {
            weak_self.faceItems = nil;
        }
    };
}

- (void)cancel {
    [_queue cancelAllOperations];
    if(self.block) {
        self.block(NO, nil);
    }
}

- (void)parseFacesWithBlock:(void(^)(NSArray <PTFaceItem *> *items))parseBlock {
    if(self.faceItems && self.faceItems.count > 0) {
        if(parseBlock) {
            parseBlock(self.faceItems);
        }
        return;
    }
    PTDataSourceParseFaceOperation *operation = [[PTDataSourceParseFaceOperation alloc] init];
    __weak typeof(self) weak_self = self;
    __weak typeof(operation) weak_operation = operation;
    operation.completionBlock = ^(void){
        weak_self.faceItems = weak_operation.faceItems;
        if(parseBlock) {
            parseBlock(weak_self.faceItems);
        }
    };
    [_queue addOperation:operation];
}

- (void)parseRegionWithBlock:(void(^)(NSArray <PTRegionItem *> *items))parseBlock {
    if(self.regionItems && self.regionItems.count > 0) {
        if(parseBlock) {
            parseBlock(self.regionItems);
        }
        return;
    }
    PTDataSourceParseRegionOperation *operation = [[PTDataSourceParseRegionOperation alloc] init];
    __weak typeof(self) weak_self = self;
    __weak typeof(operation) weak_operation = operation;
    operation.completionBlock = ^(void){
        weak_self.regionItems = weak_operation.regionItems;
        if(parseBlock) {
            parseBlock(weak_self.regionItems);
        }
    };
    [_queue addOperation:operation];
}

- (NSArray <PTFaceItem *> *)faceItems {
    return (_faceItems);
}

- (NSArray <PTRegionItem *> *)regionItems {
    return (_regionItems);
}

@end
