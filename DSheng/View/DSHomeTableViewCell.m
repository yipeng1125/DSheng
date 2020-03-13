//
//  DSHomeTableViewCell.m
//  DSheng
//
//  Created by works_yip on 2020/3/10.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import "DSHomeTableViewCell.h"

@implementation DSHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView withIdentifyid:(NSString *)identifyid {
    static NSString *cellId = @"cell";
    DSHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifyid];
    if (!cell) {
        cell = [[DSHomeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    return cell;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        // 点击cell的时候不要变色
        //self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setCellContent];
    }
    
    return self;
}

- (void)setCellContent {
    
}

@end
