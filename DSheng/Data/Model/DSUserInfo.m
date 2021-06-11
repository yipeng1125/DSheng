//
//  DSUserInfo.m
//  DSheng
//
//  Created by works_yip on 2020/3/21.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import "DSUserInfo.h"

@implementation DSUserInfo

- (instancetype)initWithString:(NSString *)message {
    
    self = [super init];
    
    if (!message) {
        return self;
    }
    
    NSArray *content = [message componentsSeparatedByString:@";"];
    if (content.count < 3) {
        return self;
    }
    
    NSString *userid = content.firstObject;
    NSString *bmoney = content[1];
    NSString *str = content[2];
    
    _userID = userid;
    _balanceMoney = bmoney;
    if ([str isEqualToString:@"false"]) {
        _isAgency = NO;
    } else {
        _isAgency = YES;
    }
    
    _todayPayCount = content[3];
    _todayWinCount = content[4];
    _todayTakeCount = content[5];
    
    _todayExtCount = [NSString stringWithFormat:@"%.2f", (_todayWinCount.doubleValue - _todayPayCount.doubleValue)];
    
    return self;
}

@end
