//
//  PTAUploadSuccessItem.h
//  PTLatitude
//
//  Created by LiLiLiu on 15/12/9.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PPTKit.h"

/**
 * @brief 上传成功，服务器返回的数据
 {
 ext = jpg;
 filename = 71242ea1559591ec6c3901c6468037a3b3608d8c;
 hash = 71242ea1559591ec6c3901c6468037a3b3608d8c;
 height = 750;
 width = 750;
 }
 */
@interface PTAUploadSuccessItem : PPTBaseItem<NSCopying>

@property (nonatomic,copy) NSString *ext;             //图片后缀名
@property (nonatomic,copy) NSString *filename;        //图片名
@property (nonatomic,copy) NSString *filehash;        //图片 Hash
@property (nonatomic,copy) NSString *height;          //图片高度
@property (nonatomic,copy) NSString *width;           //图片宽度

@end
