//
//  PTAPI.m
//  PTLatitude
//
//  Created by so on 15/11/27.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTAPI.h"

NSString * const _Nonnull PTLatitudeAppID           = @"1108";
NSString * const _Nonnull PTLatitudePlatformID      = @"9";
NSString * const _Nonnull PTLatitudeSecretKey       = @"c58908e3fa2647a2801fe5417cbcfd8f";

NSString * const _Nonnull PTAbsoluteURLString(NSString * _Nonnull baseURLString, NSString * _Nullable  relativeURLString) {
    return ([baseURLString stringByAppendingString:relativeURLString]);
}


NSString * const _Nonnull PTLatitudeDataSourceSecretKey     = @"d3159867d3525452773206e189ef6966";
NSString * const _Nonnull PTLatitudeDataSourceUpdateURL     = @"http://source.start.wang/client/resource/";


/***********************************************************************************/
/****************************         BaseURL        *******************************/

/**
 *  @brief  0:内网测试
 */
#if (PT_API_TYPE == 0)
NSString * const _Nonnull PTLatitudeBaiduMapKey     = @"Dm647YF56UMO4fqY2AdATFXG";
NSString * const _Nonnull PTLatitudeWxKey           = @"wx46c90751eea478fe";
NSTimeInterval PTLatitudeDebugMenuTimeInt           = 10;

NSString * const _Nonnull PTLatitudePassportServiceBaseURL      = @"https://account-api-dev.putao.com";
//NSString * const _Nonnull PTLatitudePassportServiceBaseURL      = @"http://10.1.11.31:9083";

NSString * const _Nonnull PTLatitudeStoreServiceBaseURL     = @"http://api.store.test.putao.com"; //@"http://api.store.test.putao.com";
NSString * const _Nonnull PTLatitudeUserServiceBaseURL = @"http://api.weidu.start.wang";
NSString * const _Nonnull PTLatitudeEventStarWangServiceBaseURL = @"http://api.event.start.wang";
NSString * const _Nonnull PTLatitudeH5ServiceBaseURL = @"http://static.uzu.wang/weidu_event";
NSString * const _Nonnull PTLatitudeCreatorBaseURL            = @"http://api-bbs-ng-test.start.wang";//@"http://api-bbs-ng.start.wang/";

NSString * const _Nonnull PTLatitudeH5YoukuPlayerServiceBaseURL = @"http://static.uzu.wang/weidu/youku_video.html?video=";

NSString * const _Nonnull PTLatitudeJPushAppKey = @"f76a2210fc826e8f98fb329a";
NSString * const _Nonnull PTLatitudeJPushChannel = @"InHouse";
BOOL const PTLatitudeJPushIsProduction      =   NO;

/**
 *  @brief  1.外网测试
 */
#elif (PT_API_TYPE == 1)
NSString * const _Nonnull PTLatitudeBaiduMapKey     = @"Dm647YF56UMO4fqY2AdATFXG";
NSString * const _Nonnull PTLatitudeWxKey           = @"wx46c90751eea478fe";

NSTimeInterval PTLatitudeDebugMenuTimeInt           = 10;
NSString * const _Nonnull PTLatitudePassportServiceBaseURL      = @"https://account-api.putao.com";
NSString * const _Nonnull PTLatitudeStoreServiceBaseURL     = @"http://api-store.putao.com";
NSString * const _Nonnull PTLatitudeUserServiceBaseURL      = @"http://api-weidu.putao.com";
NSString * const _Nonnull PTLatitudeEventStarWangServiceBaseURL = @"http://api-event.putao.com";
NSString * const _Nonnull PTLatitudeH5ServiceBaseURL = @"http://static.putaocdn.com/weidu";
NSString * const _Nonnull PTLatitudeUploadBaseURL           = @"http://upload.putaocloud.com"; //图片服务器
//NSString * const _Nonnull PTLatitudeGetUploadImageBaseURL   = @"http://weidu.file.putaocloud.com/file/"; //获取图片接口
NSString * const _Nonnull PTLatitudeCreatorBaseURL            = @"http://api-bbs.putao.com";
//优酷视频
NSString * const _Nonnull PTLatitudeH5YoukuPlayerServiceBaseURL = @"http://h5.putao.com/weidu/video/youku_video.html?video=";
NSString * const _Nonnull PTLatitudeJPushAppKey = @"f76a2210fc826e8f98fb329a";
NSString * const _Nonnull PTLatitudeJPushChannel = @"InHouse";
BOOL const PTLatitudeJPushIsProduction      =   NO;

/**
 *  @brief  2.发布AppStore
 */
