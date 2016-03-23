//
//  PTJsonUnit.h
//  KangYang
//
//  Created by KangYang on 16/3/14.
//  Copyright © 2016年 KangYang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PTJsonLib) {
    PTJsonLibNative = 0,
    PTJsonLibJSONKit = 1
};

@interface PTJsonUnit : NSObject

+ (id)objectFromJson:(NSString *)json usingLib:(PTJsonLib)lib;

+ (NSString *)jsonFromObject:(id)object usingLib:(PTJsonLib)lib;

@end
