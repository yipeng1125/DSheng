//
//  DSCacheDataManager.m
//  DSheng
//
//  Created by works_yip on 2020/3/10.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import "DSCacheDataManager.h"
#import "DSDataCommonHeader.h"
#import "DSLotteryTicketInfo.h"

@interface DSCacheDataManager() {
    
    NSLock *mylock;
}

@end

@implementation DSCacheDataManager

static DSCacheDataManager *_manger;


+ (instancetype)shareManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manger = [[DSCacheDataManager alloc] init];
        
    });
    
    return _manger;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //code
        _lotteryTicketInfoList = [NSMutableArray array];
        _oddsList = [NSMutableArray array];
        mylock = [NSLock new];
    }
    return self;
}

- (void)clearData {
    
    [mylock lock];
    [_lotteryTicketInfoList removeAllObjects];
    [_oddsList removeAllObjects];
    [mylock unlock];
}




- (NSString *)getNumberOrder:(DSLotteryTicketType)type {
    NSString *order = @"";
    [mylock lock];
    for (DSLotteryTicketInfo *item in _lotteryTicketInfoList) {
        if (type != item.type) {
            continue;
        }
        
        order = [item getCurrentOrderNum:_ymdString andExterTime:_deviationTime];
        break;
    }
    
    [mylock unlock];
    
    return order;
}


+ (NSString *)getLotteryTicketName:(DSLotteryTicketType)type {
    
    NSString *name = @"";
    switch (type) {
        case DSLotteryTicketType_sanfencai:
            name = @"三分彩";
            break;
        case DSLotteryTicketType_sanfenPKcai:
            name = @"三分PK拾";
            break;
        case DSLotteryTicketType_beijingPKcai:
//            name = @"北京PK拾";
            name = @"五分彩";
            break;
        case DSLotteryTicketType_PCdandan:
            name = @"PC蛋蛋";
            break;
        case DSLotteryTicketType_cqsscai:
//            name = @"重庆时时彩";
            name = @"七分彩";
            break;
        case DSLotteryTicketType_tjsscai:
//            name = @"天津时时彩";
            name = @"十分彩";
            break;
        case DSLotteryTicketType_jslhcai:
            name = @"急速六合彩";
            break;
        case DSLotteryTicketType_lhcai:
            name = @"六合彩";
            break;
            
        default:
            break;
    }
    
    return name;
    
}



- (NSString *)calculatorRemainTimeType:(DSLotteryTicketType)type block:(void(^)(BOOL enalble, NSString *remainTime))block {
    
    __block NSString *message;
    NSTimeInterval currentTimeInterval = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval newInterval = (currentTimeInterval + DSCacheDataManager.shareManager.deviationTime)  - [DSCacheDataManager shareManager].todayTimeInterval;
    NSDate *curTime = [NSDate dateWithTimeIntervalSince1970:(currentTimeInterval + DSCacheDataManager.shareManager.deviationTime)];
    
    for (DSLotteryTicketInfo *item in DSCacheDataManager.shareManager.lotteryTicketInfoList) {
        
        if (item.type == type) {
            [item cuttentState:newInterval currentDate:curTime block:^(BOOL enalble, NSString * _Nonnull remainTime) {
                message = remainTime;
                if (block) {
                    block(enalble, remainTime);
                }
            }];
            break;
        }
    }
    
    return message;
}

+ (NSString *)getTopTitleStringWithType:(DSLTType)type {
    
    NSString *key = @"";
    
    switch (type) {
        case DSLTType_sanfencai_lm:
        case DSLTType_sanfenPKcai_lm:
        case DSLTType_beijingPKcai_lm:
        case DSLTType_PCdandan_lm:
        case DSLTType_cqsscai_lm:
        case DSLTType_tjsscai_lm:
            key = @"两面盘";
            break;
            
        case DSLTType_sanfencai_1_5:
        case DSLTType_cqsscai_1_5:
        case DSLTType_tjsscai_1_5:
            key = @"1-5球";
            break;
            
        case DSLTType_sanfenPKcai_1_10:
        case DSLTType_beijingPKcai_1_10:
            key = @"1-10名";
            break;
            
        case DSLTType_sanfenPKcai_gy:
        case DSLTType_beijingPKcai_gy:
            key = @"冠亚军";
            break;
            
        case DSLTType_PCdandan_tm:
        case DSLTType_jslhcai_tm:
        case DSLTType_lhcai_tm:
            key = @"特码";
            break;
            
        case DSLTType_jslhcai_tm_tws:
            key = @"特码头尾数";
            break;
        case DSLTType_jslhcai_tm_bs:
            key = @"特码波色";
            break;
        case DSLTType_jslhcai_tm_sx:
            key = @"特码生肖";
            break;
        case DSLTType_jslhcai_tm_lm:
            key = @"特码两面";
            break;
            
        default:
            break;
            
    }
    
    return key;
}



@end
