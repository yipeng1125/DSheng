//
//  DSNetworkManger.h
//  DSheng
//
//  Created by works_yip on 2020/3/9.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSNetHeader.h"

NS_ASSUME_NONNULL_BEGIN



@interface DSNetworkManger : NSObject

+ (instancetype)shareManager;

- (void)sendPostRequesttoUrl:(NSString *)url
                        body:(NSString *)bodystr
                   parameter:(NSDictionary *)paremters
                     success:(reqeustSuccessBlock)successBlock
                     failure:(reqeustFailedBlock)failureBlock;

@end

NS_ASSUME_NONNULL_END
