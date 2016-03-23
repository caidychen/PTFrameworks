//
//  ViewControllerTableViewCell.h
//  PTLib
//
//  Created by LiLiLiu on 16/3/11.
//  Copyright © 2016年 putao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemoSectionRowItem.h"

typedef void(^VCTableCellActionBlock)(DemoSectionRowItem *item);

@interface ViewControllerTableViewCell : UITableViewCell

@property (nonatomic, strong) DemoSectionRowItem *item;
@property (nonatomic, copy)VCTableCellActionBlock actionBlock;

+ (CGFloat)getCellHeight;

@end
