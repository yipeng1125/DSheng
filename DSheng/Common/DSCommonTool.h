//
//  DSCommonTool.h
//  DSheng
//
//  Created by works_yip on 2020/3/9.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSCommonTool : NSObject

+ (BOOL)checkIsPhoneNumber:(NSString *)number;


+ (BOOL)saveUserInfo:(NSDictionary *)info;
+ (NSDictionary *)getUserInfo;

@end

NS_ASSUME_NONNULL_END
