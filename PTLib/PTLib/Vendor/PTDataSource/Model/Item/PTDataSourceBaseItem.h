//
//  PTDataSourceBaseItem.h
//  PTDataSourceDemo
//
//  Created by so on 15/12/31.
//  Copyright © 2015年 PT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTDataSourceHelper.h"

@interface PTDataSourceBaseItem : NSObject <NSCopying>
@property (copy, nonatomic) NSString *itemID;
+ (instancetype)item;
+ (instancetype)itemWithDictionary:(NSDictionary *)dict;
@end
