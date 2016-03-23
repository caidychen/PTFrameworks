//
//  PTPictureCell.h
//  PTLib
//
//  Created by zhangyi on 16/3/18.
//  Copyright © 2016年 putao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTPictureItem.h"

@class PTPictureCell;
@protocol PTPictureCellDelegate <NSObject>

@optional
// 点击图片触发并返回pictureItem
- (void)PTPictureCellDelegate:(PTPictureCell *)cell withPictureItem:(PTPictureItem *)pictureItem;
- (void)PTPictureCellDelegate:(PTPictureCell *)cell longTouchWithPictureItem:(PTPictureItem *)pictureItem;

@end

@interface PTPictureCell : UICollectionViewCell

@property (nonatomic, weak) id <PTPictureCellDelegate> delegate;
- (void)setValuesForCellItemWithItem:(PTPictureItem *)pictureItem;

@end
