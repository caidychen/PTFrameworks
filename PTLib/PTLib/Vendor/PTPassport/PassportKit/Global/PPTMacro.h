//
//  PPTMacro.h
//  PTLib
//
//  Created by LiLiLiu on 16/3/14.
//  Copyright © 2016年 putao. All rights reserved.
//

#ifndef PPTMacro_h
#define PPTMacro_h

#define PPTIFARC __has_feature(objc_arc)

#if __has_feature(objc_arc)
#define PPTWEAK                  weak
#define __PPTWEAK                __weak
#define PPTPROPERTYWEAK            weak
#define PPTRETAIN(obj)           (obj)
#define PPTRELEASE(obj)          (obj=nil)
#define PPTRELEASEBLOCK(block)   (block)
#define PPTCOPYBLOCK(block)      (block)
#define PPTAUTORELEASE(obj)      (obj)
#define PPTSUPERDEALLOC()
#else
#define PPTWEAK                  block
#define __PPTWEAK                __block
#define PPTPROPERTYWEAK            assign
#define PPTRETAIN(obj)           [obj retain];
#define PPTRELEASE(obj)          [obj release];obj=nil;
#define PPTRELEASEBLOCK(block)   Block_release(block)
#define PPTCOPYBLOCK(block)      Block_copy(block)
#define PPTAUTORELEASE(obj)      [obj autorelease]
#define PPTSUPERDEALLOC()        [super dealloc]
#endif



/**
 *  弧度角度互转
 */
#define PPT_degreesToRadian(x) (M_PI * (x) / 180.0)
#define PPT_radianToDegrees(radian) (radian*180.0)/(M_PI)


#endif /* PPTMacro_h */
