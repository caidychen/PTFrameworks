//
//  PTAPI.h
//  PTLatitude
//
//  Created by so on 15/11/27.
//  Copyright © 2015年 PT. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef PT_API
#define PT_API

#define PT_HTTP_SUCCESS_CODE    200


/**
 *  @brief  打包类型, 0:内网测试  1.外网测试  2.发布AppStore
 */
#define PT_API_TYPE         (1)
/**
 * @brief  打点和推送功能开关变量 0-内网 1-外网
 */
#define DEBUG_APP           (1)


/**
 *  @brief  应用ID
 */
extern NSString * const _Nonnull PTLatitudeAppID;

/**
 *  @brief  平台ID
 */
extern NSString * const _Nonnull PTLatitudePlatformID;

/**
 *  @brief  secret key
 */
extern NSString * const _Nonnull PTLatitudeSecretKey;

/**
 *  @brief  baidu map key
 */
extern NSString * const _Nonnull PTLatitudeBaiduMapKey;

/**
 *  @brief  wx key
 */
extern NSString * const _Nonnull PTLatitudeWxKey;

/**
 *  @brief  触发接口调试界面的时长
 */
extern NSTimeInterval PTLatitudeDebugMenuTimeInt;


/**
 *  @brief  资源更新secret key
 */
extern NSString * const _Nonnull PTLatitudeDataSourceSecretKey;

/**
 *  @brief  资源更新地址
 */
extern NSString * const _Nonnull PTLatitudeDataSourceUpdateURL;



/**
 *  @brief  通过基本路径和相对路径，获取绝对路径
 *
 *  @return 返回绝对路径
 */
extern NSString * const _Nonnull PTAbsoluteURLString(NSString * _Nonnull baseURLString, NSString * _Nullable  relativeURLString);

/*********************************************************************/
/*********************         JPush        **************************/
/**
 *  @brief  JPush AppKey
 */
extern NSString * const _Nonnull PTLatitudeJPushAppKey;

/**
 *  @brief  JPush channel
 */
extern NSString * const _Nonnull PTLatitudeJPushChannel;

/**
 *  @brief  JPush Production
 */
extern BOOL const PTLatitudeJPushIsProduction;

/**
 *  @brief JPush    DeviceToken
 */
extern NSString * const _Nonnull PTLatitudeJPushDeviceToken;
/***********************************************************************************/
/***********************************************************************************/



/***********************************************************************************/
/****************************         BaseURL        *******************************/

/**
 *  @brief  Passport 服务地址
 */
extern NSString * const _Nonnull PTLatitudePassportServiceBaseURL;

/**
 *  @brief  葡萄探索号地址
 */
extern NSString * const _Nonnull PTLatitudeStoreServiceBaseURL;

extern NSString * const _Nonnull PTLatitudeUserServiceBaseURL;

/**
 *  @brief  H5地址
 */
extern NSString * const _Nonnull PTLatitudeH5ServiceBaseURL;

/**
 *  @brief  H5 优酷视频播放地址
 */
extern NSString * const _Nonnull PTLatitudeH5YoukuPlayerServiceBaseURL;


/***********************************************************************************/
/***********************************************************************************/



/**
 *  @brief  Passport AppID
 *          线上线下相同
 */
extern NSString * const _Nonnull PTLatitudePassportAppID;
/**
 *  @brief  Passport SecretKey
 */
extern NSString * const _Nonnull PTLatitudePassportAppSecretKey;


/***********************************************************************************/
/********************************     我的信息    ***********************************/
/**
 *  @brief 注册完善用户信息,头像、昵称、个人简介
 */
extern NSString * const _Nonnull PTLatitudeUserRegisterEdit;

/**
 * @brief 查询个人信息 (昵称、头像、个人简介)
 */
extern NSString * const _Nonnull PTLatitudeUserEditInfo;

/***********************************************************************************/



/***********************************************************************************/
/****************************   葡星圈                *******************************/
/**
 *  @brief 葡星圈banner
 */
extern NSString * const _Nonnull PTLatitudeHomeActivityBanner;

/**
 *  @brief 葡星圈活动列表
 */
extern NSString * const _Nonnull PTLatitudeHomeActivityList;

/**
 *  @brief 活动详情
 */
