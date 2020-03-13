//
//  DSCacheDataManager.m
//  DSheng
//
//  Created by works_yip on 2020/3/10.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import "DSCacheDataManager.h"
#import "DSDataCommonHeader.h"

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
        
    }
    return self;
}

- (void)clearData {
    [_lotteryTicketInfoList removeAllObjects];
    [_oddsList removeAllObjects];
}


@end
