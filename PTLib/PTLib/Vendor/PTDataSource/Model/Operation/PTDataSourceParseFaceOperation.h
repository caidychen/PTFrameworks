//
//  PTDataSourceParseFaceOperation.h
//  PTLatitude
//
//  Created by so on 15/12/22.
//  Copyright © 2015年 PT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTFaceItem.h"

@interface PTDataSourceParseFaceOperation : NSOperation
@property (strong, nonatomic) NSArray <PTFaceItem *> *faceItems;
@end
