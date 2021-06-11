//
//  DSPayHistoryViewController.h
//  DSheng
//
//  Created by works_yip on 2020/4/14.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSPayHistoryViewController : UIViewController

@property(nonatomic, assign)NSInteger type;

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollview;

@end

NS_ASSUME_NONNULL_END
