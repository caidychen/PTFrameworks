//
//  PTAssetsManager.m
//  PTImageDemo
//
//  Created by CHEN KAIDI on 25/3/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import "PTAssetsManager.h"

@interface PTAssetsManager ()
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableArray   *assetGroups;
@end

@implementation PTAssetsManager

+ (PTAssetsManager *)sharedManager
{
    static PTAssetsManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[PTAssetsManager alloc] init];
        [_sharedInstance initAsset];
    });
    
    return _sharedInstance;
}

- (void)initAsset
{
    if (self.assetsLibrary == nil)
    {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
        
        NSString *strVersion = [[UIDevice alloc] systemVersion];
        if ([strVersion compare:@"5"] >= 0)
            [_assetsLibrary writeImageToSavedPhotosAlbum:nil metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
            }];
    }
}

- (void)fetchAllAssetsGroupsWtihCompletion:(void (^)(void))result
{
    void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop)
    {
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        NSInteger numberOfAssets = [group numberOfAssets];
        if (group == nil)
        {
            _assetGroups = [[NSMutableArray alloc] initWithArray:[[_assetGroups reverseObjectEnumerator] allObjects]];
            
            [self setCameraRollAtFirst];
            
            // end of enumeration
            result();
            return;
        }
        if (numberOfAssets>0) {
            [_assetGroups addObject:group];
        }
        
    };
    
    void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error)
    {
        NSLog(@"Error : %@", [error description]);
    };
    
    _assetGroups = [[NSMutableArray alloc] init];
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                  usingBlock:assetGroupEnumerator
                                failureBlock:assetGroupEnumberatorFailure];
}

- (void)setCameraRollAtFirst
{
    for (ALAssetsGroup *group in _assetGroups)
    {
        if ([[group valueForProperty:@"ALAssetsGroupPropertyType"] intValue] == ALAssetsGroupSavedPhotos)
        {
            // send to head
            [_assetGroups removeObject:group];
            [_assetGroups insertObject:group atIndex:0];
            
            return;
        }
    }
}

-(NSMutableArray *)assetArray{
    _assetArray = [[NSMutableArray alloc] initWithArray:_assetGroups];
    return _assetArray;
}

@end