#elif (PT_API_TYPE == 2)
NSString * const _Nonnull PTLatitudeBaiduMapKey     = @"VjYMh3eX9ymcYkX7g3RXivbA";
NSString * const _Nonnull PTLatitudeWxKey           = @"wx46c90751eea478fe";
NSTimeInterval PTLatitudeDebugMenuTimeInt           = 60;
NSString * const _Nonnull PTLatitudePassportServiceBaseURL      = @"https://account-api.putao.com";
NSString * const _Nonnull PTLatitudeStoreServiceBaseURL     = @"http://api-store.putao.com";
NSString * const _Nonnull PTLatitudeUserServiceBaseURL      = @"http://api-weidu.putao.com";
NSString * const _Nonnull PTLatitudeEventStarWangServiceBaseURL = @"http://api-event.putao.com";
NSString * const _Nonnull PTLatitudeH5ServiceBaseURL = @"http://static.putaocdn.com/weidu";
NSString * const _Nonnull PTLatitudeUploadBaseURL           = @"http://upload.putaocloud.com"; //图片服务器
//NSString * const _Nonnull PTLatitudeGetUploadImageBaseURL   = @"http://weidu.file.putaocloud.com/file/";//获取图片接口
NSString * const _Nonnull PTLatitudeCreatorBaseURL            = @"http://api-bbs.putao.com";
//优酷视频
NSString * const _Nonnull PTLatitudeH5YoukuPlayerServiceBaseURL = @"http://h5.putao.com/weidu/video/youku_video.html?video=";
NSString * const _Nonnull PTLatitudeJPushAppKey = @"afcc176ab3ef10fbae246563";
NSString * const _Nonnull PTLatitudeJPushChannel = @"AppStore";
BOOL const PTLatitudeJPushIsProduction      =   YES;

#endif
/***********************************************************************************/

/**
 *  @brief JPush    DeviceToken
 */
NSString * const _Nonnull PTLatitudeJPushDeviceToken            = @"DeviceToken";

NSString * const _Nonnull PTLatitudePassportAppID               = @"1108";
NSString * const _Nonnull PTLatitudePassportAppSecretKey        = @"c58908e3fa2647a2801fe5417cbcfd8f";

/***********************************************************************************/
/********************************  个人信息相关  ***********************************/
NSString * const _Nonnull PTLatitudeUserRegisterEdit            = @"/user/edit";
NSString * const _Nonnull PTLatitudeUserEditInfo                = @"/user/info";
/***********************************************************************************/



/***********************************************************************************/
NSString * const _Nonnull PTLatitudeStoreIndex              = @"/home/index";
NSString * const _Nonnull PTLatitudeStoreIndexV2            = @"/home/index_v2";
NSString * const _Nonnull PTLatitudeStoreProductDetail      = @"/product/view";
NSString * const _Nonnull PTLatitudeStoreProductSpec        = @"/product/spec";
/***********************************************************************************/


/***********************************************************************************/
/****************************   葡星圈                *******************************/
NSString * const _Nonnull PTLatitudeHomeActivityBanner = @"/banner/list";
NSString * const _Nonnull PTLatitudeHomeActivityList = @"/event/list";
NSString * const _Nonnull PTLatitudeHomeActivityDetail = @"/event/detail";
NSString * const _Nonnull PTLatitudeHomeActivityJoinList = @"/event/enrollment";
NSString * const _Nonnull PTLatitudeHomeActivityZanList = @"/event/cool/list";
NSString * const _Nonnull PTLatitudeHomeActivityZanRequest = @"/cool/add";
NSString * const _Nonnull PTLatitudeHomeActivityWantJion = @"/event/participate/add";
NSString * const _Nonnull PTLatitudeHomeActivityCommentList = @"/comment/list";
NSString * const _Nonnull PTLatitudeHomeActivityCommentListSend = @"/comment/add";
NSString * const _Nonnull PTLatitudeHomeActivityCommentListDelete = @"/comment/remove";
NSString * const _Nonnull PTLatitudeHomeActivityDetailH5Url = @"/view/active_info.html";
NSString * const _Nonnull PTLatitudeHomeGrapeStoneQAH5Url = @"/faq/list";    //@"/view/QA.html";
NSString * const _Nonnull PTLatitudeHomeOtherUserInfo = @"/get/profiles";
/***********************************************************************************/


/************************************************************************************/
/******************************       探索（1.1版本首页）  *****************************/
NSString * const _Nonnull PTLatitudeNewHomeChoicenessList = @"/article/index";
NSString * const _Nonnull PTLatitudeNewHomeZan = @"/article/like/add";
NSString * const _Nonnull PTLatitudeNewHomeMoreLabel = @"/label/list";
NSString * const _Nonnull PTLatitudeNewHomeChoicenessDetail = @"/article/detail";
NSString * const _Nonnull PTLatitudeNewHomeChoicenessClassifyList = @"/article/list";
NSString * const _Nonnull PTLatitudeNewCommentList = @"/article/comment/list";
NSString * const _Nonnull PTLatitudeNewCommentSend = @"/article/comment/add";
NSString * const _Nonnull PTLatitudeNewCommentDelete =  @"/article/comment/delete";
/************************************************************************************/




/***********************************************************************************/
/********************************  我的订单数字提醒 ***********************************/
NSString * const _Nonnull PTLatitudeGetOrderCount            = @"/order/order/getOrderCount";