extern NSString * const _Nonnull PTLatitudeHomeActivityDetail;

/**
 *  @brief 活动报名列表
 */
extern NSString * const _Nonnull PTLatitudeHomeActivityJoinList;

/**
 *  @brief 赞列表
 */
extern NSString * const _Nonnull PTLatitudeHomeActivityZanList;

/**
 *  @brief 赞请求
 */
extern NSString * const _Nonnull PTLatitudeHomeActivityZanRequest;

/**
 *  @brief 我要参加
 */
extern NSString * const _Nonnull PTLatitudeHomeActivityWantJion;

/**
 *  @brief 评论列表
 */
extern NSString * const _Nonnull PTLatitudeHomeActivityCommentList;

/**
 *  @brief 发表评论
 */
extern NSString * const _Nonnull PTLatitudeHomeActivityCommentListSend;

/**
 *  @brief 发表删除
 */
extern NSString * const _Nonnull PTLatitudeHomeActivityCommentListDelete;

/**
 *  @brief H5 url
 */
extern NSString * const _Nonnull PTLatitudeHomeActivityDetailH5Url;

/**
 *  @brief H5 葡萄籽
 */
extern NSString * const _Nonnull PTLatitudeHomeGrapeStoneQAH5Url;

/**
 *  @brief 查看他人信息
 */
extern NSString * const _Nonnull PTLatitudeHomeOtherUserInfo;
/***********************************************************************************/


/***********************************************************************************/
/****************************   首页探索            *******************************/
/**
 *  @brief 探索 首页
 */
extern NSString * const _Nonnull PTLatitudeNewHomeChoicenessList;
/**
 *  @brief 探索 首页
 */
extern NSString * const _Nonnull PTLatitudeNewHomeZan;
/**
 *  @brief 探索 首页更多标签
 */
extern NSString * const _Nonnull PTLatitudeNewHomeMoreLabel;
/**
 *  @brief 探索 详情
 */
extern NSString * const _Nonnull PTLatitudeNewHomeChoicenessDetail;
/**
 *  @brief 探索 分类列表
 */
extern NSString * const _Nonnull PTLatitudeNewHomeChoicenessClassifyList;
/**
 *  @brief 探索 评论列表
 */
extern NSString * const _Nonnull PTLatitudeNewCommentList;
/**
 *  @brief 探索 发表评论
 */
extern NSString * const _Nonnull PTLatitudeNewCommentSend;
/**
 *  @brief 探索 删除评论
 */
extern NSString * const _Nonnull PTLatitudeNewCommentDelete;


/***********************************************************************************/



/***********************************************************************************/
/********************************   我的收货地址   ***********************************/
/**
 * 我的收货地址-地址列表
 */
extern NSString * const _Nonnull PTLatitudeUserAddressLists;

/**
 * 我的收货地址-添加地址
 */
extern NSString * const _Nonnull PTLatitudeUserAddressAdd;

/**
 * 我的收货地址-删除地址
 */
extern NSString * const _Nonnull PTLatitudeUserAddressDel;

/**
 * 我的收货地址-更新地址
 */
extern NSString * const _Nonnull PTLatitudeUserAddressUpdate;

/**
 * 我的收货地址-默认地址
 */
extern NSString * const _Nonnull PTLatitudeUserAddressDefault;

/**
 * 我的收货地址-查询省份、城市、区域
 */
extern NSString * const _Nonnull PTLatitudeProvinceCityBaseURL;
extern NSString * const _Nonnull PTLatitudeProvinceCityArea;
/***********************************************************************************/



/***********************************************************************************/
/****************************   我的活动列表、我的提问  *******************************/
/**
 *  @brief 我的活动列表 baseUrl
 */
extern NSString * const _Nonnull PTLatitudeEventStarWangServiceBaseURL;

/**
 *  @brief 获取我的活动列表
 */
extern NSString * const _Nonnull PTLatitudeUserActivityEventList;

/**
 *  @brief 获取我的提问列表
 */
extern NSString * const _Nonnull PTLatitudeMeQuestionList;

/**
 *  @brief 发表我的提问
 */
extern NSString * const _Nonnull PTLatitudeMeQuestionAdd;

/**
 *  @brief 我的关注
 */
extern NSString * const _Nonnull PTLatitudeMyWatchedCreateMyFollow;
/***********************************************************************************/





