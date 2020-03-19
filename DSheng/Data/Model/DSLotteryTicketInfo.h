//
//  DSLotteryTicketInfo.h
//  DSheng
//
//  Created by works_yip on 2020/3/10.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSViewHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSLotteryTicketInfo : NSObject


@property(nonatomic, copy) NSString *name;
@property(nonatomic, strong) NSDate *startTime;
@property(nonatomic, strong) NSDate *endTime;

@property(nonatomic, assign) NSTimeInterval enablePeriodTime;
@property(nonatomic, assign) NSTimeInterval disablePeriodTime;

@property(nonatomic, assign) DSLotteryTicketType type;


- (instancetype)initWithString:(NSString *)message withType:(DSLotteryTicketType)type;

- (NSString *)cuttentState:(NSTimeInterval)timeInterval currentDate:(NSDate *)date;


- (NSString *)getCurrentOrderNum:(NSString *)datestr andExterTime:(NSTimeInterval)extime;

@end

NS_ASSUME_NONNULL_END
