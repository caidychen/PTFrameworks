//
//  PTRegionItem.h
//  PTLatitude
//
//  Created by so on 15/12/29.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTDataSourceBaseItem.h"

@interface PTRegionItem : PTDataSourceBaseItem <NSCopying>
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *parentID;
@property (strong, nonatomic) NSArray <PTRegionItem *> *items;
@end
