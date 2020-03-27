//
//  DSPayViewController.h
//  DSheng
//
//  Created by works_yip on 2020/3/11.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSPayViewController : UIViewController

@property(nonatomic, assign)DSLotteryTicketType ltType;
@property(nonatomic, copy)NSString *winnerString;
- (void)setSelectLotteryTicket:(NSArray *)datas;

+ (void)updateRemainTime:(NSString *)msg;

@end

NS_ASSUME_NONNULL_END
