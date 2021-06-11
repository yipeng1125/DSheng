//
//  DSMyRecordCell.m
//  DSheng
//
//  Created by works_yip on 2020/4/11.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import "DSMyRecordCell.h"

@implementation DSMyRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (instancetype)cellWithTableView:(UITableView *)tableView withIdentifyid:(NSString *)identifyid {
    
    DSMyRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifyid];
    if (!cell) {
        NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"DSMyRecordCell" owner:nil options:nil];
        
        for (id obj in nibObjects) {
            if ([obj isKindOfClass:[DSMyRecordCell class]]) {
                cell = obj;
                [cell setValue:identifyid forKey:@"reuseIdentifier"];
                break;
            }
        }
    }
    
    
    return cell;
}

@end
