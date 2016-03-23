//
//  PTDataSourceLocalOperation.h
//  PTLatitude
//
//  Created by so on 15/12/29.
//  Copyright © 2015年 PT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTDataSourceLocalOperation : NSOperation
@property (copy, nonatomic) NSString *bundleFileName;
@property (copy, nonatomic) NSString *lastVersion;
@end
