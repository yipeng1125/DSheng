//
//  DSCacheDataManager.h
//  DSheng
//
//  Created by works_yip on 2020/3/10.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



@interface DSCacheDataManager : NSObject

+ (instancetype)shareManager;

@property(nonatomic, strong) NSMutableArray *lotteryTicketInfoList;
@property(nonatomic, assign) NSTimeInterval deviationTime;
@property(nonatomic, strong) NSMutableArray *oddsList;

- (void)clearData;


@end

NS_ASSUME_NONNULL_END
