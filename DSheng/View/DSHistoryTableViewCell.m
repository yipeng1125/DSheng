//
//  DSHistoryTableViewCell.m
//  DSheng
//
//  Created by works_yip on 2020/3/17.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import "DSHistoryTableViewCell.h"

@implementation DSHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (instancetype)cellWithTableView:(UITableView *)tableView withIdentifyid:(NSString *)identifyid withParameters:(NSString *)parameter {
    
    DSHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifyid];
    if (!cell) {
        NSArray * nibObjects = [[NSBundle mainBundle] loadNibNamed:@"DSHistoryTableViewCell" owner:nil options:nil];
        
        for (id obj in nibObjects) {
            if ([obj isKindOfClass:[DSHistoryTableViewCell class]]) {
                cell = obj;
                [cell setValue:identifyid forKey:@"reuseIdentifier"];
                [self makeCell:cell withData:parameter];
                //                [self makeImageView:cell];
                break;
            }
        }
    }
    
    
    return cell;
}


+ (void)makeCell:(DSHistoryTableViewCell *)cell withData:(NSString *)message {
    NSArray *contents = [message componentsSeparatedByString:@","];
    
    NSLog(@"message : %@", message);
    for (int i = 0; i < contents.count; i++) {
        double posizitionX = i * (24 + 5);
        UILabel *label = [self makeLabel];
        label.x = posizitionX;
        label.y = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"%@", contents[i]];
        label.textColor = UIColor.whiteColor;
        label.font = [UIFont systemFontOfSize:12.0];
        [cell.numberView addSubview:label];
        
    }
}


+ (UILabel *)makeLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    label.layer.cornerRadius = label.height * 0.5;
    label.layer.masksToBounds = YES;
    label.backgroundColor = DSColor(236, 107, 44);
    
    return label;
}



@end
