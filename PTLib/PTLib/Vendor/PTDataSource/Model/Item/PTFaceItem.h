//
//  PTFaceItem.h
//  PTLatitude
//
//  Created by so on 15/12/22.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTDataSourceBaseItem.h"
@class UIImage;
@interface PTFaceItem : PTDataSourceBaseItem <NSCopying>
@property (copy, nonatomic) NSString *text;
@property (copy, nonatomic) NSString *imageName;
@property (copy, nonatomic) NSString *facePath;
@property (strong, nonatomic) UIImage *faceImage;
+ (instancetype)itemWithText:(NSString *)text
                   imageName:(NSString *)imageName
                    facePath:(NSString *)facePath;
@end
