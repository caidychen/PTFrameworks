//
//  PTDataSourceParseRegionOperation.h
//  PTLatitude
//
//  Created by so on 15/12/29.
//  Copyright © 2015年 PT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTRegionItem.h"

@interface PTDataSourceParseRegionOperation : NSOperation
@property (strong, nonatomic) NSArray <PTRegionItem *> *regionItems;
@end
