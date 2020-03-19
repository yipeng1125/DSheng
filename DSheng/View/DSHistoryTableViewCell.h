//
//  DSHistoryTableViewCell.h
//  DSheng
//
//  Created by works_yip on 2020/3/17.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSHistoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLabel2;
@property (weak, nonatomic) IBOutlet UIView *numberView;

+ (instancetype)cellWithTableView:(UITableView *)tableView withIdentifyid:(NSString *)identifyid withParameters:(NSString *)parameter;

@end

NS_ASSUME_NONNULL_END
