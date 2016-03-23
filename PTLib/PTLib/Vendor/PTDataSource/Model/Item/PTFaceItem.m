//
//  PTFaceItem.m
//  PTLatitude
//
//  Created by so on 15/12/22.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTFaceItem.h"
#import <UIKit/UIImage.h>

@implementation PTFaceItem
@synthesize faceImage = _faceImage;

+ (instancetype)itemWithText:(NSString *)text
                   imageName:(NSString *)imageName
                    facePath:(NSString *)facePath {
    PTFaceItem *item = [self item];
    item.text = text;
    item.imageName = imageName;
    item.facePath = facePath;
    return (item);
}

- (instancetype)init {
    self = [super init];
    if(self) {
        _text = nil;
        _imageName = nil;
        _facePath = nil;
        _faceImage = nil;
    }
    return (self);
}

- (NSString *)description {
    NSMutableString *mtlStr = [NSMutableString stringWithString:[super description]];
    [mtlStr replaceOccurrencesOfString:@"\n}" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, mtlStr.length)];
    [mtlStr appendFormat:@"\n\ttext = %@; ", self.text];
    [mtlStr appendFormat:@"\n\tfacePath = %@; ", self.facePath];
    [mtlStr appendFormat:@"\n\tfaceImage = %@; ", self.faceImage];
    [mtlStr appendFormat:@"\n}"];
    return (mtlStr);
}

#pragma mark - getter
- (NSString *)text {
    if(!_text) {
        return (@"");
    }
    return (_text);
}

- (NSString *)imageName {
    if(!_imageName) {
        return (@"");
    }
    return (_imageName);
}

- (UIImage *)faceImage {
    if(!_faceImage) {
        self.faceImage = [UIImage imageWithContentsOfFile:self.facePath];
    }
    return (_faceImage);
}
#pragma mark -

#pragma mark - <NSCopying>
- (id)copyWithZone:(NSZone *)zone {
    PTFaceItem *item = [super copyWithZone:zone];
    item.text = self.text;
    item.imageName = self.imageName;
    item.facePath = self.facePath;
    item.faceImage = self.faceImage;
    return (item);
}
#pragma mark -

@end
