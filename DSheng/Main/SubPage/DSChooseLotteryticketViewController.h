//
//  DSChooseLotteryticketViewController.h
//  DSheng
//
//  Created by works_yip on 2020/3/11.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSViewHeader.h"
#import "DSDataCommonHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSChooseLotteryticketViewController : UIViewController

@property(nonatomic, assign) DSLotteryTicketType ltType;
@property(nonatomic, assign) DSLTType detailType;

@property(nonatomic, assign) BOOL enablePayLotteryTicket;



@end

NS_ASSUME_NONNULL_END
