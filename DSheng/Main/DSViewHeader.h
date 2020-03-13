//
//  DSViewHeader.h
//  DSheng
//
//  Created by works_yip on 2020/3/11.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#ifndef DSViewHeader_h
#define DSViewHeader_h


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



#endif /* DSViewHeader_h */
