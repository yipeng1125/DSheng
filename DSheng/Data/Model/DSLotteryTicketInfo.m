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

- (void)cuttentState:(NSTimeInterval)timeInterval currentDate:(NSDate *)date block:(nonnull void (^)(BOOL, NSString * _Nonnull))block {
    
    if (timeInterval<= 0 || !date) {
        if (block) {
            block(NO, @"服务器异常");
        }
        return;
    }
    NSComparisonResult result1 = [date compare:_startTime];
    NSComparisonResult result2 = [date compare:_endTime];
    if (result1 == NSOrderedDescending || (result2 == NSOrderedAscending )) {
        
        long long t = ((int)timeInterval % ((int)_enablePeriodTime + (int)_disablePeriodTime));
        
        if (t >= _enablePeriodTime) {
            t = ((int)_enablePeriodTime + (int)_disablePeriodTime) - t;
            long hours = t / 360;
            long min = ((int)(t / 60)) % 60;
            long sec = ((int)t) % 60;
            NSString *tstr = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hours, min, sec];
            if (block) {
                block(NO, tstr);
            }
            return;
        } else {
            long hours = (_enablePeriodTime - t)/360;
            long min = ((int)((_enablePeriodTime - t) / 60)) % 60;
            long sec = ((int)(_enablePeriodTime - t)) % 60;
            NSString *tstr = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hours, min, sec];
            if (block) {
                block(YES, tstr);
            }
            return;
        }
    } else {
        if (block) {
            block(NO, @"请等待，未开盘");
        }
        return;
    }
    
}


- (NSString *)getCurrentOrderNum:(NSString *)datestr andExterTime:(NSTimeInterval)extime {
    
    if (!datestr) {
        return @"";
    }
    
    if ([_startTime compare:_endTime] == NSOrderedAscending) {
        NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
        
        int t = (currentTime + extime - [_startTime timeIntervalSince1970]) / (_enablePeriodTime + _disablePeriodTime);
        
        NSString *str = [datestr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        str = [NSString stringWithFormat:@"%@%03d", str, t];
        
        return str;
    } else {
        NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970] + 8 * 3600;
        currentTime = currentTime + extime;
        if (currentTime > _startTime.timeIntervalSince1970) {
            currentTime = (long long)(currentTime - (_startTime.timeIntervalSince1970 - _endTime.timeIntervalSince1970)) % (60 * 60 * 24);
            int t = currentTime / (_enablePeriodTime + _disablePeriodTime);
            NSString *str = [datestr stringByReplacingOccurrencesOfString:@"-" withString:@""];
            str = [NSString stringWithFormat:@"%@%03d", str, t];
            
            return str;
        } else {
            
            currentTime = ((long long)currentTime) % (60 * 60 * 24);
            int t = currentTime / (_enablePeriodTime + _disablePeriodTime);
            NSString *str = [datestr stringByReplacingOccurrencesOfString:@"-" withString:@""];
            str = [NSString stringWithFormat:@"%@%03d", str, t];
            
            return str;
        }

    }
}





@end
