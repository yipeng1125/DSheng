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
    NSString *str = content.lastObject;
    
    _userID = userid;
    _balanceMoney = bmoney;
    if ([str isEqualToString:@"false"]) {
        _isAgency = NO;
    } else {
        _isAgency = YES;
    }
    
    return self;
}

@end
