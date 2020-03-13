//
//  DSAPIReqeust.h
//  DSheng
//
//  Created by works_yip on 2020/3/9.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSNetHeader.h"
#import "DSAPIRequest.h"


NS_ASSUME_NONNULL_BEGIN

@interface DSAPIRequest : NSObject


- (void)loginReqeust:(NSString *)account
            passWord:(NSString *)password
             success:(reqeustSuccessBlock) sblock
              failed:(reqeustFailedBlock)fblock;



- (void)registerReqeust:(NSString *)account
               passWord:(NSString *)password
            serviceCode:(NSString *)code
                takePSD:(NSString *)tpsd
             success:(reqeustSuccessBlock) sblock
              failed:(reqeustFailedBlock)fblock;

- (void)lotteryTicketTInfoRequest:(reqeustSuccessBlock)sblock failed:(reqeustFailedBlock)fblock;

@end

NS_ASSUME_NONNULL_END
