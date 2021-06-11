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
@property(nonatomic, assign)DSLTType detailType;
@property(nonatomic, copy)NSString *winnerString;

@property(nonatomic, copy)NSString *nextNumString;
- (void)setSelectLotteryTicket:(NSArray *)datas;

+ (void)updateRemainTime:(NSString *)msg enable:(BOOL)enable;

@end

NS_ASSUME_NONNULL_END
