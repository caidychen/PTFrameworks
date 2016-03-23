//
//  NSString+HTML.m
//  PTLatitude
//
//  Created by zhangyi on 16/1/18.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "NSString+HTML.h"

static CGFloat h5PictureWidthOther = 66;    // 屏幕宽 -  66；
static CGFloat h5VideoRadio = 9.0 / 16.0;

@implementation NSString (HTML)

+ (NSString *)replaceH5ImageWidthAndHeight:(NSString *)h5Str {
    NSString *afterStr = @"";
    NSArray *array = [h5Str componentsSeparatedByString:@"<img"];

    if (array && array.count == 1) {
        NSString *strForNoImage = [array safeObjectAtIndex:0];
        return [self replaceH5VideoWidthAndHeight:strForNoImage];
    }
    CGFloat needWidth = [UIScreen mainScreen].bounds.size.width - h5PictureWidthOther;

    
    NSMutableArray *completeArr = [NSMutableArray array];
    
        for (int i = 0; i < array.count; i++) {
            NSString *subWithStr = array[i];
            
            if (i == 0) {
                [completeArr addObject:subWithStr];
                continue;
            }
            NSString *str = subWithStr;
            
            
            NSRange imgPreRange = [subWithStr rangeOfString:@"/>"];
            NSString *subStr = [subWithStr substringToIndex:imgPreRange.location];
            NSString *detailStr = [subWithStr substringFromIndex:imgPreRange.location];
            
            
            // 找出 width="
            NSRange widthWithEqualRange = [subStr rangeOfString:@"width=\""];
            if ((widthWithEqualRange.length + widthWithEqualRange.location)>subStr.length) {
                // 如果没找到宽， 给默认宽度
                NSString *needWidthStr = [NSString stringWithFormat:@" width=\"%dpx\" ", (int)needWidth];
                subWithStr = [NSString stringWithFormat:@"%@%@",needWidthStr, subWithStr];
                
                [completeArr addObject:subWithStr];
                continue;
            }
            
            // 把width=" 后边的字符串 截出来
            NSString *widthBeforePX = [subStr substringFromIndex:(widthWithEqualRange.location + widthWithEqualRange.length)];
//            NSLog(@"widthBeforePX----%@", widthBeforePX);
            // 找到第一个"然后 截取 widthBeforePX
            NSRange widthWithCountRange = [widthBeforePX rangeOfString:@"\""];
            
            // 取出 width=@""         // width完整的  width=@"";
            NSString *widthStr = [subStr substringWithRange:NSMakeRange(widthWithEqualRange.location, widthWithEqualRange.length + widthWithCountRange.location + widthWithCountRange.length)];
//            NSLog(@"widthStr---%@---",widthStr);
            
            // 取出 400px"  这种格式
            NSString *widthWithCountPXStr = [widthBeforePX substringToIndex:(widthWithCountRange.location )];
//            NSLog(@"widthWithCountPXStr---%@---", widthWithCountPXStr);
            
            // 把空格去掉
            NSString *widthTrimmedString = [widthWithCountPXStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//            NSLog(@"widthTrimmedString---%@---", widthTrimmedString);
            
            // 把px去掉
            //            NSRange pxWidthRange = [widthTrimmedString rangeOfString:@"px"];
            NSString *widthWithOutPXStr = [widthTrimmedString stringByReplacingOccurrencesOfString:@"px" withString:@""];
//            NSLog(@"widthWithOutPXStr---%@---", widthWithOutPXStr);
            
            // -------------------------------------------------------------- //
            // 找出 height="
            NSRange heightWithEqualRange = [subStr rangeOfString:@"height=\""];
            if ((heightWithEqualRange.length + heightWithEqualRange.location)>subStr.length) {
                [completeArr addObject:subWithStr];
                continue;
            }
            // 把height=" 后边的字符串 截出来
            NSString *heightBeforePX = [subStr substringFromIndex:(heightWithEqualRange.location + heightWithEqualRange.length)];
//            NSLog(@"heightBeforePX---%@---", heightBeforePX);
            // 找到第一个" 然后 截取 heightBeforePX
            NSRange heightWithCountRange = [heightBeforePX rangeOfString:@"\""];
            
            // 取出 height=@""         // height完整的  height=@"";
            NSString *heightStr = [subStr substringWithRange:NSMakeRange(heightWithEqualRange.location, heightWithEqualRange.length + heightWithCountRange.location + heightWithCountRange.length)];
//            NSLog(@"heightStr---%@---",heightStr);
            
            
            // 取出 400px" 这种格式
            NSString *heightWithCountPXStr = [heightBeforePX substringToIndex:heightWithCountRange.location];
//            NSLog(@"heightWithCountPXStr---%@---", heightWithCountPXStr);
            
            // 把空格去掉
            NSString *heightTrimmedString = [heightWithCountPXStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//            NSLog(@"heightTrimmedString---%@---", heightTrimmedString);
            
            // 把px去掉
            NSString *heightWithOutPXStr = [heightTrimmedString stringByReplacingOccurrencesOfString:@"px" withString:@""];
//            NSLog(@"heightWithOutPXStr---%@---", heightWithOutPXStr);
            
            // -----------------------------------------------------//
            // 截取style 之后的  干掉
            NSRange styleWithEqualRange = [subStr rangeOfString:@"style=\""];
            // 为了保存去掉style之后的 str
            NSString *withoutStyleValueStr = @"";
            
            // 判断是否有 style
            if ((styleWithEqualRange.location + styleWithEqualRange.length) > subStr.length) {
                withoutStyleValueStr = subStr;
            } else {
                // 把style=" 后边的字符串 截取出来
                NSString *styleBeforeStr = [subStr substringFromIndex:(styleWithEqualRange.location + styleWithEqualRange.length)];
//                NSLog(@"styleBeforeStr---%@---",styleBeforeStr);
                // 找到第一个" 截取 styleBeforeStr
                NSRange styleWithValueRange = [styleBeforeStr rangeOfString:@"\""];
                
                // 取出style
                NSString *styleValueStr = [styleBeforeStr substringToIndex:(styleWithValueRange.location)];
//                NSLog(@"styleValueStr---%@---",styleValueStr);
                
                // 先去掉style内容
                withoutStyleValueStr = [subStr stringByReplacingOccurrencesOfString:styleValueStr withString:@""];
//                NSLog(@"withoutStyleValueStr---%@---", withoutStyleValueStr);
            }
            
            // 取出 并计算 图片宽和高
            CGFloat width = [widthWithOutPXStr floatValue];
            CGFloat height = [heightWithOutPXStr floatValue];
            
//            CGFloat needWidth = Screenwidth - h5PictureWidthOther;
            CGFloat needHeight = needWidth * height * 1.0 / width;
            NSString *needWidthStr = [NSString stringWithFormat:@"width=\"%dpx\"", (int)needWidth];
            NSString *needHeightStr = [NSString stringWithFormat:@"height=\"%dpx\"", (int)needHeight];

            
            NSString *newWidthStr = [withoutStyleValueStr stringByReplacingOccurrencesOfString:widthStr withString:needWidthStr];
            NSString *newHeightStr = [newWidthStr stringByReplacingOccurrencesOfString:heightStr withString:needHeightStr];
            
            str = newHeightStr;
            NSString *completeStr = [NSString stringWithFormat:@"%@%@",str, detailStr];
//        }
        [completeArr addObject:completeStr];    // 把新字符串 加入数组
    }
    
    BOOL isFirst = YES;
    for (NSString *str in completeArr) {
        if (isFirst) {
            afterStr = [NSString stringWithFormat:@"%@",str];
            //            NSLog(@"first---%@---", afterStr);
            isFirst = NO;
        } else {
            afterStr = [NSString stringWithFormat:@"%@<img%@", afterStr, str];
            //            NSLog(@"%@", afterStr);
        }
    }
//    NSLog(@"%@", [self replaceH5ImageForClickStr:afterStr]);
    NSString *clickStr = [self replaceH5ImageForClickStr:afterStr];
    return [self replaceH5VideoWidthAndHeight:clickStr];
}

+ (NSString *)replaceH5VideoWidthAndHeight:(NSString *)h5Str {
    NSString *afterStr = @"";
    NSArray *array = [h5Str componentsSeparatedByString:@"<iframe"];
    
    if (array && array.count == 1) {
        return [array safeObjectAtIndex:0];
    }
    CGFloat needWidth = [UIScreen mainScreen].bounds.size.width - h5PictureWidthOther;
    
    
    NSMutableArray *completeArr = [NSMutableArray array];
    
    for (int i = 0; i < array.count; i++) {
        NSString *subWithStr = array[i];
        
        if (i == 0) {
            [completeArr addObject:subWithStr];
            continue;
        }
        NSString *str = subWithStr;
        
        
        NSRange imgPreRange = [subWithStr rangeOfString:@"</iframe>"];
        NSString *subStr = [subWithStr substringToIndex:imgPreRange.location];
        NSString *detailStr = [subWithStr substringFromIndex:imgPreRange.location];
        
        
        // 找出 width="
        NSRange widthWithEqualRange = [subStr rangeOfString:@"width=\""];
        if ((widthWithEqualRange.length + widthWithEqualRange.location)>subStr.length) {
            // 如果没找到宽， 给默认宽度
            NSString *needWidthStr = [NSString stringWithFormat:@" width=\"%dpx\" ", (int)needWidth];
            subWithStr = [NSString stringWithFormat:@"%@%@",needWidthStr, subWithStr];
            [completeArr addObject:subWithStr];
            continue;
        }
        
        // 把width=" 后边的字符串 截出来
        NSString *widthBeforePX = [subStr substringFromIndex:(widthWithEqualRange.location + widthWithEqualRange.length)];
        //            NSLog(@"widthBeforePX----%@", widthBeforePX);
        // 找到第一个"然后 截取 widthBeforePX
        NSRange widthWithCountRange = [widthBeforePX rangeOfString:@"\""];
        
        // 取出 width=@""         // width完整的  width=@"";
        NSString *widthStr = [subStr substringWithRange:NSMakeRange(widthWithEqualRange.location, widthWithEqualRange.length + widthWithCountRange.location + widthWithCountRange.length)];
        //            NSLog(@"widthStr---%@---",widthStr);
        

        
        // -------------------------------------------------------------- //
        // 找出 height="
        NSRange heightWithEqualRange = [subStr rangeOfString:@"height=\""];
        if ((heightWithEqualRange.length + heightWithEqualRange.location)>subStr.length) {
            [completeArr addObject:subWithStr];
            continue;
        }
        // 把height=" 后边的字符串 截出来
        NSString *heightBeforePX = [subStr substringFromIndex:(heightWithEqualRange.location + heightWithEqualRange.length)];
        //            NSLog(@"heightBeforePX---%@---", heightBeforePX);
        // 找到第一个" 然后 截取 heightBeforePX
        NSRange heightWithCountRange = [heightBeforePX rangeOfString:@"\""];
        
        // 取出 height=@""         // height完整的  height=@"";
        NSString *heightStr = [subStr substringWithRange:NSMakeRange(heightWithEqualRange.location, heightWithEqualRange.length + heightWithCountRange.location + heightWithCountRange.length)];
        //            NSLog(@"heightStr---%@---",heightStr);
        
        
        NSRange videoDataUrlWithEqualRange = [subStr rangeOfString:@"data-src=\""];
        NSString *videoUrl = @"";
        if ((videoDataUrlWithEqualRange.location + videoDataUrlWithEqualRange.length) > subStr.length) {
            videoUrl = subStr;
        } else {
            
            // 把style=" 后边的字符串 截取出来
            NSString *styleBeforeStr = [subStr substringFromIndex:(videoDataUrlWithEqualRange.location + videoDataUrlWithEqualRange.length)];
            //                NSLog(@"styleBeforeStr---%@---",styleBeforeStr);
            // 找到第一个" 截取 styleBeforeStr
            NSRange styleWithValueRange = [styleBeforeStr rangeOfString:@"\""];
            
            // 取出style
            NSString *styleValueStr = [styleBeforeStr substringToIndex:(styleWithValueRange.location)];
            //                NSLog(@"styleValueStr---%@---",styleValueStr);
            
            // 先去掉style内容
            //                NSLog(@"withoutStyleValueStr---%@---", withoutStyleValueStr);
            NSString *newUrl = [self replaceVideoUrlWithStr:styleValueStr];
           
            videoUrl = [subStr stringByReplacingOccurrencesOfString:styleValueStr withString:newUrl];
        }
        
        NSString *srcAfterStr = @"";
        if ((videoDataUrlWithEqualRange.location + videoDataUrlWithEqualRange.length) > subStr.length) {
            srcAfterStr = videoUrl;
        } else {
            srcAfterStr = [videoUrl substringFromIndex:(videoDataUrlWithEqualRange.location + videoDataUrlWithEqualRange.length)];
        }
        
        NSRange videoSrcUrlWithEqualRange = [srcAfterStr rangeOfString:@"src=\""];
        NSString *videoSrcUrl = @"";
        if ((videoSrcUrlWithEqualRange.location + videoSrcUrlWithEqualRange.length) > subStr.length) {
            videoSrcUrl = srcAfterStr;
        } else {
            
            // 把style=" 后边的字符串 截取出来
            NSString *styleBeforeStr = [srcAfterStr substringFromIndex:(videoSrcUrlWithEqualRange.location + videoSrcUrlWithEqualRange.length)];
            //                NSLog(@"styleBeforeStr---%@---",styleBeforeStr);
            // 找到第一个" 截取 styleBeforeStr
            NSRange styleWithValueRange = [styleBeforeStr rangeOfString:@"\""];
            
            // 取出style
            NSString *styleValueStr = [styleBeforeStr substringToIndex:(styleWithValueRange.location)];
            //                NSLog(@"styleValueStr---%@---",styleValueStr);
            
            // 先去掉style内容
            //                NSLog(@"withoutStyleValueStr---%@---", withoutStyleValueStr);
            NSString *newUrl = [self replaceVideoUrlWithStr:styleValueStr];
            
            videoSrcUrl = [srcAfterStr stringByReplacingOccurrencesOfString:styleValueStr withString:newUrl];
        }
        NSString *videoCompleteUrl = [videoUrl stringByReplacingOccurrencesOfString:srcAfterStr withString:videoSrcUrl];
        
        
        // -----------------------------------------------------//
        // 截取style 中修改
        NSRange styleWithEqualRange = [videoCompleteUrl rangeOfString:@"style=\""];
        // 为了保存去掉style之后的 str
        NSString *withoutStyleValueStr = @"";
        
        // 判断是否有 style
        if ((styleWithEqualRange.location + styleWithEqualRange.length) > subStr.length) {
            withoutStyleValueStr = videoCompleteUrl;
        } else {
            // 把style=" 后边的字符串 截取出来
            
            // 先去掉style内容

            withoutStyleValueStr = [videoCompleteUrl stringByReplacingOccurrencesOfString:videoCompleteUrl withString:[self replaceStyleWithStr:videoCompleteUrl]];

        }
        
        // 取出 并计算 图片宽和高

        CGFloat needHeight = needWidth * h5VideoRadio;
        NSString *needWidthStr = [NSString stringWithFormat:@"width=\"%dpx\"", (int)needWidth];
        NSString *needHeightStr = [NSString stringWithFormat:@"height=\"%dpx\"", (int)needHeight];
        
        
        NSString *newWidthStr = [withoutStyleValueStr stringByReplacingOccurrencesOfString:widthStr withString:needWidthStr];
        NSString *newHeightStr = [newWidthStr stringByReplacingOccurrencesOfString:heightStr withString:needHeightStr];
        
        str = newHeightStr;
        NSString *completeStr = [NSString stringWithFormat:@"%@%@",str, detailStr];
        [completeArr addObject:completeStr];    // 把新字符串 加入数组
    }
    
    BOOL isFirst = YES;
    for (NSString *str in completeArr) {
        if (isFirst) {
            afterStr = [NSString stringWithFormat:@"%@",str];
            //            NSLog(@"first---%@---", afterStr);
            isFirst = NO;
        } else {
            afterStr = [NSString stringWithFormat:@"%@<iframe%@", afterStr, str];
            //            NSLog(@"%@", afterStr);
        }
    }
//        NSLog(@"%@", afterStr);
    
    return afterStr;
}

+ (NSString *)replaceVideoUrlWithStr:(NSString *)videoUrl {
    CGFloat needWidth = [UIScreen mainScreen].bounds.size.width - h5PictureWidthOther;

    NSString *afterUrl = @"";

    NSRange widthRange = [videoUrl rangeOfString:@"width="];

    if ((widthRange.location + widthRange.length) > videoUrl.length) {
        afterUrl = videoUrl;
    } else {
        
        // 把height=" 后边的字符串 截出来
        NSString *widthBeforePX = [videoUrl substringFromIndex:(widthRange.location + widthRange.length)];
        //            NSLog(@"heightBeforePX---%@---", heightBeforePX);
        // 找到第一个" 然后 截取 heightBeforePX
        NSRange widthWithCountRange = [widthBeforePX rangeOfString:@"&"];
        
        // 取出 height=@""         // height完整的  height=@"";
        NSString *widthStr = [videoUrl substringWithRange:NSMakeRange(widthRange.location, widthRange.length + widthWithCountRange.location + widthWithCountRange.length)];
        //            NSLog(@"heightStr---%@---",heightStr);

        
        // 取出 width=100& 这种格式
        NSString *widthWithCountPXStr = [widthBeforePX substringToIndex:widthWithCountRange.location];
        //            NSLog(@"heightWithCountPXStr---%@---", heightWithCountPXStr);
        
        // 把空格去掉
        NSString *widthTrimmedString = [widthWithCountPXStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //            NSLog(@"heightTrimmedString---%@---", heightTrimmedString);
        
        // 把px去掉
//        NSString *widthWithOutPXStr = [widthTrimmedString stringByReplacingOccurrencesOfString:@"&" withString:@""];
        CGFloat widthCount = [widthTrimmedString floatValue];
        widthCount = needWidth;
        NSInteger widthCountNeed = (NSInteger)widthCount;
        
        NSString *needWidthStr = [NSString stringWithFormat:@"width=%ld&", (long)widthCountNeed];
        
        
        afterUrl = [videoUrl stringByReplacingOccurrencesOfString:widthStr withString:needWidthStr];
        
    }
    
    NSRange heightRange = [afterUrl rangeOfString:@"height="];
    
    if ((heightRange.location + heightRange.length) > afterUrl.length) {
        afterUrl = afterUrl;
    } else {
        
        // 把height=" 后边的字符串 截出来
        NSString *widthBeforePX = [afterUrl substringFromIndex:(heightRange.location + heightRange.length)];
        //            NSLog(@"heightBeforePX---%@---", heightBeforePX);
        // 找到第一个" 然后 截取 heightBeforePX
        NSRange widthWithCountRange = [widthBeforePX rangeOfString:@"&"];
        
        // 取出 height=@""         // height完整的  height=@"";
        NSString *widthStr = [afterUrl substringWithRange:NSMakeRange(heightRange.location, heightRange.length + widthWithCountRange.location + widthWithCountRange.length)];
        //            NSLog(@"heightStr---%@---",heightStr);
        
        
        // 取出 width=100& 这种格式
        NSString *widthWithCountPXStr = [widthBeforePX substringToIndex:widthWithCountRange.location];
        //            NSLog(@"heightWithCountPXStr---%@---", heightWithCountPXStr);
        
        // 把空格去掉
        NSString *widthTrimmedString = [widthWithCountPXStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //            NSLog(@"heightTrimmedString---%@---", heightTrimmedString);
        
        // 把px去掉
//        NSString *widthWithOutPXStr = [widthTrimmedString stringByReplacingOccurrencesOfString:@"&" withString:@""];
        CGFloat widthCount = [widthTrimmedString floatValue];
        widthCount = needWidth * h5VideoRadio;
        NSInteger widthCountNeed = (NSInteger)widthCount;
        
        NSString *needWidthStr = [NSString stringWithFormat:@"height=%ld&", (long)widthCountNeed];
        
        
        afterUrl = [afterUrl stringByReplacingOccurrencesOfString:widthStr withString:needWidthStr];
        
    }
    return afterUrl;
}

+ (NSString *)replaceStyleWithStr:(NSString *)videoUrl {
    CGFloat needWidth = [UIScreen mainScreen].bounds.size.width - h5PictureWidthOther;
    
    NSString *afterUrl = @"";
    
    NSRange widthRange = [videoUrl rangeOfString:@" width:"];
    
    if ((widthRange.location + widthRange.length) > videoUrl.length) {
        afterUrl = videoUrl;
    } else {
        
        // 把height=" 后边的字符串 截出来
        NSString *widthBeforePX = [videoUrl substringFromIndex:(widthRange.location + widthRange.length)];
        //            NSLog(@"heightBeforePX---%@---", heightBeforePX);
        // 找到第一个" 然后 截取 heightBeforePX
        NSRange widthWithCountRange = [widthBeforePX rangeOfString:@"px"];
        
        // 取出 height=@""         // height完整的  height=@"";
        NSString *widthStr = [videoUrl substringWithRange:NSMakeRange(widthRange.location, widthRange.length + widthWithCountRange.location + widthWithCountRange.length)];
        //            NSLog(@"heightStr---%@---",heightStr);
        
        
        // 取出 width=100& 这种格式
        NSString *widthWithCountPXStr = [widthBeforePX substringToIndex:widthWithCountRange.location];
        //            NSLog(@"heightWithCountPXStr---%@---", heightWithCountPXStr);
        
        // 把空格去掉
        NSString *widthTrimmedString = [widthWithCountPXStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //            NSLog(@"heightTrimmedString---%@---", heightTrimmedString);
        
        // 把px去掉
//        NSString *widthWithOutPXStr = [widthTrimmedString stringByReplacingOccurrencesOfString:@"&" withString:@""];
        CGFloat widthCount = [widthTrimmedString floatValue];
        widthCount = needWidth;
        NSInteger widthCountNeed = (NSInteger)widthCount;
        
        NSString *needWidthStr = [NSString stringWithFormat:@" width=%ldpx", (long)widthCountNeed];
        
        
        afterUrl = [videoUrl stringByReplacingOccurrencesOfString:widthStr withString:needWidthStr];
        
    }
    
    NSRange heightRange = [afterUrl rangeOfString:@" height:"];
    
    if ((heightRange.location + heightRange.length) > afterUrl.length) {
        afterUrl = afterUrl;
    } else {
        
        // 把height=" 后边的字符串 截出来
        NSString *widthBeforePX = [afterUrl substringFromIndex:(heightRange.location + heightRange.length)];
        //            NSLog(@"heightBeforePX---%@---", heightBeforePX);
        // 找到第一个" 然后 截取 heightBeforePX
        NSRange widthWithCountRange = [widthBeforePX rangeOfString:@"px"];
        
        // 取出 height=@""         // height完整的  height=@"";
        NSString *widthStr = [afterUrl substringWithRange:NSMakeRange(heightRange.location, heightRange.length + widthWithCountRange.location + widthWithCountRange.length)];
        //            NSLog(@"heightStr---%@---",heightStr);
        
        
        // 取出 width=100& 这种格式
        NSString *widthWithCountPXStr = [widthBeforePX substringToIndex:widthWithCountRange.location];
        //            NSLog(@"heightWithCountPXStr---%@---", heightWithCountPXStr);
        
        // 把空格去掉
        NSString *widthTrimmedString = [widthWithCountPXStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //            NSLog(@"heightTrimmedString---%@---", heightTrimmedString);
        
        // 把px去掉
//        NSString *widthWithOutPXStr = [widthTrimmedString stringByReplacingOccurrencesOfString:@"&" withString:@""];
        CGFloat widthCount = [widthTrimmedString floatValue];
        widthCount = needWidth * h5VideoRadio;
        NSInteger widthCountNeed = (NSInteger)widthCount;
        
        NSString *needWidthStr = [NSString stringWithFormat:@" height=%ldpx", (long)widthCountNeed];
        
        
        afterUrl = [afterUrl stringByReplacingOccurrencesOfString:widthStr withString:needWidthStr];
        
    }
    return afterUrl;

}

+ (NSString *)replaceH5ImageForClickStr:(NSString *)h5Str {
    NSMutableArray *imgUrl = [NSMutableArray array];
    
    NSString *afterStr = @"";
    NSArray *array = [h5Str componentsSeparatedByString:@"<img"];
    
    if (array && array.count == 1) {
        NSString *strForNoImage = [array safeObjectAtIndex:0];
        return [self replaceH5VideoWidthAndHeight:strForNoImage];
    }
    
    
    NSMutableArray *completeArr = [NSMutableArray array];
    
    
    for (int i = 0; i < array.count; i++) {
        NSString *subWithStr = array[i];
        
        if (i == 0) {
            [completeArr addObject:subWithStr];
            continue;
        }
        
        
        NSRange imgPreRange = [subWithStr rangeOfString:@"/>"];
        NSString *subStr = [subWithStr substringToIndex:imgPreRange.location];
        NSString *detailStr = [subWithStr substringFromIndex:imgPreRange.location];
        
        
        

        // 找出 width="
        NSRange widthWithEqualRange = [subStr rangeOfString:@"src=\""];
        if ((widthWithEqualRange.length + widthWithEqualRange.location)>subStr.length) {
            // 没找到 直接返回
            [completeArr addObject:subWithStr];
            continue;
        }
        
        // 把width=" 后边的字符串 截出来
        NSString *widthBeforePX = [subStr substringFromIndex:(widthWithEqualRange.location + widthWithEqualRange.length)];
        
        // 找到第一个"然后 截取 widthBeforePX
        NSRange widthWithCountRange = [widthBeforePX rangeOfString:@"\""];
        
        // 取出 src  图片地址
        NSString *widthStr = [subStr substringWithRange:NSMakeRange((widthWithEqualRange.location + widthWithEqualRange.length), widthWithCountRange.location)];
        [imgUrl addObject:widthStr];
        NSString *clickStr = [NSString stringWithFormat:@" onclick=\"imageClick(%ld)\"", (long)(imgUrl.count - 1)];
        NSString *completeStr = [NSString stringWithFormat:@"%@%@%@",clickStr, subStr,detailStr];
        [completeArr addObject:completeStr];    // 把新字符串 加入数组
//        NSLog(@"%@", completeStr);
    }
    
    BOOL isFirst = YES;
    for (NSString *str in completeArr) {
        if (isFirst) {
            afterStr = [NSString stringWithFormat:@"%@",str];
            //            NSLog(@"first---%@---", afterStr);
            isFirst = NO;
        } else {
            afterStr = [NSString stringWithFormat:@"%@<img%@", afterStr, str];
            //            NSLog(@"%@", afterStr);
        }
    }
    afterStr = [NSString stringWithFormat:@"%@%@", afterStr, [self addScriptForImageClick:imgUrl]];
    

    return afterStr;
}

+ (NSString *)addScriptForImageClick:(NSMutableArray <NSString *> *)arr {
    NSString *afterStr = @"";

    
    NSString *subStr = @"";
    
    for (NSInteger i = 0; i < arr.count; i++) {
        NSString *clickStr = [NSString stringWithFormat:@"{src:\"%@\", text:\"\"}", arr[i]];
        subStr = [NSString stringWithFormat:@"%@%@", subStr,clickStr];
        if (i != (arr.count - 1)) {
            subStr = [NSString stringWithFormat:@"%@,", subStr];
        }
    }
    
    NSString *jsonStr = [NSString stringWithFormat:@"{clickIndex:index,picList:[%@]}", subStr];
    afterStr = [NSString stringWithFormat:@"<script> function imageClick(index){ var json = %@; document.location = 'putao://viewPic/'+ window.JSON.stringify(json); } </script>", jsonStr];

    return afterStr;
}


@end
