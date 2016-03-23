//
//  PTLoginNavView.h
//  PTLatitude
//
//  Created by LiLiLiu on 15/11/30.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PPTKit.h"

typedef NS_ENUM(NSUInteger, PTLoginNavBackType) {
    PTLoginNavBackTextType,
    PTLoginNavBackImageType
};

typedef void(^PTLoginNavViewLeftActionBlock)();
typedef void(^PTLoginNavViewRightActionBlock)();

@interface PTLoginNavView : PPTBaseView

@property (nonatomic , copy) PTLoginNavViewLeftActionBlock leftActionBlock;
@property (nonatomic , copy) PTLoginNavViewRightActionBlock rightActionBlock;
@property (nonatomic , assign) PTLoginNavBackType backType;
@property (nonatomic , strong) NSString *title;
@property (nonatomic, strong) UIButton *rightBtn;

@end
