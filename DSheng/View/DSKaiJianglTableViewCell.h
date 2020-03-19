//
//  DSKaiJianglTableViewCell.h
//  DSheng
//
//  Created by works_yip on 2020/3/15.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSKaiJianglTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *numberView;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;
@property (weak, nonatomic) IBOutlet UILabel *title;

+ (instancetype)cellWithTableView:(UITableView *)tableView withIdentifyid:(NSString *)identifyid withParameters:(NSString *)parameter;

@end

NS_ASSUME_NONNULL_END
