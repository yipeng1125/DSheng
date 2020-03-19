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
            name = @"北京PK拾";
            break;
        case DSLotteryTicketType_PCdandan:
            name = @"PC蛋蛋";
            break;
        case DSLotteryTicketType_cqsscai:
            name = @"重庆时时彩";
            break;
        case DSLotteryTicketType_tjsscai:
            name = @"天津时时彩";
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


@end
