//
//  DSKeyChain.h
//  DSheng
//
//  Created by works_yip on 2020/3/9.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSKeyChain : NSObject

+ (BOOL)setPassword:(NSString *)aPassword username:(NSString *)aUsername domain:(NSString *)aDomain error:(NSError **)aError;

@end

NS_ASSUME_NONNULL_END
