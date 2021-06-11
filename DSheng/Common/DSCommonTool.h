//
//  DSCommonTool.h
//  DSheng
//
//  Created by works_yip on 2020/3/9.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface DSCommonTool : NSObject

+ (BOOL)checkIsPhoneNumber:(NSString *)number;
+ (BOOL)checkIsNumber:(NSString *)number;

+ (void)removeUserInfo;

+ (BOOL)saveUserInfo:(NSDictionary *)info;
+ (NSDictionary *)getUserInfo;

+ (CGRect)getStringRect:(NSString *)name withFont:(UIFont *)font;

+ (UIImage*)imageFromColor:(UIColor*)color size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
