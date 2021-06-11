//
//  DSMyRecordCell.h
//  DSheng
//
//  Created by works_yip on 2020/4/11.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSMyRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView withIdentifyid:(NSString *)identifyid;

@end

NS_ASSUME_NONNULL_END
