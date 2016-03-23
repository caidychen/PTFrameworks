//
//  MTCSNoticeAckItem.h
//  PTLatitude
//
//  Created by LiLiLiu on 15/12/16.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "MTBaseItem.h"

/**
 * @brief 服务器在推送后，客户端发的确认
 *        从 MTSCNoticeItem 中解析出来后封装到该对象内并通过 Socket 回给服务器
 */
@interface MTCSNoticeAckItem : MTBaseItem <NSCopying>

@property (assign, nonatomic) NSUInteger msgId;   //消息 id 号
- (NSData *)messagePackData;

@end