/***********************************************************************************/
/********************************     消息中心    ***********************************/
/**
 *  @brief 通知
 */
extern NSString * const _Nonnull PTLatitudeUserMessageCenterNotification;

/**
 *  @brief 赞
 */
extern NSString * const _Nonnull PTLatitudeUserMessageCenterLiked;

/**
 *  @brief 回复
 */
extern NSString * const _Nonnull PTLatitudeUserMessageCenterReply;

/**
 *  @brief 提醒
 */
extern NSString * const _Nonnull PTLatitudeUserMessageCenterRemind;
/***********************************************************************************/



/***********************************************************************************/
/**
 *  @brief  商城服务地址
 */
extern NSString * const _Nonnull PTLatitudeStoreServiceBaseURL;

/**
 *  @brief  商城首页
 */
extern NSString * const _Nonnull PTLatitudeStoreIndex;
extern NSString * const _Nonnull PTLatitudeStoreIndexV2;

extern NSString * const _Nonnull PTLatitudeStoreProductDetail;

extern NSString * const _Nonnull PTLatitudeStoreProductSpec;
/***********************************************************************************/

/***********************************************************************************/
/********************************  我的订单数字提醒 ***********************************/
extern NSString * const _Nonnull PTLatitudeGetOrderCount;
/********************************     我的订单    ***********************************/
extern NSString * const _Nonnull PTLatitudeGetOrderList;
extern NSString * const _Nonnull PTLatitudeGetOrderDetail;
extern NSString * const _Nonnull PTLatitudeCancelOrder;
/********************************     售后相关    ***********************************/
extern NSString * const _Nonnull PTLatitudeSelectService;
extern NSString * const _Nonnull PTLatitudeSubmitApply;
extern NSString * const _Nonnull PTLatitudeAfterSaleList;
extern NSString * const _Nonnull PTLatitudeCancelApply;
extern NSString * const _Nonnull PTLatitudeAfterSaleDetail;
extern NSString * const _Nonnull PTLatitudeAfterSaleFillExpressage;
/***********************************************************************************/

/***********************************************************************************/
/********************************     成长日记    ***********************************/

extern NSString * const _Nonnull PTLatitudeDiaryList;
/***********************************************************************************/
/********************************     订单支付    ***********************************/

/**
 * @brief 得到支付宝支付信息
 */
extern NSString * const _Nonnull PTLatitudePayMobileOrder;
/**
 * @brief 得到微信支付信息
 */
extern NSString * const _Nonnull PTLatitudeWXPayOrderInfo;

/***********************************************************************************/







/***********************************************************************************/
/********************************     创造列表 详情   ***********************************/
extern NSString * const _Nonnull PTLatitudeCreatorBaseURL;

extern NSString * const _Nonnull PTLatitudeCreatorList;
extern NSString * const _Nonnull PTLatitudeCreatorDetail;

extern NSString * const _Nonnull PTLatitudeCreateComment;
extern NSString * const _Nonnull PTLatitudeCreatorDetailOperation;
extern NSString * const _Nonnull PTLatitudeCreateCommentDelete;
extern NSString * const _Nonnull PTLatitudeCreateCommentAdd;
extern NSString * const _Nonnull PTLatitudeCreateCommentLike;
/***********************************************************************************/


/***********************************************************************************/
/********************************    陪伴Tabbar   ***********************************/
extern NSString * const _Nonnull PTLatitudeAccompanyDiaryApp;   //如果用户关联设备显示葡所有萄产品
extern NSString * const _Nonnull PTLatitudeAccompanyDiaryData;  //返回对应游戏下的数据
/***********************************************************************************/


/***********************************************************************************/
/***********************************    管理   *************************************/
extern NSString * const _Nonnull PTLatitudeManagementIndex;
extern NSString * const _Nonnull PTLatitudeManagementEdit;
extern NSString * const _Nonnull PTLatitudeManagementSetAll;
extern NSString * const _Nonnull PTLatitudeManagementUnbind;
/***********************************************************************************/

/***********************************************************************************/
/******************         获取webview请求的schemeBase     **************************/
extern NSString * const _Nonnull PTWebViewSchemeBase;
extern NSString * const _Nonnull PTWebViewActionString;

#endif

