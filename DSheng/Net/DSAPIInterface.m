//
//  DSAPIInterface.m
//  DSheng
//
//  Created by works_yip on 2020/3/10.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import "DSAPIInterface.h"
#import "DSAPIRequest.h"

@implementation DSAPIInterface


+ (void)loginAPIReqeust:(NSString *)account passWord:(NSString *)password success:(reqeustSuccessBlock)sblock failed:(reqeustFailedBlock)fblock {
    
    DSAPIRequest *apiReqeust = [DSAPIRequest new];
    [apiReqeust loginReqeust:account passWord:password success:^(id result) {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *responseStr = [[NSString alloc] initWithData:result encoding:enc];
        if ([responseStr isEqualToString:@"ok"]) {
            if (sblock) {
                sblock(responseStr);
            }
        } else {
            if (fblock) {
                NSError *err = [NSError errorWithDomain:responseStr code:1001 userInfo:nil];
                fblock(err);
            }
        }
    } failed:^(NSError *error) {
        if (fblock) {
            fblock(error);
        }
    }];
}

+ (void)registerAPIReqeust:(NSString *)account passWord:(NSString *)password serviceCode:(NSString *)code takePSD:(NSString *)tpsd success:(reqeustSuccessBlock)sblock failed:(reqeustFailedBlock)fblock {
    
    DSAPIRequest *apiReqeust = [DSAPIRequest new];
    [apiReqeust registerReqeust:account passWord:password serviceCode:code takePSD:tpsd success:^(id result) {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *responseStr = [[NSString alloc] initWithData:result encoding:enc];
        if ([responseStr isEqualToString:@"ok"]) {
            if (sblock) {
                sblock(responseStr);
            }
        } else {
            if (fblock) {
                NSError *err = [NSError errorWithDomain:responseStr code:1001 userInfo:nil];
                fblock(err);
            }
        }
    } failed:^(NSError *error) {
        if (fblock) {
            fblock(error);
        }
    }];
}

+ (void)lotteryTicketTInfoAPIRequest:(reqeustSuccessBlock)sblock failed:(reqeustFailedBlock)fblock {
    
    DSAPIRequest *apiReqeust = [DSAPIRequest new];
    [apiReqeust lotteryTicketTInfoRequest:^(id result) {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *responseStr = [[NSString alloc] initWithData:result encoding:enc];
        NSArray *resposneData = [responseStr componentsSeparatedByString:@"|"];
        if (sblock) {
            sblock(resposneData);
        }
    } failed:^(NSError *error) {
        if (fblock) {
            fblock(error);
        }
    }];
}


+ (void)getUserInfoAPIReqeust:(NSDictionary *)parameters success:(reqeustSuccessBlock)sblock failed:(reqeustFailedBlock)fblock {
    DSAPIRequest *apiReqeust = [DSAPIRequest new];

    [apiReqeust userinfoRequest:parameters sucess:^(id result) {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *responseStr = [[NSString alloc] initWithData:result encoding:enc];
        NSLog(@"%@", responseStr);
        
        if (sblock) {
            sblock(responseStr);
        }
    } failed:^(NSError *error) {
        NSLog(@"error : %@", error);
        if (fblock) {
            fblock(error);
        }
    }];
}

+ (void)getWinnerInfoAPIRequest:(NSInteger)index success:(reqeustSuccessBlock)sblock failed:(reqeustFailedBlock)fblock {
    
    DSAPIRequest *apiReqeust = [DSAPIRequest new];
    [apiReqeust winnerInfoRequest:index success:^(id result) {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *responseStr = [[NSString alloc] initWithData:result encoding:enc];
        NSLog(@"%@", responseStr);
        
        if (sblock) {
            sblock(responseStr);
        }
    } failed:^(NSError *error) {
        NSLog(@"error : %@", error);
        if (fblock) {
            fblock(error);
        }
    }];
}

+ (void)getTrendInfoAPIRequest:(reqeustSuccessBlock)sblock failed:(reqeustFailedBlock)fblock {
    DSAPIRequest *apiReqeust = [DSAPIRequest new];
    [apiReqeust trendInfoRequest:^(id result) {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *responseStr = [[NSString alloc] initWithData:result encoding:enc];
        NSLog(@"%@", responseStr);
        
        if (sblock) {
            sblock(responseStr);
        }
    } failed:^(NSError *error) {
        NSLog(@"error : %@", error);
        if (fblock) {
            fblock(error);
        }
    }];
}

+ (void)getAllWinnerInfoReqeust:(reqeustSuccessBlock)sblock failed:(reqeustFailedBlock)fblock {
    DSAPIRequest *apiReqeust = [DSAPIRequest new];
    [apiReqeust allWinnerInfoRequest:^(id result) {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *responseStr = [[NSString alloc] initWithData:result encoding:enc];
        
        if (sblock) {
            sblock(responseStr);
        }
    } failed:^(NSError *error) {
        NSLog(@"error : %@", error);
        if (fblock) {
            fblock(error);
        }
    }];
}

@end
