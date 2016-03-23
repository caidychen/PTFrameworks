//
//  PTMacro.h
//  PTLatitude
//
//  Created by so on 15/11/27.
//  Copyright © 2015年 PT. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Screenwidth [UIScreen mainScreen].bounds.size.width
#define Screenheight [UIScreen mainScreen].bounds.size.height

#define IsIOS7 ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=7)
#define IsIOS9 ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=9)
#define PADDING 8

#define HEIGHT_STATUS                   20
#define HEIGHT_NAV                      44
#define HEIGHT_BAR                      49

//葡萄纬度主题色
#define THEME_COLOR                     [UIColor colorWithHexString:@"985ec9"]
//输入框分隔线颜色
#define TEXT_INPUT_LINE_COLOR           [UIColor colorWithHexString:@"E1E1E1"]

#define phoneNumberMaxLength            11
#define passwordMinLength               6
#define passwordMaxLength               18
#define imageCodeLength                 4
#define verifyLength                    4

//网络请求缓存时间 30秒
#define HTTP_REQUEST_TIME               30

// Post Notifications
#define kRefreshMyOrderList             @"RefreshMyOrderList"
#define kRefreshMilestoneList           @"RefreshMilestoneList"

//提示语
#define PT_RESPONSE_ERROR_MSG           @"你的网络不给力哦！"
#define TEXT_NICKNAME_FAIL              @"设置2-24字内的昵称"
#define LENGHT_NICK_NOR                 2
#define LENGHT_NICK_MAX                 24


// noti
#define NOTI_POST(name)                 [[NSNotificationCenter defaultCenter] postNotificationName:(name) object:nil];
#define NOTI_QR_ATTENTION_SUCCESS       @"QRAttentionSuccess"     //关注设备成功
#define NOTI_UPDATE_BADGE               @"updateBadge"            //有新的通知
#define NOTI_USER_LOGOUT                @"userLogout"             //退出
#define NOTI_FIRST_INSTALL              @"firstInstallApp"        //第一次安装应用

#define NOTI_CREATE_LIST_REFRESH        @"PTCreateListRefreshNotification" //创造列表刷新

//创造列表刷新标志
#define NOTI_NEED_CREATE_LIST_REFRESH    @"PTCreateListRefreshNeedNotification"
#define NEED_CREATE_LIST_REFRESH         @"PTCreateListRefreshNeed"
#define NEED_IMAGINATION_LIST_REFRESH    @"PTImaginationListRefreshNeed"

//红点大小
#define WIDTH_POINT_NOR                  17
#define WIDTH_POINT_BIG                  23
#define WIDTH_POINT_BIGER                29



//陪伴游戏列表点击状态列表
#define GAME_CELL_TOUCH_STATU            @"gameCellTouchStatu"
//在接到一次推送后,我->消息中心 Cell 点击次数
#define USER_MESSAGECENTER_CELL_TOUCH_COUNT    @"userMessageCenterCellTouchCount"


//存取用户 答题 数据 (动态key:uid+key)
//[NSString stringWithFormat:@"%@_%@",self.user.userID,AccompanyMilestone_ANSWERS]
#define AccompanyMilestone_ANSWERS    @"userAccompanyMilestoneAnswers"

#define JPushNotificationKey    @"JPUSHNotificationKey"
