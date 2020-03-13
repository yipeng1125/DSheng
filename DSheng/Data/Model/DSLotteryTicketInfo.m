//
//  DSLotteryTicketInfo.m
//  DSheng
//
//  Created by works_yip on 2020/3/10.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import "DSLotteryTicketInfo.h"
#import "NSDate+ext.h"

//@property(nonatomic, copy) NSString *name;
//@property(nonatomic, assign) NSTimeInterval startTimeInterval;
//@property(nonatomic, assign) NSTimeInterval endTimeInterval;
//
//@property(nonatomic, assign) NSTimeInterval enablePeriodTime;
//@property(nonatomic, assign) NSTimeInterval disablePeriodTime;
//
//@property(nonatomic, assign) DSLotteryTicketType type;
//
//
//- (instancetype)initWithString:(NSString *)message;

@implementation DSLotteryTicketInfo

- (instancetype)initWithString:(NSString *)message withType:(DSLotteryTicketType)type {
    
    self = [super init];
    if (self) {
        if (message) {
            NSArray *elements = [message componentsSeparatedByString:@","];
            if (elements.count != 4) {
                return self;
            }
            NSString *str = elements[0];
            NSDate *date = [NSDate date];
            NSString *sdatestr = [date displayDescWithStyle:1];
            NSString *sdatestr2 = [NSString stringWithFormat:@"%@ %@:00", sdatestr, str];
            _startTime = [NSDate dateWithString:sdatestr2];
            
            str = elements[1];
            _enablePeriodTime = [str doubleValue] * 60;
            
            str = elements[2];
            _disablePeriodTime = [str doubleValue] * 60;
            
            str = elements[3];
            sdatestr2 = [NSString stringWithFormat:@"%@ %@:00", sdatestr, str];
            _endTime = [NSDate dateWithString:sdatestr2];
            
            _type = type;
            
        }
    }
    
    return self;
}





@end
