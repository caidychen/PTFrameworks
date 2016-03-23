//
//  PTShareView.h
//  PTLatitude
//
//  Created by CHEN KAIDI on 11/12/2015.
//  Copyright © 2015 PT. All rights reserved.
//

#import <Foundation/Foundation.h>

extern CGFloat const PTShareImageMaxSize;
extern CGFloat const PTShareImageThumbSize;
UIImage *PTShareCopmpressImage(CGFloat maxSize, UIImage *image);

extern NSString *PTShareOptionWechatFriends;
extern NSString *PTShareOptionWechatNewsFeed;
extern NSString *PTShareOptionQQFriends;
extern NSString *PTShareOptionQQZone;
extern NSString *PTShareOptionSinaWeibo;
extern NSString *PTShareOptionWebLink ;

typedef void(^PTShareViewActionBlock)(NSString * option);

typedef NS_ENUM(NSInteger, shareType) {
    shareTypeForWebPage = 0,
    shareTypeForText = 1,
    shareTypeForImage = 2,
    shareTypeForVideo = 3
};

@interface PTShareView : UIView
+(void)showOptionsWithTitle:(NSString *)title thumbImage:(UIImage *)thumb webURL:(NSString *)webURL message:(NSString *)message description:(NSString *)description type:(shareType)type options:(NSArray *)options actionBlock:(PTShareViewActionBlock)block;

@end
