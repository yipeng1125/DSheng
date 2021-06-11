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


+ (void)getUserInfoAPIReqeust:(NSDictionary *)parameters success:(reqeustSuccessBlock)sblock failed:(reqeustFailedBlock)fblock;

+ (void)getWinnerInfoAPIRequest:(NSInteger)index success:(reqeustSuccessBlock)sblock failed:(reqeustFailedBlock)fblock;

+ (void)getTrendInfoAPIRequest:(reqeustSuccessBlock)sblock failed:(reqeustFailedBlock)fblock;

+ (void)getAllWinnerInfoReqeust:(reqeustSuccessBlock)sblock failed:(reqeustFailedBlock)fblock;

+ (void)getOddsListRequest:(reqeustSuccessBlock)sblock failed:(reqeustFailedBlock)fblock;

+ (void)sendModifyPasswordReqeust:(NSString *)account oldPassword:(NSString *)oldPsd andNew:(NSString *)newPsd success:(reqeustSuccessBlock)sblock failed:(reqeustFailedBlock)fblock;

+ (void)sendModifyTakePasswordReqeust:(NSString *)account psd:(NSString *)psd oldPassword:(NSString *)oldPsd andNew:(NSString *)newPsd success:(reqeustSuccessBlock)sblock failed:(reqeustFailedBlock)fblock;

+ (void)sendCommitTicketLotteryRequest:(NSString *)type detailType:(NSString *)dtype number:(NSString *)num totalMoney:(double)tmoney content:(NSString *)content success:(reqeustSuccessBlock)sblock failed:(reqeustFailedBlock)fblock;



+ (void)getRechageHistoryRequest:(reqeustSuccessBlock)sblock failed:(reqeustFailedBlock)fblock;

+ (void)getTakeHistoryRequest:(reqeustSuccessBlock)sblock failed:(reqeustFailedBlock)fblock;

+ (void)getPayHistoryRequest:(reqeustSuccessBlock)sblock failed:(reqeustFailedBlock)fblock;

+ (void)getZhongjiangHistoryRequest:(reqeustSuccessBlock)sblock failed:(reqeustFailedBlock)fblock;

+ (void)getReturnMoneyInfoRequest:(reqeustSuccessBlock)sblock failed:(reqeustFailedBlock)fblock;

+ (void)commitReturnMoneyRequest:(reqeustSuccessBlock)sblock failed:(reqeustFailedBlock)fblock;

@end

NS_ASSUME_NONNULL_END
