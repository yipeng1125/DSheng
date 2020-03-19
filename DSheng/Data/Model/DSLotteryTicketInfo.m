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

- (NSString *)cuttentState:(NSTimeInterval)timeInterval currentDate:(NSDate *)date {
    
    if (timeInterval<= 0 || !date) {
        return @"服务器异常";
    }
    NSComparisonResult result1 = [date compare:_startTime];
    NSComparisonResult result2 = [date compare:_endTime];
    if (result1 == NSOrderedDescending || (result2 == NSOrderedAscending )) {
        
        int t = ((int)timeInterval % ((int)_enablePeriodTime + (int)_disablePeriodTime));
        if (t >= _enablePeriodTime) {
            t = ((int)_enablePeriodTime + (int)_disablePeriodTime) - t;
            int hours = t / 360;
            int min = ((int)(t / 60)) % 60;
            int sec = ((int)t) % 60;
            NSString *tstr = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, min, sec];
            return tstr;
            
            
        } else {
            t = ((int)_enablePeriodTime + (int)_disablePeriodTime) - t;
            int hours = (t - _disablePeriodTime)/360;
            int min = ((int)((t - _disablePeriodTime) / 60)) % 60;
            int sec = ((int)(t - _disablePeriodTime)) % 60;
            NSString *tstr = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, min, sec];
            return tstr;
        }
    } else {
        return @"请等待，未开盘";
    }
    
}


- (NSString *)getCurrentOrderNum:(NSString *)datestr andExterTime:(NSTimeInterval)extime {
    
    if (!datestr) {
        return @"";
    }
    
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    
    int t = (currentTime + extime - [_startTime timeIntervalSince1970]) / (_enablePeriodTime + _disablePeriodTime);
    
    NSString *str = [datestr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    str = [NSString stringWithFormat:@"%@%03d", str, t];
    
    return str;
}





@end
