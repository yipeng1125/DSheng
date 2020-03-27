//
//  DSCacheDataManager.h
//  DSheng
//
//  Created by works_yip on 2020/3/10.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSViewHeader.h"
#import "DSLotteryTicketInfo.h"
#import "DSUserInfo.h"

NS_ASSUME_NONNULL_BEGIN



@interface DSCacheDataManager : NSObject

+ (instancetype)shareManager;

@property(nonatomic, strong) NSMutableArray *lotteryTicketInfoList;
@property(nonatomic, assign) NSTimeInterval deviationTime;
@property(nonatomic, strong) NSMutableArray *oddsList;

@property(nonatomic, copy) NSString *ymdString;

//当前server年月日时分秒
@property(nonatomic, assign) NSTimeInterval serverTimeInterval;
//当前server年月日
@property(nonatomic, assign) NSTimeInterval todayTimeInterval;

@property(nonatomic, strong) DSUserInfo *userInfo;


- (void)clearData;


- (NSString *)getNumberOrder:(DSLotteryTicketType)type;

+ (NSString *)getLotteryTicketName:(DSLotteryTicketType)type;


- (NSString *)calculatorRemainTimeType:(DSLotteryTicketType)type block:(void(^)(BOOL enalble, NSString *remainTime))block;

@end

NS_ASSUME_NONNULL_END
