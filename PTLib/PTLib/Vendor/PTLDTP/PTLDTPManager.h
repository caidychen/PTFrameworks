//
//  PTLDTPManager.h
//  PTAsyncSocket
//
//  Created by so on 15/8/12.
//  Copyright (c) 2015年 so. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LDTPHelper.h"

@interface PTLDTPManager : NSObject
+ (void)setUpManager;
+ (void)actionWithActionID:(NSUInteger)actionid;
+ (void)actionWithActionID:(NSUInteger)actionid type:(NSString *)type;
+ (void)actionWithActionID:(NSUInteger)actionid operateID:(NSString *)operateid;
+ (void)actionWithActionID:(NSUInteger)actionid type:(NSString *)type operateID:(NSString *)operateid;
@end
