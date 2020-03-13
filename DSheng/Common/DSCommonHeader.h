//
//  DSCommonHeader.h
//  DSheng
//
//  Created by works_yip on 2020/3/7.
//  Copyright © 2020 works_yip. All rights reserved.
//

#ifndef DSCommonHeader_h
#define DSCommonHeader_h

#import "UIView+Extension.h"

// RGB颜色
#define DSColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define DSRandomColor DSColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
#define DSScreenSize [UIScreen mainScreen].bounds.size


#define DS_USER_KEY @"ph_acount"

#define DS_USER_PSD_KEY @"ph_psd"


#ifndef FmtStr
#define FmtStr(fmt,...) [NSString stringWithFormat:(fmt), ##__VA_ARGS__]
#endif

#endif /* DSCommonHeader_h */