/********************************     我的订单    ***********************************/
NSString * const _Nonnull PTLatitudeGetOrderList            = @"/order/lists";
NSString * const _Nonnull PTLatitudeGetOrderDetail          = @"/order/detail";
NSString * const _Nonnull PTLatitudeCancelOrder             = @"/order/cancel";

/********************************     售后相关    ***********************************/
NSString * const _Nonnull PTLatitudeSelectService           = @"/service/apply";
NSString * const _Nonnull PTLatitudeSubmitApply             = @"/service/doApply";
NSString * const _Nonnull PTLatitudeAfterSaleList           = @"/service/lists";
NSString * const _Nonnull PTLatitudeCancelApply             = @"/service/cancel";
NSString * const _Nonnull PTLatitudeAfterSaleDetail         = @"/service/detail";
NSString * const _Nonnull PTLatitudeAfterSaleFillExpressage = @"/service/writeExpress";

/********************************   收货地址相关   ***********************************/
NSString * const _Nonnull PTLatitudeUserAddressLists        = @"/address/lists";
NSString * const _Nonnull PTLatitudeUserAddressAdd          = @"/address/add";
NSString * const _Nonnull PTLatitudeUserAddressDel          = @"/address/del";
NSString * const _Nonnull PTLatitudeUserAddressUpdate       = @"/address/update";
NSString * const _Nonnull PTLatitudeUserAddressDefault      = @"/address/getDefault";

NSString * const _Nonnull PTLatitudeMyWatchedCreateMyFollow = @"/create/create/myFollows";

/**
 * 我的收货地址-查询省份、城市、区域
 */
NSString * const _Nonnull PTLatitudeProvinceCityBaseURL     = @"http://putao.start.wang";
NSString * const _Nonnull PTLatitudeProvinceCityArea        = @"/home/index/test";
/***********************************************************************************/





/***********************************************************************************/
/********************************     订单支付    ***********************************/

/**
 * @brief 得到支付宝支付信息
 */
NSString * const _Nonnull PTLatitudePayMobileOrder          = @"/pay/mobile/order";
/**
 * @brief 得到微信支付信息
 */
NSString * const _Nonnull PTLatitudeWXPayOrderInfo          = @"/pay/mobile/toPay";

/***********************************************************************************/


/***********************************************************************************/
/********************************     成长日记    ***********************************/

NSString * const _Nonnull PTLatitudeDiaryList               = @"/diary/index";

/***********************************************************************************/
/********************************    我的活动列表  ***********************************/
NSString * const _Nonnull PTLatitudeUserActivityEventList       = @"/user/event/list";
NSString * const _Nonnull PTLatitudeMeQuestionList              = @"/qa/list";  //@"/user/question/list";
NSString * const _Nonnull PTLatitudeMeQuestionAdd               = @"/qa/add";   //@"/question/add";
/***********************************************************************************/


/***********************************************************************************/
/********************************     消息中心    ***********************************/
//韩锋阳版本
NSString * const _Nonnull PTLatitudeUserMessageCenterNotification= @"/message/center";
NSString * const _Nonnull PTLatitudeUserMessageCenterLiked       = @"/message/likes";
NSString * const _Nonnull PTLatitudeUserMessageCenterReply       = @"/message/comments";
NSString * const _Nonnull PTLatitudeUserMessageCenterRemind      = @"/message/remind";
/***********************************************************************************/



/***********************************************************************************/
/********************************     创造列表    ***********************************/
NSString * const _Nonnull PTLatitudeCreatorList                 = @"/create/create/lists";
NSString * const _Nonnull PTLatitudeCreatorDetail               = @"/create/create/detail";

NSString * const _Nonnull PTLatitudeCreateComment               = @"/create/comment/lists";
NSString * const _Nonnull PTLatitudeCreatorDetailOperation      = @"/create/create/action";
NSString * const _Nonnull PTLatitudeCreateCommentDelete         = @"/create/comment/delete";
NSString * const _Nonnull PTLatitudeCreateCommentAdd            = @"/create/comment/add";
NSString * const _Nonnull PTLatitudeCreateCommentLike           = @"/create/comment/like";

/***********************************************************************************/


/***********************************************************************************/
/********************************    陪伴Tabbar   ***********************************/
NSString * const _Nonnull PTLatitudeAccompanyDiaryApp           = @"/diary/app";
NSString * const _Nonnull PTLatitudeAccompanyDiaryData          = @"/diary/data";
/***********************************************************************************/


/***********************************************************************************/
/***********************************    管理   *************************************/
NSString * const _Nonnull PTLatitudeManagementIndex             = @"/management/index";
NSString * const _Nonnull PTLatitudeManagementEdit              = @"/management/edit";
NSString * const _Nonnull PTLatitudeManagementSetAll            = @"/management/setall";
NSString * const _Nonnull PTLatitudeManagementUnbind            = @"/management/unbind";
/***********************************************************************************/


/***********************************************************************************/
/******************         获取webview请求的schemeBase     **************************/
NSString * const _Nonnull PTWebViewSchemeBase               =       @"putao";
NSString * const _Nonnull PTWebViewActionString             =       @"viewPic";
/************************************************************************************/
