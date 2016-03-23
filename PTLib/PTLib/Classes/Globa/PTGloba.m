//
//  PTGloba.m
//  PTLatitude
//
//  Created by so on 15/12/10.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTGloba.h"



/*
 AppStore:      11001,  HappyKids_Vx.x.x.x_pingguo_signed
 XY苹果助手:     11002,
 同步推:           11003, HappyKids_Vx.x.x.x_tongbutui_signed
 苹果快用:      11004,  HappyKids_Vx.x.x.x_pingguozhushou_signed
 91助手:      11005,  HappyKids_Vx.x.x.x_zhushou_signed
 */

NSString * PTBundleVersion() {
    return ([[[NSBundle mainBundle] infoDictionary] stringObjectForKey:@"CFBundleVersion"]);
}

NSString * PTBundleShortVersion() {
    return ([[[NSBundle mainBundle] infoDictionary] stringObjectForKey:@"CFBundleShortVersionString"]);
}

NSString * PTChannelNameWithChannelID(LDTPChannelID channelID) {
    switch (channelID) {
        case LDTPChannelID91Helper:{
            return (@"91助手");
        }break;
            
        case LDTPChannelIDTongBuTui:{
            return (@"同步推");
        }break;
            
        case LDTPChannelIDPingGuoKuaiYong:{
            return (@"苹果快用");
        }break;
            
        case LDTPChannelIDXYHelper: {
            return (@"XY苹果助手");
        }break;
        case LDTPChannelIDAppStore:
        default:{
            return (@"AppStore");
        }break;
    }
}

NSString *PTChannelWithTPChannelID(LDTPChannelID channelID) {
    NSMutableString *channelString = [NSMutableString stringWithString:@"PTLatitude"];
    NSString *bundleVersion = PTBundleVersion();
    if(bundleVersion && bundleVersion.length > 0) {
        [channelString appendFormat:@"_V%@", bundleVersion];
    }
    switch (channelID) {
        case LDTPChannelID91Helper:{
            [channelString appendString:@"_91zhushou"];
        }break;
            
        case LDTPChannelIDTongBuTui:{
            [channelString appendString:@"_tongbutui"];
        }break;
            
        case LDTPChannelIDPingGuoKuaiYong:{
            [channelString appendString:@"_pingguozhushou"];
        }break;
            
        case LDTPChannelIDXYHelper:
        case LDTPChannelIDAppStore:
        default:{
            [channelString appendString:@"_pingguo"];
        }break;
    }
    [channelString appendString:@"_signed"];
    return (channelString);
}





/*
 后缀可能为 .jpg .png .jpeg
 */

NSString *PTImageURLScaleWithScale(NSString *URLString, PTImageURLStringScale scale) {
    if(!URLString || ![URLString isKindOfClass:[NSString class]] || [URLString length] < 5) {
        return (URLString);
    }
    NSArray *scales = @[@"_1200x400",
                        @"_1200x750",
                        @"_1200x600",
                        @"_240x240",
                        @"_360x360",
                        @"_180x180",
                        @"_1200x1200",
                        @"_120x120",
                        @"_150x150",
                        @"_192x192",
                        @"_96x96",
                        @"_250x0"];
    NSMutableString *mutableURLString = [[NSMutableString alloc] initWithString:URLString];
    for(NSString *s in scales) {
        NSUInteger l = [mutableURLString replaceOccurrencesOfString:s withString:@"" options:NSLiteralSearch range:NSMakeRange(0, mutableURLString.length)];
        if(l > 0) {
            break;
        }
    }
    
    NSString *ap = nil;
    switch (scale) {
        case PTImageURLStringScale1200x400:{
            ap = @"_1200x400";
        }break;
        case PTImageURLStringScale1200x750:{
            ap = @"_1200x750";
        }break;
        case PTImageURLStringScale1200x600:{
            ap = @"_1200x600";
        }break;
        case PTImageURLStringScale240x240:{
            ap = @"_240x240";
        }break;
        case PTImageURLStringScale360x360:{
            ap = @"_360x360";
        }break;
        case PTImageURLStringScale180x180:{
            ap = @"_180x180";
        }break;
        case PTImageURLStringScale1200x1200:{
            ap = @"_1200x1200";
        }break;
        case PTImageURLStringScale120x120:{
            ap = @"_120x120";
        }break;
        case PTImageURLStringScale150x150:{
            ap = @"_150x150";
        }break;
        case PTImageURLStringScale192x192:{
            ap = @"_192x192";
        }break;
        case PTImageURLStringScale96x96:{
            ap = @"_96x96";
        }break;
        case PTImageURLStringScale250x0:{
            ap = @"_250x0";
        }break;
            
        default:break;
    }
    
    if(!ap || ap.length == 0) {
        return (URLString);
    }
    
    NSArray *imageTypes = @[@".jpg",
                            @".png",
                            @".jpeg"];
    NSInteger insertIndex = -1;
    for(NSString *t in imageTypes) {
        NSInteger searchLoc = mutableURLString.length - t.length;
        if(searchLoc < 0) {
            continue;
        }
        NSRange range = [mutableURLString rangeOfString:t options:NSLiteralSearch range:NSMakeRange(searchLoc, t.length)];
        if(range.length != t.length) {
            continue;
        }
        insertIndex = range.location;
    }
    if(insertIndex < 0) {
        return (URLString);
    }
    [mutableURLString insertString:ap atIndex:insertIndex];
    return ([NSString stringWithString:mutableURLString]);
}
