//
//  UIView+PTView.h
//
//  Created by CHEN KAIDI on 14/3/2016.
//  Copyright © 2016 Putao. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <UIKit/UIKit.h>

/**
 *   Enum types for border fade out option
 */
typedef NS_ENUM(NSInteger, PTViewFadeOutBoundaryEffectOptions) {
    /**
     *  Fading effect for top boundary only
     */
    PTViewFadeOutBoundaryEffectOptionsTopOnly = 1,
    /**
     *  Fading effect for bottom boundary only
     */
    PTViewFadeOutBoundaryEffectOptionsBottomOnly = 2,
    /**
     *  Fading effect for both top and bottom boundaries
     */
    PTViewFadeOutBoundaryEffectOptionsTopBottom = 3,
};

@interface UIView (PTView)

/**
 *  Retrieve the window object at the highest hierarchy
 *  Warning: adding subview on this hierarchy may result blocking UI within the app. Use wisely !!
 *
 *  @return UIWindow at the highest hierarchy
 */
+(UIWindow*)topWindows;

/**
 *  Draw a vertical line
 *
 *  @param width       Line width
 *  @param beginPointX Starting X position
 *  @param beginPointY Starting Y position
 *  @param height      Line height
 *  @param color       Line color
 *  @param superView   View where line will be drawn on
 */
+ (void)getVerticalLineWithWidth:(float)width
                     beginPointX:(float)beginPointX
                     beginPointY:(float)beginPointY
                          height:(float)height
                           color:(UIColor *)color
                       superView:(UIView *)superView;
/**
 *  Draw a horizontal line
 *
 *  @param width       Line width
 *  @param beginPointX Starting X position
 *  @param beginPointY Starting Y position
 *  @param height      Line height
 *  @param color       Line color
 *  @param superView   View where line will be drawn on
 */
+ (void)getHorizontalLineWithWidth:(float)width
                       beginPointX:(float)beginPointX
                       beginPointY:(float)beginPointY
                              wide:(float)wide
                             color:(UIColor *)color
                         superView:(UIView *)superView;

/**
 *  Apply quick shadow effect around the layer
 */
-(void)shadowEffectOn;

/**
 *  Take a snapshot of view in current state
 *
 *  @return Screenshot of view
 */
-(UIImage *)screenshot;

/**
 *  Apply round corner and border line around UIView
 *
 *  @param radius Corner radius
 *  @param bColor Border color
 *  @param bWidth Border width
 */
- (void)makeCornerRadius:(CGFloat)radius
             borderColor:(UIColor *)bColor
             borderWidth:(CGFloat)bWidth;

/**
 *  Apply a gradually fading border effect on top and bottom of UIView
 *
 *  @param opacity  Opacity control of how strong the gradient effect will be (Value range: 0.0 ~ 1.0). More specifically, it stands for the level of transparency at the beginning of gradient mask.
 *  @param length   Length of gradient
 *  @param margin   Offset for clipping gradient effect
 *  @param option   Effect options. See PTViewFadeOutBoundaryEffectOptions
 */
-(void)applyFadeOutBoundaryEffectTopDownWithGradientOpacity:(CGFloat)opactiy length:(CGFloat)length margin:(CGFloat)margin effectOption:(PTViewFadeOutBoundaryEffectOptions)option;

@end
