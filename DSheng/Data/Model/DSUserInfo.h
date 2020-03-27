//
//  DSUserInfo.h
//  DSheng
//
//  Created by works_yip on 2020/3/21.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSUserInfo : NSObject

@property(nonatomic, copy)NSString *userID;
@property(nonatomic, copy)NSString *balanceMoney;

@property(nonatomic, assign)BOOL isAgency;

- (instancetype)initWithString:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
