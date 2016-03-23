//
//  PTJsonUnit.m
//  KangYang
//
//  Created by KangYang on 16/3/14.
//  Copyright © 2016年 KangYang. All rights reserved.
//

#import "PTJsonUnit.h"
#import "JSONKit.h"

@implementation PTJsonUnit

+ (id)objectFromJson:(NSString *)json usingLib:(PTJsonLib)lib
{
    if (lib == PTJsonLibNative) {
        
        NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
        
        return [NSJSONSerialization JSONObjectWithData:data
                                               options:NSJSONReadingAllowFragments
                                                 error:nil];
    } else {
        return [json objectFromJSONString];
    }
}

+ (NSString *)jsonFromObject:(id)object usingLib:(PTJsonLib)lib
{
    if (lib == PTJsonLibNative) {
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
        
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
    } else {
        return [object JSONString];
    }
}

@end
