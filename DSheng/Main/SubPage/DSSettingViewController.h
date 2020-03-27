//
//  DSSettingViewController.h
//  DSheng
//
//  Created by works_yip on 2020/3/24.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSSettingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *logoutActoin;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableviewConstraintHeight;

@end

NS_ASSUME_NONNULL_END
