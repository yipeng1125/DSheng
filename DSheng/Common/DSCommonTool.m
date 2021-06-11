//
//  DSCommonTool.m
//  DSheng
//
//  Created by works_yip on 2020/3/9.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import "DSCommonTool.h"

@implementation DSCommonTool

+ (CGRect)getStringRect:(NSString *)name withFont:(UIFont *)font {
    
    NSDictionary *attributes = @{NSFontAttributeName: font};
    
    CGRect sz = [name boundingRectWithSize:CGSizeMake(200, CGFLOAT_MAX)
                                   options:NSStringDrawingUsesLineFragmentOrigin
                                attributes:attributes
                                   context:nil];
    
    return sz;
}

+ (BOOL)checkIsPhoneNumber:(NSString *)number {
    //2018最新手机段号正则
    NSString *phoneRegex = @"^((13[0-9])|(14[5|6|7|8])|(15[0|1|2|3|5|6|7|8|9])|(166)|(17[2|3|5|6|7|8])|(18[0-9])|(19[8|9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:number];
}

+ (BOOL)checkIsNumber:(NSString *)number {
    //2018最新手机段号正则
    NSString *phoneRegex = @"[0-9]*";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:number];
}


+ (NSString *)getSaveDataPath {
    NSString *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    
    NSString *path = [libraryPath stringByAppendingPathComponent:@"userinfo"];
    
    return path;

}


+ (void)removeUserInfo {
 
    NSString *path = [self getSaveDataPath];

    NSError *error;

    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    
    NSLog(@"error : %@", error);
}

+ (BOOL)saveUserInfo:(NSDictionary *)info {
    
    if (!info) {
        return NO;
    }
    
    NSError *error;
    NSData *data;
    
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue >= 11.0) {
        data = [NSKeyedArchiver archivedDataWithRootObject:info requiringSecureCoding:YES error:&error];
    } else {
        data = [NSKeyedArchiver archivedDataWithRootObject:info];
    }

    
    if (error) {
        NSLog(@"save data error : %@", error);
        return NO;
    }
    NSString *path = [self getSaveDataPath];
    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    
    return [data writeToFile:path atomically:YES];
    
}


+ (NSDictionary *)getUserInfo {
    
    NSData *data = [NSData dataWithContentsOfFile:[self getSaveDataPath]];
    NSError *error;
    
    id value;
    
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue >= 11.0) {
        value = [NSKeyedUnarchiver unarchivedObjectOfClass:NSDictionary.class fromData:data error:&error];
    } else {
        value = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    return value;
}

+ (UIImage*)imageFromColor:(UIColor*)color size:(CGSize)size {
    
    CGRect rect=CGRectMake(0.0f, 0.0f, size.width,size.height);
    UIGraphicsBeginImageContext(size);//创建图片
    CGContextRef context = UIGraphicsGetCurrentContext();//创建图片上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);//设置当前填充颜色的图形上下文
    CGContextFillRect(context, rect);//填充颜色
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}





@end
