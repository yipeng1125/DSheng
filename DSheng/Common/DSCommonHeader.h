//
//  DSCommonHeader.h
//  DSheng
//
//  Created by works_yip on 2020/3/7.
//  Copyright © 2020 works_yip. All rights reserved.
//

#ifndef DSCommonHeader_h
#define DSCommonHeader_h

#import "UIView+Extension.h"
#import "DSCommonTool.h"

// RGB颜色
#define DSColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define DSRandomColor DSColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
#define DSScreenSize [UIScreen mainScreen].bounds.size


#define DS_MainColor DSColor(253, 98, 0)


#define DS_USER_KEY @"ph_acount"

#define DS_USER_PSD_KEY @"ph_psd"


#ifndef FmtStr
#define FmtStr(fmt,...) [NSString stringWithFormat:(fmt), ##__VA_ARGS__]
#endif



#define kIs_iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define kIs_iPhoneX DSScreenSize.width >=375.0f && DSScreenSize.height >=812.0f&& kIs_iphone

/*状态栏高度*/
#define kStatusBarHeight (CGFloat)(kIs_iPhoneX?(44.0):(20.0))
/*导航栏高度*/
#define kNavBarHeight (44)
/*状态栏和导航栏总高度*/
#define kNavBarAndStatusBarHeight (CGFloat)(kIs_iPhoneX?(88.0):(64.0))
/*TabBar高度*/
#define kTabBarHeight (CGFloat)(kIs_iPhoneX?(49.0 + 34.0):(49.0))
/*顶部安全区域远离高度*/
#define kTopBarSafeHeight (CGFloat)(kIs_iPhoneX?(44.0):(0))
/*底部安全区域远离高度*/
#define kBottomSafeHeight (CGFloat)(kIs_iPhoneX?(34.0):(0))
/*iPhoneX的状态栏高度差值*/
#define kTopBarDifHeight (CGFloat)(kIs_iPhoneX?(24.0):(0))
/*导航条和Tabbar总高度*/
#define kNavAndTabHeight (kNavBarAndStatusBarHeight + kTabBarHeight)





typedef enum : NSUInteger {
    
    DSLotteryTicketType_sanfencai = 1,
    DSLotteryTicketType_sanfenPKcai,
    DSLotteryTicketType_beijingPKcai,
    DSLotteryTicketType_PCdandan,
    DSLotteryTicketType_cqsscai,
    DSLotteryTicketType_tjsscai,
    DSLotteryTicketType_jslhcai,
    DSLotteryTicketType_lhcai,
} DSLotteryTicketType;



typedef enum : NSUInteger {
    
    DSLTType_sanfencai_1_5 = 1,
    DSLTType_sanfencai_lm = 2,
    
    DSLTType_sanfenPKcai_1_10 = 10,
    DSLTType_sanfenPKcai_lm = 11,
    DSLTType_sanfenPKcai_gy = 12,
    
    
    DSLTType_beijingPKcai_1_10 = 20,
    DSLTType_beijingPKcai_lm = 21,
    DSLTType_beijingPKcai_gy =22,
    
    DSLTType_PCdandan_lm = 30,
    DSLTType_PCdandan_tm = 31,
    
    DSLTType_cqsscai_1_5 = 40,
    DSLTType_cqsscai_lm = 41,
    
    DSLTType_tjsscai_1_5 = 50,
    DSLTType_tjsscai_lm = 51,
    
    DSLTType_jslhcai_tm = 60,
    DSLTType_jslhcai_tm_lm = 61,
    DSLTType_jslhcai_tm_tws = 62,
    DSLTType_jslhcai_tm_bs = 63,
    DSLTType_jslhcai_tm_sx = 64,
    
    
    DSLTType_lhcai_tm = 70,
    
} DSLTType;

#define kDS_SanfenCai_Key @"sanfencai";
#define kDS_SanfenPK_Key @"sanfenPK"
#define kDS_BeijingPK_Key @"beijingPK"
#define kDS_PCDandan_Key @"PCdandan"
#define kDS_CQShishi_key @"cqshishicai"
#define kDS_TJShishi_Key @"tjshishicai"
#define KDS_JSLHCai_Key @"jslhcai"
#define KDS_LHCai_Key @"lhcai"

#define kDS_TitleAry_Key @"titleAry"
#define kDS_RowsData_Key @"rowsData"

#define kDS_LiangMianPan_Key @"liangmianpan"
#define kDS_1_5Qiu_key @"1_5qiu"
#define kDS_1_10Ming_key @"1_10ming"
#define kDS_GuanYaJun_key @"guanyajun"
#define kDS_TeMa_Key @"tema"
#define kDS_TeMaShengXiao_Key @"temeshengxiao"
#define kDS_TeMaBoSe_Key @"temabose"
#define kDS_TeMa_TWS_Key @"tema_tws"
#define kDS_TeMa_LM_Key @"tema_lm"


#endif /* DSCommonHeader_h */
