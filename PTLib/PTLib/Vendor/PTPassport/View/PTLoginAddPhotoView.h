//
//  PTLoginAddPhotoView.h
//  PTLatitude
//
//  Created by LiLiLiu on 15/11/30.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PPTKit.h"

typedef void(^PTLoginAddPhotoViewActionBlock)();

/**
 * @brief 注册页面,完善用户信息,点击添加照片
 */
@interface PTLoginAddPhotoView : PPTBaseView

@property (nonatomic, strong) UIImage *photoImge;
@property (nonatomic, copy) PTLoginAddPhotoViewActionBlock actionBlock;

@end
