//
//  NSData+PPTAdditions.h
//  PTLib
//
//  Created by LiLiLiu on 16/3/14.
//  Copyright © 2016年 putao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (PPTAdditions)
+ (NSData *)dataWithBase64EncodedString:(NSString *)string;
- (NSString *)base64Encoding;
- (NSString *)md5Hash;
- (NSString *)sha1Hash;
@end
