//
//  DSShareViewController.h
//  DSheng
//
//  Created by works_yip on 2020/3/21.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    DS_PageType_Shared = 1,
    DS_PageType_Agent,
    DS_PageType_Service,
    DS_PageType_Take,
    
}DS_PageType;

@interface DSShareViewController : UIViewController

@property(nonatomic, assign)DS_PageType type;

@end

NS_ASSUME_NONNULL_END
