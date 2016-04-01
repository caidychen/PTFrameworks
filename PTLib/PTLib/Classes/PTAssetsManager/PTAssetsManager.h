//
//  PTAssetsManager.h
//  PTImageDemo
//
//  Created by CHEN KAIDI on 25/3/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>


@interface PTAssetsManager : NSObject

+ (PTAssetsManager *)sharedManager;

/**
 *  This property is for holding all available assets group (aka. Photo albums) on device
 */
@property (nonatomic, strong)   NSMutableArray *assetArray;

/**
 *  Fetch all assets groups from current device
 *  This method must be called at least once before using property "assetArray"
 *
 *  @param result Callback block after the enumeration is a success
 */
- (void)fetchAllAssetsGroupsWtihCompletion:(void (^)(void))result;

@end
