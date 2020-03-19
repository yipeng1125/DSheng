//
//  DSRule.h
//  DSheng
//
//  Created by works_yip on 2020/3/17.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



typedef void(^returnBlock) (NSString *total, NSString *longhu);


@interface DSRule : NSObject


+ (void)returnResul:(NSString *)result andType:(DSLotteryTicketType)type andBock:(void(^)(NSString *total, NSString *longhu))block;


@end

NS_ASSUME_NONNULL_END
