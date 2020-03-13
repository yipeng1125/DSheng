//
//  DSAPIInterface.h
//  DSheng
//
//  Created by works_yip on 2020/3/10.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSNetHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSAPIInterface : NSObject

+ (void)loginAPIReqeust:(NSString *)account
            passWord:(NSString *)password
             success:(reqeustSuccessBlock) sblock
              failed:(reqeustFailedBlock)fblock;



+ (void)registerAPIReqeust:(NSString *)account
               passWord:(NSString *)password
            serviceCode:(NSString *)code
                takePSD:(NSString *)tpsd
                success:(reqeustSuccessBlock) sblock
                 failed:(reqeustFailedBlock)fblock;

+ (void)lotteryTicketTInfoAPIRequest:(reqeustSuccessBlock)sblock failed:(reqeustFailedBlock)fblock;


@end

NS_ASSUME_NONNULL_END
