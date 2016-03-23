//
//  DemoPalette.m
//  PTLib
//
//  Created by LiLiLiu on 16/3/13.
//  Copyright © 2016年 putao. All rights reserved.
//

#import "DemoPalette.h"

#import "DemoSectionItem.h"
#import "DemoSectionRowItem.h"

static DemoPalette *_sharedPalette = nil;

@implementation DemoPalette
@synthesize sections = _sections;

+ (instancetype)sharedPalette
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedPalette = [[DemoPalette alloc] init];
        [_sharedPalette loadSections];
    });
    return _sharedPalette;
}

- (void)loadSections{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *objects = [[NSJSONSerialization JSONObjectWithData:data options:kNilOptions|NSJSONWritingPrettyPrinted error:nil] mutableCopy];
    
    _sections = [[NSMutableArray alloc] initWithCapacity:objects.count];
    
    for (NSDictionary *dictionary in objects) {
        DemoSectionItem *sectionItem = [DemoSectionItem itemWithDict:dictionary];
        [_sections addObject:sectionItem];
    }
}

@end
